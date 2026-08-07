// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
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
  Future<Either<Failure, Product>> refreshProduct(
    String productId, {
    SourceRefreshListener? onSourceStatusChanged,
  }) async {
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
      for (final Either<Failure, ProductSourceModel> result in results) {
        result.match(
          (Failure failure) => firstFailure ??= failure,
          updatedSources.add,
        );
      }
      final Either<Failure, Product> savedResult = await _localDatasource
          .updateSourcePrices(productId, updatedSources);
      if (savedResult.isLeft()) {
        return savedResult;
      }
      final Failure? sourceFailure = firstFailure;
      return sourceFailure == null ? savedResult : Left(sourceFailure);
    });
  }

  @override
  Future<Either<Failure, Product>> refreshSource(
    String sourceId, {
    SourceRefreshListener? onSourceStatusChanged,
    bool bypassCooldown = false,
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
      final Either<Failure, ProductSourceModel> result = await _fetchSource(
        source,
        onSourceStatusChanged: onSourceStatusChanged,
        bypassCooldown: bypassCooldown,
      );
      return result.match(
        (Failure failure) async => Left(failure),
        (ProductSourceModel updatedSource) => _localDatasource
            .updateSourcePrices(updatedSource.productId, [updatedSource]),
      );
    });
  }

  @override
  Future<Either<Failure, List<Product>>> refreshAllProducts({
    SourceRefreshListener? onSourceStatusChanged,
  }) async {
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    return sourcesResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
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
      for (final Either<Failure, ProductSourceModel> result in results) {
        result.match(
          (Failure failure) => firstFailure ??= failure,
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
    onSourceStatusChanged?.call(source.id, SourceRefreshStatus.fetching);
    final Either<Failure, ProductSourceModel> result = bypassCooldown
        ? await _remoteDatasource.fetchPrices(source, bypassCooldown: true)
        : await _remoteDatasource.fetchPrices(source);
    result.match(
      (Failure failure) {
        onSourceStatusChanged?.call(source.id, SourceRefreshStatus.error);
      },
      (ProductSourceModel updated) {
        onSourceStatusChanged?.call(
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
