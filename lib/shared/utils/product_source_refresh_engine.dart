// Dart imports:
import 'dart:async';
import 'dart:collection';

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Fetches and persists product sources through bounded, per-merchant-domain
/// queues — never two concurrent fetches to the same merchant, several
/// different merchants at once. A source enqueued mid-run lands in its own
/// merchant's queue without waiting for anything else in flight.
class ProductSourceRefreshEngine {
  final ProductsLocalDatasource _localDatasource;
  final IProductsRemoteDatasource _remoteDatasource;

  /// Creates an engine backed by local and remote product datasources.
  ProductSourceRefreshEngine(this._localDatasource, this._remoteDatasource);

  static const int _maxConcurrentMerchantQueues = 4;

  final Map<String, Queue<(ProductSourceModel, bool)>> _pendingByMerchant = {};
  final Set<String> _merchantsInFlight = {};
  final Set<String> _sourceIdsQueuedOrInFlight = {};
  Completer<void>? _wakeSignal;
  bool _workersStarted = false;

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
      }
      _pendingByMerchant.remove(merchant);
      _merchantsInFlight.remove(merchant);
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
    await _localDatasource.updateSourcePrices(source.productId, [
      updatedSource,
    ]);
    await _localDatasource.writeSourceLiveStatus(source.id, null);
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
