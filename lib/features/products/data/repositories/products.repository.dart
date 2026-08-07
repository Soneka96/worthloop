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
          await Future.wait(
            sources.map(
              (ProductSourceModel source) => _fetchSource(
                source,
                onSourceStatusChanged: onSourceStatusChanged,
              ),
            ),
          );
      Failure? firstFailure;
      final List<ProductSourceModel> updatedSources = [];
      for (final Either<Failure, ProductSourceModel> result in results) {
        result.match(
          (Failure failure) => firstFailure ??= failure,
          updatedSources.add,
        );
      }
      if (updatedSources.isEmpty) {
        final Failure? sourceFailure = firstFailure;
        return sourceFailure == null
            ? _localDatasource.updateSourcePrices(productId, updatedSources)
            : Left(sourceFailure);
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
  Future<Either<Failure, List<Product>>> refreshAllProducts({
    SourceRefreshListener? onSourceStatusChanged,
  }) async {
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    return sourcesResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      final List<Either<Failure, ProductSourceModel>> results =
          await Future.wait(
            sources.map(
              (ProductSourceModel source) => _fetchSource(
                source,
                onSourceStatusChanged: onSourceStatusChanged,
              ),
            ),
          );
      final Map<String, List<ProductSourceModel>> updatedSourcesByProduct = {};
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
      final Failure? sourceFailure = firstFailure;
      if (sourceFailure != null) {
        return Left(sourceFailure);
      }
      final Either<Failure, List<Product>> refreshedProducts =
          await _localDatasource.refreshAllProducts();
      if (refreshedProducts.isLeft()) {
        return refreshedProducts;
      }
      return refreshedProducts;
    });
  }

  Future<Either<Failure, ProductSourceModel>> _fetchSource(
    ProductSourceModel source, {
    SourceRefreshListener? onSourceStatusChanged,
  }) async {
    onSourceStatusChanged?.call(source.id, SourceRefreshStatus.fetching);
    final Either<Failure, ProductSourceModel> result = await _remoteDatasource
        .fetchPrices(source);
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
