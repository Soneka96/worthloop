// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Implements [IProductsRepository] with [ProductsLocalDatasource].
class ProductsRepository implements IProductsRepository {
  final ProductsLocalDatasource _localDatasource;

  /// Creates a repository backed by [_localDatasource].
  ProductsRepository(this._localDatasource);

  @override
  Future<Either<Failure, Product>> createProduct(
    Product product,
    ProductSource source,
  ) {
    return _localDatasource.createProduct(product, source);
  }

  @override
  Future<Either<Failure, List<Product>>> loadProducts() {
    return _localDatasource.loadProducts();
  }

  @override
  Future<Either<Failure, Product>> refreshProduct(String productId) {
    return _localDatasource.refreshProduct(productId);
  }

  @override
  Future<Either<Failure, List<Product>>> refreshAllProducts() {
    return _localDatasource.refreshAllProducts();
  }
}
