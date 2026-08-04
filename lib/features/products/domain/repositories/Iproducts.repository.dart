// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Coordinates persisted products and their latest merchant offers.
abstract class IProductsRepository {
  /// Creates and persists a tracked product with its website source.
  Future<Either<Failure, Product>> createProduct(
    Product product,
    ProductSource source,
  );

  /// Loads every tracked product.
  Future<Either<Failure, List<Product>>> loadProducts();

  /// Refreshes and persists the product identified by [productId].
  Future<Either<Failure, Product>> refreshProduct(String productId);

  /// Refreshes and persists every tracked product.
  Future<Either<Failure, List<Product>>> refreshAllProducts();
}
