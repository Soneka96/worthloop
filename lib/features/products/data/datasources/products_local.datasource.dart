// Package imports:
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/fake_products.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Local product and merchant-offer persistence.
class ProductsLocalDatasource {
  final AppDatabase _db;
  final LoggerService _loggerService;

  /// Creates local product persistence backed by [AppDatabase].
  ProductsLocalDatasource(this._db, this._loggerService);

  /// Loads every product, inserting illustrative data on the first run.
  Future<Either<Failure, List<ProductModel>>> loadProducts() async {
    try {
      final List<ProductModel> products = await _db.transaction(() async {
        if (await _db.productTable.count().getSingle() == 0) {
          await _replaceProducts(buildFakeProducts(DateTime.now()));
        }
        return _readProducts();
      });
      return Right(products);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Updates one product's checked timestamps and returns its latest value.
  Future<Either<Failure, ProductModel>> refreshProduct(String productId) async {
    try {
      final ProductModel? product = await _touchProduct(
        productId,
        DateTime.now(),
      );
      return product == null
          ? const Left(NotFoundFailure('Product not found'))
          : Right(product);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Updates every product's checked timestamps and returns all products.
  Future<Either<Failure, List<ProductModel>>> refreshAllProducts() async {
    try {
      final DateTime checkedAt = DateTime.now();
      await _db.transaction(() async {
        await _db
            .update(_db.productTable)
            .write(ProductTableCompanion(lastUpdatedAt: Value(checkedAt)));
        await _db
            .update(_db.storePriceTable)
            .write(StorePriceTableCompanion(lastCheckedAt: Value(checkedAt)));
      });
      return Right(await _readProducts());
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  Future<void> _replaceProducts(List<ProductModel> products) async {
    for (final ProductModel product in products) {
      await _db.into(_db.productTable).insert(product.toCompanion());
      for (final StorePrice price in product.storePrices) {
        final StorePriceTableCompanion companion =
            StorePriceTableCompanion.insert(
              productId: product.id,
              storeName: price.storeName,
              productUrl: price.productUrl,
              minorUnits: price.currentPrice.minorUnits,
              currencyCode: price.currentPrice.currencyCode,
              isAvailable: price.isAvailable,
              lastCheckedAt: price.lastCheckedAt,
            );
        await _db.into(_db.storePriceTable).insert(companion);
      }
    }
  }

  Future<List<ProductModel>> _readProducts() async {
    final List<ProductRow> products = await _db.select(_db.productTable).get();
    final List<ProductModel> models = [];
    for (final ProductRow product in products) {
      final List<StorePriceRow> prices = await (_db.select(
        _db.storePriceTable,
      )..where((table) => table.productId.equals(product.id))).get();
      models.add(ProductModel.fromRows(product, prices));
    }
    return models;
  }

  Future<ProductModel?> _touchProduct(
    String productId,
    DateTime checkedAt,
  ) async {
    return _db.transaction(() async {
      final ProductRow? row = await (_db.select(
        _db.productTable,
      )..where((table) => table.id.equals(productId))).getSingleOrNull();
      if (row == null) {
        return null;
      }
      await (_db.update(_db.productTable)
            ..where((table) => table.id.equals(productId)))
          .write(ProductTableCompanion(lastUpdatedAt: Value(checkedAt)));
      await (_db.update(_db.storePriceTable)
            ..where((table) => table.productId.equals(productId)))
          .write(StorePriceTableCompanion(lastCheckedAt: Value(checkedAt)));
      final ProductRow updated = await (_db.select(
        _db.productTable,
      )..where((table) => table.id.equals(productId))).getSingle();
      final List<StorePriceRow> prices = await (_db.select(
        _db.storePriceTable,
      )..where((table) => table.productId.equals(productId))).get();
      return ProductModel.fromRows(updated, prices);
    });
  }
}
