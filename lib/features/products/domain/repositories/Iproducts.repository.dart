// Dart imports:
import 'dart:async';

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Receives source refresh lifecycle updates in request order.
typedef SourceRefreshListener =
    FutureOr<void> Function(String sourceId, SourceRefreshStatus status);

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

  /// Watches every persisted product and its saved sources.
  Stream<List<Product>> watchProducts();

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

  /// Clears any source left showing a live in-progress refresh status from
  /// a previous run that was killed mid-refresh.
  Future<Either<Failure, Unit>> resetStaleSourceStatuses();

  /// Queues [sourceIds] onto their merchant-specific fetch queues, starting
  /// worker processing if it isn't already running. [bypassCooldown] applies
  /// to every source in this call. Returns once every source is queued and
  /// its live status is persisted — the actual fetch results are not
  /// awaited here, they flow through the database as each source completes.
  Future<Either<Failure, Unit>> enqueueSourceRefresh(
    List<String> sourceIds, {
    bool bypassCooldown,
  });
}
