// Dart imports:
import 'dart:async';
import 'dart:collection';

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_change.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/product_price_alert_notification_coordinator.dart';

/// Fetches and persists product sources through bounded, per-merchant-domain
/// queues — never two concurrent fetches to the same merchant, several
/// different merchants at once. A source enqueued mid-run lands in its own
/// merchant's queue without waiting for anything else in flight.
class ProductSourceRefreshEngine {
  final ProductsLocalDatasource _localDatasource;
  final IProductsRemoteDatasource _remoteDatasource;
  final ProductPriceAlertNotificationCoordinator _priceAlertCoordinator;

  /// Creates an engine backed by local and remote product datasources, and a
  /// [ProductPriceAlertNotificationCoordinator] for best-price-change alerts.
  ProductSourceRefreshEngine(
    this._localDatasource,
    this._remoteDatasource,
    this._priceAlertCoordinator,
  );

  static const int _maxConcurrentMerchantQueues = 4;

  final Map<String, Queue<(ProductSourceModel, bool)>> _pendingByMerchant = {};
  final Set<String> _merchantsInFlight = {};
  final Set<String> _sourceIdsQueuedOrInFlight = {};
  Completer<void>? _wakeSignal;
  bool _workersStarted = false;
  int _totalInCurrentRun = 0;
  int _completedInCurrentRun = 0;

  /// Called with (completed, total) counts for the sources currently active
  /// or queued, whenever those counts change. Unset by default — assigned by
  /// whichever isolate wants to surface live progress (the background
  /// entrypoint, for its notification's progress bar).
  void Function(int completed, int total)? onProgress;

  /// Queues [sourceIds] onto their merchant-specific fetch queues, starting
  /// worker processing if it isn't already running. [bypassCooldown] applies
  /// to every source in this call. Returns once every source is queued and
  /// its live status is persisted — the actual fetch results are not
  /// awaited here, they flow through the database as each source completes.
  Future<Either<Failure, Unit>> enqueueSourceRefresh(
    List<String> sourceIds, {
    bool bypassCooldown = false,
  }) async {
    if (sourceIds.isEmpty) {
      return const Right(unit);
    }
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    if (sourcesResult.isLeft()) {
      return sourcesResult.map((_) => unit);
    }
    final Set<String> requestedIds = sourceIds.toSet();
    int newlyQueuedCount = 0;
    for (final ProductSourceModel source
        in sourcesResult.getRight().toNullable() ?? const []) {
      if (!requestedIds.contains(source.id) ||
          _sourceIdsQueuedOrInFlight.contains(source.id)) {
        continue;
      }
      _sourceIdsQueuedOrInFlight.add(source.id);
      _pendingByMerchant
          .putIfAbsent(
            source.merchantDomain.toLowerCase(),
            () => Queue<(ProductSourceModel, bool)>(),
          )
          .add((source, bypassCooldown));
      await _localDatasource.writeSourceLiveStatus(
        source.id,
        SourceRefreshStatus.queued,
      );
      newlyQueuedCount++;
    }
    if (newlyQueuedCount > 0) {
      _totalInCurrentRun += newlyQueuedCount;
      onProgress?.call(_completedInCurrentRun, _totalInCurrentRun);
    }
    _ensureWorkersRunning();
    _wakeWorkers();
    return const Right(unit);
  }

  void _ensureWorkersRunning() {
    if (_workersStarted) {
      return;
    }
    _workersStarted = true;
    for (int i = 0; i < _maxConcurrentMerchantQueues; i++) {
      unawaited(_runMerchantQueueWorker());
    }
  }

  Future<void> _runMerchantQueueWorker() async {
    while (true) {
      final String? merchant = _claimPendingMerchant();
      if (merchant == null) {
        _resetProgressIfDrained();
        await _waitForQueuedWork();
        continue;
      }
      final Queue<(ProductSourceModel, bool)> queue =
          _pendingByMerchant[merchant]!;
      while (queue.isNotEmpty) {
        final (ProductSourceModel source, bool bypassCooldown) = queue
            .removeFirst();
        await _fetchAndPersistSource(source, bypassCooldown: bypassCooldown);
        _sourceIdsQueuedOrInFlight.remove(source.id);
        _completedInCurrentRun++;
        onProgress?.call(_completedInCurrentRun, _totalInCurrentRun);
      }
      _pendingByMerchant.remove(merchant);
      _merchantsInFlight.remove(merchant);
    }
  }

  void _resetProgressIfDrained() {
    if (_pendingByMerchant.isEmpty && _merchantsInFlight.isEmpty) {
      _totalInCurrentRun = 0;
      _completedInCurrentRun = 0;
    }
  }

  String? _claimPendingMerchant() {
    for (final String merchant in _pendingByMerchant.keys) {
      if (!_merchantsInFlight.contains(merchant)) {
        _merchantsInFlight.add(merchant);
        return merchant;
      }
    }
    return null;
  }

  Future<void> _waitForQueuedWork() async {
    final Completer<void> signal = _wakeSignal ??= Completer<void>();
    await signal.future;
  }

  void _wakeWorkers() {
    final Completer<void>? signal = _wakeSignal;
    _wakeSignal = null;
    if (signal != null && !signal.isCompleted) {
      signal.complete();
    }
  }

  Future<void> _fetchAndPersistSource(
    ProductSourceModel source, {
    required bool bypassCooldown,
  }) async {
    final Either<Failure, ProductModel> previousResult = await _localDatasource
        .loadProduct(source.productId);
    final ProductModel? previousProduct = previousResult
        .getRight()
        .toNullable();

    final Either<Failure, ProductSourceModel> result = await _fetchSource(
      source,
      onSourceStatusChanged:
          (String sourceId, SourceRefreshStatus status) async {
            await _localDatasource.writeSourceLiveStatus(sourceId, status);
          },
      bypassCooldown: bypassCooldown,
    );
    final ProductSourceModel updatedSource = result.match(
      (Failure failure) => _sourceAfterFailure(source, failure),
      (ProductSourceModel updated) => updated,
    );
    final Either<Failure, ProductModel> persistResult = await _localDatasource
        .updateSourcePrices(source.productId, [updatedSource]);
    await _localDatasource.writeSourceLiveStatus(source.id, null);

    final ProductModel? refreshedProduct = persistResult.getRight().toNullable();
    if (previousProduct != null && refreshedProduct != null) {
      await _notifyPriceChange(previousProduct, refreshedProduct);
    }
  }

  Future<void> _notifyPriceChange(
    Product previousProduct,
    Product refreshedProduct,
  ) async {
    final Money? previousBestPrice =
        previousProduct.bestAvailablePrice?.currentPrice;
    final Money? currentBestPrice =
        refreshedProduct.bestAvailablePrice?.currentPrice;
    if (previousBestPrice == null || currentBestPrice == null) {
      return;
    }
    if (previousBestPrice.currencyCode != currentBestPrice.currencyCode) {
      return;
    }
    final PriceChangeDirection direction = switch (currentBestPrice
        .minorUnits) {
      final int minorUnits when minorUnits < previousBestPrice.minorUnits =>
        PriceChangeDirection.drop,
      final int minorUnits when minorUnits > previousBestPrice.minorUnits =>
        PriceChangeDirection.increase,
      _ => PriceChangeDirection.none,
    };
    if (direction == PriceChangeDirection.none) {
      return;
    }
    await _priceAlertCoordinator.notify(
      ProductPriceChange(
        product: refreshedProduct,
        previousBestPrice: previousBestPrice,
        currentBestPrice: currentBestPrice,
        direction: direction,
      ),
    );
  }

  Future<Either<Failure, ProductSourceModel>> _fetchSource(
    ProductSourceModel source, {
    SourceRefreshListener? onSourceStatusChanged,
    bool bypassCooldown = false,
  }) async {
    await onSourceStatusChanged?.call(source.id, SourceRefreshStatus.fetching);
    final Either<Failure, ProductSourceModel> result = bypassCooldown
        ? await _remoteDatasource.fetchPrices(source, bypassCooldown: true)
        : await _remoteDatasource.fetchPrices(source);
    await result.match(
      (Failure failure) async {
        await onSourceStatusChanged?.call(source.id, SourceRefreshStatus.error);
      },
      (ProductSourceModel updated) async {
        await onSourceStatusChanged?.call(
          source.id,
          updated.isAvailable == true
              ? SourceRefreshStatus.success
              : SourceRefreshStatus.unavailable,
        );
      },
    );
    return result;
  }

  ProductSourceModel _sourceAfterFailure(
    ProductSourceModel source,
    Failure failure,
  ) => ProductSourceModel(
    id: source.id,
    productId: source.productId,
    url: source.url,
    merchantDomain: source.merchantDomain,
    createdAt: source.createdAt,
    currentPrice: source.currentPrice,
    previousPrice: source.previousPrice,
    isAvailable: source.isAvailable,
    lastCheckedAt: source.lastCheckedAt,
    priceChangedAt: source.priceChangedAt,
    lastRefreshStatus: failure is PriceFetchFailure
        ? failure.status
        : PriceFetchStatus.networkError,
  );
}
