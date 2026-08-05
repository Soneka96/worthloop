// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Implements [IProductsRepository] with local and remote product data.
class ProductsRepository implements IProductsRepository {
  final ProductsLocalDatasource _localDatasource;
  final ProductsRemoteDatasource _remoteDatasource;

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
      final List<StorePriceModel> offers = [];
      for (final ProductSourceModel source in sources) {
        final Either<Failure, List<StorePriceModel>> prices =
            await _remoteDatasource.fetchPrices(source);
        final Failure? failure = prices.getLeft().toNullable();
        if (failure != null) {
          return Left(failure);
        }
        offers.addAll(prices.getRight().toNullable() ?? []);
      }
      return _localDatasource.replaceProductPrices(productId, offers);
    });
  }

  @override
  Future<Either<Failure, List<Product>>> refreshAllProducts() async {
    final Either<Failure, List<ProductSourceModel>> sourcesResult =
        await _localDatasource.loadProductSources();
    return sourcesResult.match((Failure failure) async => Left(failure), (
      List<ProductSourceModel> sources,
    ) async {
      final Map<String, List<StorePriceModel>> refreshedOffersByProduct = {};
      for (final ProductSourceModel source in sources) {
        final Either<Failure, List<StorePriceModel>> prices =
            await _remoteDatasource.fetchPrices(source);
        final Failure? failure = prices.getLeft().toNullable();
        if (failure != null) {
          return Left(failure);
        }
        refreshedOffersByProduct
            .putIfAbsent(source.productId, () => <StorePriceModel>[])
            .addAll(prices.getRight().toNullable() ?? []);
      }
      for (final MapEntry<String, List<StorePriceModel>> entry
          in refreshedOffersByProduct.entries) {
        final Either<Failure, ProductModel> savedPrices = await _localDatasource
            .replaceProductPrices(entry.key, entry.value);
        final Failure? failure = savedPrices.getLeft().toNullable();
        if (failure != null) {
          return Left(failure);
        }
      }
      return _localDatasource.refreshAllProducts();
    });
  }

  @override
  Future<Either<Failure, ProductSource>> addSource(ProductSource source) {
    return _localDatasource.saveProductSource(source);
  }

  @override
  Future<Either<Failure, List<ProductSource>>> loadSourcesForProduct(
    String productId,
  ) {
    return _localDatasource.loadProductSourcesForProduct(productId);
  }

  @override
  Future<Either<Failure, ProductSource>> updateSource(
    String sourceId,
    String url,
  ) {
    return _localDatasource.updateProductSource(sourceId, url);
  }

  @override
  Future<Either<Failure, Unit>> deleteSource(String sourceId) {
    return _localDatasource.deleteProductSource(sourceId);
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
