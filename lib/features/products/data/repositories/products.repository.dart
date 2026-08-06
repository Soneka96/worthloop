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
  Future<Either<Failure, Product>> refreshProduct(String productId) async {
    final Either<Failure, List<ProductSourceModel>> sourceResult =
        await _localDatasource.loadProductSourcesForProduct(productId);
    return sourceResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      if (sources.isEmpty) {
        return _localDatasource.refreshProduct(productId);
      }
      final List<ProductSourceModel> updatedSources = [];
      for (final ProductSourceModel source in sources) {
        final Either<Failure, ProductSourceModel> priceResult =
            await _remoteDatasource.fetchPrices(source);
        final Failure? failure = priceResult.getLeft().toNullable();
        if (failure != null) {
          return Left(failure);
        }
        final ProductSourceModel? updated = priceResult.getRight().toNullable();
        if (updated != null) {
          updatedSources.add(updated);
        }
      }
      return _localDatasource.updateSourcePrices(productId, updatedSources);
    });
  }

  @override
  Future<Either<Failure, List<Product>>> refreshAllProducts() async {
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    return sourcesResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      final Map<String, List<ProductSourceModel>> updatedSourcesByProduct = {};
      for (final ProductSourceModel source in sources) {
        final Either<Failure, ProductSourceModel> priceResult =
            await _remoteDatasource.fetchPrices(source);
        final Failure? failure = priceResult.getLeft().toNullable();
        if (failure != null) {
          return Left(failure);
        }
        final ProductSourceModel? updated = priceResult.getRight().toNullable();
        if (updated != null) {
          updatedSourcesByProduct
              .putIfAbsent(source.productId, () => <ProductSourceModel>[])
              .add(updated);
        }
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
      return _localDatasource.refreshAllProducts();
    });
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
