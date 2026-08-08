// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_drop.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Implements [IProductsRepository] with local and remote product data.
class ProductsRepository implements IProductsRepository {
  static const int _maxConcurrentMerchantQueues = 4;

  final ProductsLocalDatasource _localDatasource;
  final IProductsRemoteDatasource _remoteDatasource;

  /// Creates a repository backed by local and remote datasources.
  ProductsRepository(this._localDatasource, this._remoteDatasource);

  @override
  Future<Either<Failure, Product>> createProduct(
    Product product,
    ProductSource? source,
  ) {
    return _localDatasource.createProduct(product, source);
  }

  @override
  Future<Either<Failure, List<Product>>> loadProducts() {
    return _localDatasource.loadProducts();
  }

  @override
  Stream<List<Product>> watchProducts() => _localDatasource.watchProducts();

  @override
  Future<Either<Failure, Product>> refreshProduct(
    String productId, {
    SourceRefreshListener? onSourceStatusChanged,
    ProductPriceDropListener? onPriceDrop,
  }) async {
    ProductModel? previousProduct;
    if (onPriceDrop != null) {
      final Either<Failure, ProductModel> productResult = await _localDatasource
          .loadProduct(productId);
      if (productResult.isLeft()) {
        return productResult.map((ProductModel product) => product);
      }
      previousProduct = productResult.getRight().toNullable();
    }
    final Either<Failure, List<ProductSourceModel>> sourceResult =
        await _localDatasource.loadProductSourcesForProduct(productId);
    return sourceResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      if (sources.isEmpty) {
        return _localDatasource.refreshProduct(productId);
      }
      final List<Either<Failure, ProductSourceModel>> results =
          await _fetchSources(
            sources,
            onSourceStatusChanged: onSourceStatusChanged,
          );
      Failure? firstFailure;
      final List<ProductSourceModel> updatedSources = [];
      for (final (int index, Either<Failure, ProductSourceModel> result)
          in results.indexed) {
        result.match((Failure failure) {
          firstFailure ??= failure;
          updatedSources.add(_sourceAfterFailure(sources[index], failure));
        }, updatedSources.add);
      }
      final Either<Failure, Product> savedResult = await _localDatasource
          .updateSourcePrices(productId, updatedSources);
      if (savedResult.isLeft()) {
        return savedResult;
      }
      await _emitPriceDrop(
        previousProduct,
        savedResult.getRight().toNullable()!,
        onPriceDrop,
      );
      final Failure? sourceFailure = firstFailure;
      return sourceFailure == null ? savedResult : Left(sourceFailure);
    });
  }

  @override
  Future<Either<Failure, Product>> refreshSource(
    String sourceId, {
    SourceRefreshListener? onSourceStatusChanged,
    bool bypassCooldown = false,
    ProductPriceDropListener? onPriceDrop,
  }) async {
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    return sourcesResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      ProductSourceModel? source;
      for (final ProductSourceModel candidate in sources) {
        if (candidate.id == sourceId) {
          source = candidate;
          break;
        }
      }
      if (source == null) {
        return const Left(NotFoundFailure('Source not found'));
      }
      final ProductSourceModel loadedSource = source;
      ProductModel? previousProduct;
      if (onPriceDrop != null) {
        final Either<Failure, ProductModel> productResult =
            await _localDatasource.loadProduct(loadedSource.productId);
        if (productResult.isLeft()) {
          return productResult.map((ProductModel product) => product);
        }
        previousProduct = productResult.getRight().toNullable();
      }
      final Either<Failure, ProductSourceModel> result = await _fetchSource(
        loadedSource,
        onSourceStatusChanged: onSourceStatusChanged,
        bypassCooldown: bypassCooldown,
      );
      return result.match(
        (Failure failure) async {
          final Either<Failure, Product> persisted = await _localDatasource
              .updateSourcePrices(loadedSource.productId, [
                _sourceAfterFailure(loadedSource, failure),
              ]);
          await persisted.match(
            (_) async {},
            (Product product) =>
                _emitPriceDrop(previousProduct, product, onPriceDrop),
          );
          return persisted.isLeft() ? persisted : Left(failure);
        },
        (ProductSourceModel updatedSource) async {
          final Either<Failure, Product> persisted = await _localDatasource
              .updateSourcePrices(updatedSource.productId, [updatedSource]);
          await persisted.match(
            (_) async {},
            (Product product) =>
                _emitPriceDrop(previousProduct, product, onPriceDrop),
          );
          return persisted;
        },
      );
    });
  }

  @override
  Future<Either<Failure, List<Product>>> refreshAllProducts({
    SourceRefreshListener? onSourceStatusChanged,
    RefreshSourcesLoadedListener? onSourcesLoaded,
    ProductPriceDropListener? onPriceDrop,
  }) async {
    final Map<String, ProductModel> previousProducts = {};
    if (onPriceDrop != null) {
      final Either<Failure, List<ProductModel>> productsResult =
          await _localDatasource.loadProducts();
      if (productsResult.isLeft()) {
        return productsResult.map((List<ProductModel> products) => products);
      }
      previousProducts.addAll({
        for (final ProductModel product
            in productsResult.getRight().toNullable()!)
          product.id: product,
      });
    }
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    return sourcesResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      await onSourcesLoaded?.call(sources.length);
      final List<Either<Failure, ProductSourceModel>> results =
          await _fetchSources(
            sources,
            onSourceStatusChanged: onSourceStatusChanged,
          );
      final Map<String, List<ProductSourceModel>> updatedSourcesByProduct = {
        for (final ProductSourceModel source in sources)
          source.productId: <ProductSourceModel>[],
      };
      Failure? firstFailure;
      for (final (int index, Either<Failure, ProductSourceModel> result)
          in results.indexed) {
        result.match(
          (Failure failure) {
            firstFailure ??= failure;
            updatedSourcesByProduct[sources[index].productId]!.add(
              _sourceAfterFailure(sources[index], failure),
            );
          },
          (ProductSourceModel updated) => updatedSourcesByProduct
              .putIfAbsent(updated.productId, () => <ProductSourceModel>[])
              .add(updated),
        );
      }
      for (final MapEntry<String, List<ProductSourceModel>> entry
          in updatedSourcesByProduct.entries) {
        final Either<Failure, ProductModel> savedPrices = await _localDatasource
            .updateSourcePrices(entry.key, entry.value);
        final Failure? failure = savedPrices.getLeft().toNullable();
        if (failure != null) {
          return Left(failure);
        }
        final ProductModel refreshedProduct = savedPrices
            .getRight()
            .toNullable()!;
        await _emitPriceDrop(
          previousProducts[refreshedProduct.id],
          refreshedProduct,
          onPriceDrop,
        );
      }
      final Either<Failure, List<Product>> refreshedProducts =
          await _localDatasource.refreshAllProducts();
      if (refreshedProducts.isLeft()) {
        return refreshedProducts;
      }
      final Failure? sourceFailure = firstFailure;
      return sourceFailure == null ? refreshedProducts : Left(sourceFailure);
    });
  }

  Future<void> _emitPriceDrop(
    Product? previousProduct,
    Product refreshedProduct,
    ProductPriceDropListener? listener,
  ) async {
    if (listener == null || previousProduct == null) {
      return;
    }
    final Money? previousBestPrice =
        previousProduct.bestAvailablePrice?.currentPrice;
    final Money? currentBestPrice =
        refreshedProduct.bestAvailablePrice?.currentPrice;
    if (previousBestPrice == null || currentBestPrice == null) {
      return;
    }
    if (previousBestPrice.currencyCode != currentBestPrice.currencyCode ||
        currentBestPrice.minorUnits >= previousBestPrice.minorUnits) {
      return;
    }
    await listener(
      ProductPriceDrop(
        product: refreshedProduct,
        previousBestPrice: previousBestPrice,
        currentBestPrice: currentBestPrice,
      ),
    );
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

  Future<List<Either<Failure, ProductSourceModel>>> _fetchSources(
    List<ProductSourceModel> sources, {
    SourceRefreshListener? onSourceStatusChanged,
  }) async {
    final Map<String, List<ProductSourceModel>> sourcesByMerchant = {};
    for (final ProductSourceModel source in sources) {
      sourcesByMerchant
          .putIfAbsent(source.merchantDomain.toLowerCase(), () => [])
          .add(source);
    }

    final List<List<ProductSourceModel>> merchantQueues = sourcesByMerchant
        .values
        .toList();
    final Map<String, Either<Failure, ProductSourceModel>> resultsBySourceId =
        {};
    int nextQueueIndex = 0;

    Future<void> runQueue() async {
      while (nextQueueIndex < merchantQueues.length) {
        final List<ProductSourceModel> queue = merchantQueues[nextQueueIndex++];
        for (final ProductSourceModel source in queue) {
          resultsBySourceId[source.id] = await _fetchSource(
            source,
            onSourceStatusChanged: onSourceStatusChanged,
          );
        }
      }
    }

    final int workerCount = merchantQueues.length < _maxConcurrentMerchantQueues
        ? merchantQueues.length
        : _maxConcurrentMerchantQueues;
    await Future.wait(List.generate(workerCount, (_) => runQueue()));

    return sources
        .map((ProductSourceModel source) => resultsBySourceId[source.id])
        .whereType<Either<Failure, ProductSourceModel>>()
        .toList();
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

  @override
  Future<Either<Failure, Product>> addSource(ProductSource source) async {
    final Either<Failure, ProductSourceModel> priceResult =
        await _remoteDatasource.fetchPrices(source);
    return priceResult.match(
      (Failure failure) async => Left(failure),
      (ProductSourceModel pricedSource) =>
          _localDatasource.addSourceWithPrice(pricedSource),
    );
  }

  @override
  Future<Either<Failure, Product>> updateSource(
    String sourceId,
    String url,
  ) async {
    final ProductSource candidate = ProductSource(
      id: sourceId,
      productId: '',
      url: url,
      merchantDomain: '',
      createdAt: DateTime.now(),
    );
    final Either<Failure, ProductSourceModel> priceResult =
        await _remoteDatasource.fetchPrices(candidate);
    return priceResult.match(
      (Failure failure) async => Left(failure),
      (ProductSourceModel pricedSource) =>
          _localDatasource.editSourceWithPrice(sourceId, pricedSource),
    );
  }

  @override
  Future<Either<Failure, Product>> deleteSource(String sourceId) {
    return _localDatasource.deleteSource(sourceId);
  }

  @override
  Future<Either<Failure, Product>> renameProduct(
    String productId,
    String name,
  ) {
    return _localDatasource.renameProduct(productId, name);
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String productId) {
    return _localDatasource.deleteProduct(productId);
  }
}
