// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_drop.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Receives source refresh lifecycle updates in request order.
typedef SourceRefreshListener =
    void Function(String sourceId, SourceRefreshStatus status);

/// Receives one event after a product's persisted best price drops.
typedef ProductPriceDropListener = Future<void> Function(ProductPriceDrop drop);

/// Coordinates persisted products and their latest merchant offers.
abstract class IProductsRepository {
  /// Creates and persists a tracked product, optionally with its first
  /// website source.
  Future<Either<Failure, Product>> createProduct(
    Product product,
    ProductSource? source,
  );

  /// Loads every tracked product.
  Future<Either<Failure, List<Product>>> loadProducts();

  /// Refreshes and persists the product identified by [productId].
  Future<Either<Failure, Product>> refreshProduct(
    String productId, {
    SourceRefreshListener? onSourceStatusChanged,
    ProductPriceDropListener? onPriceDrop,
  });

  /// Refreshes and persists the source identified by [sourceId].
  Future<Either<Failure, Product>> refreshSource(
    String sourceId, {
    SourceRefreshListener? onSourceStatusChanged,
    bool bypassCooldown = false,
    ProductPriceDropListener? onPriceDrop,
  });

  /// Refreshes and persists every tracked product.
  Future<Either<Failure, List<Product>>> refreshAllProducts({
    SourceRefreshListener? onSourceStatusChanged,
    ProductPriceDropListener? onPriceDrop,
  });

  /// Fetches an offer for [source], and only when that succeeds, adds it to
  /// an existing product. Returns the product with that offer applied.
  Future<Either<Failure, Product>> addSource(ProductSource source);

  /// Fetches a fresh offer for [url], and only when that succeeds, updates
  /// the saved source's URL and offer. Returns the updated product.
  Future<Either<Failure, Product>> updateSource(String sourceId, String url);

  /// Deletes a saved source and returns the product without it.
  Future<Either<Failure, Product>> deleteSource(String sourceId);

  /// Renames an existing product.
  Future<Either<Failure, Product>> renameProduct(String productId, String name);

  /// Deletes a product and its sources and offers.
  Future<Either<Failure, Unit>> deleteProduct(String productId);
}
