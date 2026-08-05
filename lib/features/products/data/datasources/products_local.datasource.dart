// Package imports:
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/fake_products.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/utils/currency_helper_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Local product and merchant-offer persistence.
class ProductsLocalDatasource {
  final AppDatabase _db;
  final CurrencyHelperService _currencyHelperService;
  final LoggerService _loggerService;
  final AppPreferencesStore _appPreferencesStore;

  /// Creates local product persistence backed by [AppDatabase].
  ProductsLocalDatasource(
    this._db,
    this._currencyHelperService,
    this._loggerService,
    this._appPreferencesStore,
  );

  /// Creates a product, and its source when one is given, in one transaction.
  Future<Either<Failure, ProductModel>> createProduct(
    Product product,
    ProductSource? source,
  ) async {
    try {
      ProductSourceModel? sourceModel;
      if (source != null) {
        final ProductSource validatedSource = ProductSource.fromUrl(
          id: source.id,
          productId: source.productId,
          url: source.url,
          createdAt: source.createdAt,
        );
        if (product.id != validatedSource.productId) {
          return const Left(
            ValidationFailure('Product and source identifiers do not match'),
          );
        }
        sourceModel = ProductSourceModel.fromEntity(validatedSource);
      }
      if (product.storePrices.isNotEmpty) {
        return const Left(
          ValidationFailure(
            'Product creation does not accept pre-populated store prices',
          ),
        );
      }
      final ProductModel model = ProductModel(
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        storePrices: product.storePrices,
        lastUpdatedAt: product.lastUpdatedAt,
      );
      await _db.transaction(() async {
        await _db.into(_db.productTable).insert(model.toCompanion());
        if (sourceModel != null) {
          await _db
              .into(_db.productSourceTable)
              .insert(sourceModel.toCompanion());
        }
      });
      return Right(model);
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Loads every product, inserting illustrative data on the very first
  /// launch only — a table emptied by later deletions is never reseeded.
  Future<Either<Failure, List<ProductModel>>> loadProducts() async {
    try {
      final bool hasSeeded = await _appPreferencesStore
          .readHasSeededIllustrativeProducts();
      final List<ProductModel> products = await _db.transaction(() async {
        if (!hasSeeded && await _db.productTable.count().getSingle() == 0) {
          await _replaceProducts(buildFakeProducts(DateTime.now()));
        }
        return _readProducts();
      });
      if (!hasSeeded) {
        await _appPreferencesStore.writeHasSeededIllustrativeProducts();
      }
      return Right(products);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
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
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
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
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
    }
  }

  /// Renames an existing product and returns its persisted representation.
  Future<Either<Failure, ProductModel>> renameProduct(
    String productId,
    String name,
  ) async {
    try {
      final ProductModel? product = await _db.transaction(() async {
        final ProductRow? row = await (_db.select(
          _db.productTable,
        )..where((table) => table.id.equals(productId))).getSingleOrNull();
        if (row == null) {
          return null;
        }
        await (_db.update(_db.productTable)
              ..where((table) => table.id.equals(productId)))
            .write(ProductTableCompanion(name: Value(name)));
        final List<ProductModel> products = await _readProducts();
        return products.firstWhere((ProductModel item) => item.id == productId);
      });
      return product == null
          ? const Left(NotFoundFailure('Product not found'))
          : Right(product);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
    }
  }

  /// Saves a product website link and returns its persisted representation.
  Future<Either<Failure, ProductSourceModel>> saveProductSource(
    ProductSource source,
  ) async {
    try {
      final ProductSource validatedSource = ProductSource.fromUrl(
        id: source.id,
        productId: source.productId,
        url: source.url,
        createdAt: source.createdAt,
      );
      final ProductSourceModel model = ProductSourceModel.fromEntity(
        validatedSource,
      );
      await _db.into(_db.productSourceTable).insert(model.toCompanion());
      return Right(model);
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Updates an existing source's URL and returns its persisted
  /// representation.
  Future<Either<Failure, ProductSourceModel>> updateProductSource(
    String sourceId,
    String url,
  ) async {
    try {
      final ProductSourceRow? row = await (_db.select(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).getSingleOrNull();
      if (row == null) {
        return const Left(NotFoundFailure('Source not found'));
      }
      final ProductSource updated = ProductSource.fromUrl(
        id: row.id,
        productId: row.productId,
        url: url,
        createdAt: row.createdAt,
      );
      await (_db.update(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).write(
        ProductSourceTableCompanion(
          url: Value(updated.url),
          merchantDomain: Value(updated.merchantDomain),
        ),
      );
      return Right(ProductSourceModel.fromEntity(updated));
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Deletes a saved source.
  Future<Either<Failure, Unit>> deleteProductSource(String sourceId) async {
    try {
      final int rowsDeleted = await (_db.delete(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).go();
      return rowsDeleted == 0
          ? const Left(NotFoundFailure('Source not found'))
          : const Right(unit);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Loads every saved product website link.
  Future<Either<Failure, List<ProductSourceModel>>> loadProductSources() async {
    try {
      final List<ProductSourceRow> rows = await _db
          .select(_db.productSourceTable)
          .get();
      return Right(
        rows.map(ProductSourceModel.fromRow).toList(growable: false),
      );
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Loads every saved website link for [productId].
  Future<Either<Failure, List<ProductSourceModel>>>
  loadProductSourcesForProduct(String productId) async {
    try {
      final List<ProductSourceRow> rows = await (_db.select(
        _db.productSourceTable,
      )..where((table) => table.productId.equals(productId))).get();
      return Right(
        rows.map(ProductSourceModel.fromRow).toList(growable: false),
      );
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Replaces the saved offers for [productId] and returns the updated product.
  Future<Either<Failure, ProductModel>> replaceProductPrices(
    String productId,
    List<StorePriceModel> prices,
  ) async {
    try {
      _currencyHelperService.validate(
        prices.map((StorePriceModel price) => price.currentPrice),
      );
      final ProductModel? product = await _db.transaction(() async {
        final ProductRow? row = await (_db.select(
          _db.productTable,
        )..where((table) => table.id.equals(productId))).getSingleOrNull();
        if (row == null) {
          return null;
        }
        await (_db.delete(
          _db.storePriceTable,
        )..where((table) => table.productId.equals(productId))).go();
        for (final StorePriceModel price in prices) {
          await _db
              .into(_db.storePriceTable)
              .insert(price.toCompanion(productId));
        }
        await (_db.update(_db.productTable)
              ..where((table) => table.id.equals(productId)))
            .write(ProductTableCompanion(lastUpdatedAt: Value(DateTime.now())));
        final List<ProductModel> products = await _readProducts();
        return products.firstWhere((ProductModel item) => item.id == productId);
      });
      return product == null
          ? const Left(NotFoundFailure('Product not found'))
          : Right(product);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
    }
  }

  Future<void> _replaceProducts(List<ProductModel> products) async {
    for (final ProductModel product in products) {
      _currencyHelperService.validate(
        product.storePrices.map((StorePrice price) => price.currentPrice),
      );
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
      final ProductModel model = ProductModel.fromRows(product, prices);
      _currencyHelperService.validate(
        model.storePrices.map((StorePrice price) => price.currentPrice),
      );
      models.add(model);
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
      final ProductModel model = ProductModel.fromRows(updated, prices);
      _currencyHelperService.validate(
        model.storePrices.map((StorePrice price) => price.currentPrice),
      );
      return model;
    });
  }
}
