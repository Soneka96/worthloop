// Package imports:
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/currency_helper_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';

/// Local product and merchant-offer persistence.
class ProductsLocalDatasource {
  final AppDatabase _db;
  final CurrencyHelperService _currencyHelperService;
  final LoggerService _loggerService;
  final ProductUrlCleanerService _urlCleanerService;

  /// Creates local product persistence backed by [AppDatabase].
  ProductsLocalDatasource(
    this._db,
    this._currencyHelperService,
    this._loggerService,
    this._urlCleanerService,
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
      if (product.sources.isNotEmpty) {
        return const Left(
          ValidationFailure(
            'Product creation does not accept pre-populated sources',
          ),
        );
      }
      final ProductModel model = ProductModel(
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        sources: product.sources,
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

  /// Loads every product.
  Future<Either<Failure, List<ProductModel>>> loadProducts() async {
    try {
      return Right(await _readProducts());
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
    }
  }

  /// Touches one product's checked timestamp — used when it has no sources
  /// to refresh — and returns its latest value.
  Future<Either<Failure, ProductModel>> refreshProduct(String productId) async {
    try {
      final ProductModel? product = await _touchProduct(productId);
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

  /// Touches every product's checked timestamp and returns all products.
  Future<Either<Failure, List<ProductModel>>> refreshAllProducts() async {
    try {
      await (_db.update(_db.productTable)).write(
        ProductTableCompanion(lastUpdatedAt: Value(DateTime.now())),
      );
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

  /// Deletes a product, cascading to its sources via schema foreign keys.
  Future<Either<Failure, Unit>> deleteProduct(String productId) async {
    try {
      final int rowsDeleted = await (_db.delete(
        _db.productTable,
      )..where((table) => table.id.equals(productId))).go();
      return rowsDeleted == 0
          ? const Left(NotFoundFailure('Product not found'))
          : const Right(unit);
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    }
  }

  /// Saves a product website link together with its first fetched offer, in
  /// one transaction, after checking [pricedSource]'s cleaned URL isn't
  /// already tracked for this product. Returns the product with that offer
  /// applied.
  Future<Either<Failure, ProductModel>> addSourceWithPrice(
    ProductSource pricedSource,
  ) async {
    try {
      final ProductSource validatedSource = ProductSource.fromUrl(
        id: pricedSource.id,
        productId: pricedSource.productId,
        url: _urlCleanerService.clean(pricedSource.url),
        createdAt: pricedSource.createdAt,
      );
      final bool isDuplicate = await _hasSourceForUrl(
        productId: validatedSource.productId,
        url: validatedSource.url,
        excludingSourceId: null,
      );
      if (isDuplicate) {
        return const Left(
          ValidationFailure('This store is already tracked for this product'),
        );
      }
      final ProductSourceModel sourceModel = ProductSourceModel(
        id: validatedSource.id,
        productId: validatedSource.productId,
        url: validatedSource.url,
        merchantDomain: validatedSource.merchantDomain,
        createdAt: validatedSource.createdAt,
        currentPrice: pricedSource.currentPrice,
        isAvailable: pricedSource.isAvailable,
        lastCheckedAt: pricedSource.lastCheckedAt,
      );
      return await _db.transaction(() async {
        await _db
            .into(_db.productSourceTable)
            .insert(sourceModel.toCompanion());
        final List<ProductModel> products = await _readProducts();
        return Right(
          products.firstWhere(
            (ProductModel item) => item.id == validatedSource.productId,
          ),
        );
      });
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
    }
  }

  /// Updates an existing source's URL together with its freshly fetched
  /// offer, after checking the cleaned URL isn't already tracked by another
  /// source on the same product. Returns the product with that offer applied.
  Future<Either<Failure, ProductModel>> editSourceWithPrice(
    String sourceId,
    ProductSource pricedSource,
  ) async {
    try {
      final ProductSourceRow? row = await (_db.select(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).getSingleOrNull();
      if (row == null) {
        return const Left(NotFoundFailure('Source not found'));
      }
      final ProductSource validatedSource = ProductSource.fromUrl(
        id: sourceId,
        productId: row.productId,
        url: _urlCleanerService.clean(pricedSource.url),
        createdAt: row.createdAt,
      );
      final bool isDuplicate = await _hasSourceForUrl(
        productId: row.productId,
        url: validatedSource.url,
        excludingSourceId: sourceId,
      );
      if (isDuplicate) {
        return const Left(
          ValidationFailure('This store is already tracked for this product'),
        );
      }
      await (_db.update(_db.productSourceTable)
            ..where((table) => table.id.equals(sourceId)))
          .write(
            ProductSourceTableCompanion(
              url: Value(validatedSource.url),
              merchantDomain: Value(validatedSource.merchantDomain),
              minorUnits: Value(pricedSource.currentPrice?.minorUnits),
              currencyCode: Value(pricedSource.currentPrice?.currencyCode),
              isAvailable: Value(pricedSource.isAvailable),
              lastCheckedAt: Value(pricedSource.lastCheckedAt),
            ),
          );
      final List<ProductModel> products = await _readProducts();
      return Right(
        products.firstWhere(
          (ProductModel item) => item.id == row.productId,
        ),
      );
    } on ArgumentError catch (error) {
      return Left(ValidationFailure(error.message.toString()));
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
    }
  }

  /// Deletes a saved source and returns the product without it.
  Future<Either<Failure, ProductModel>> deleteSource(String sourceId) async {
    try {
      final ProductSourceRow? row = await (_db.select(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).getSingleOrNull();
      if (row == null) {
        return const Left(NotFoundFailure('Source not found'));
      }
      await (_db.delete(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).go();
      final List<ProductModel> products = await _readProducts();
      return Right(
        products.firstWhere(
          (ProductModel item) => item.id == row.productId,
        ),
      );
    } on SqliteException catch (error) {
      _loggerService.e(error.toString());
      return Left(DatabaseFailure(error.toString()));
    } on StateError catch (error) {
      _loggerService.e(error.toString());
      return Left(CurrencyFailure(error.toString()));
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

  /// Applies freshly fetched offers to [updatedSources]' existing rows, in
  /// one transaction, and returns the updated product. Each entry must
  /// already have an [ProductSourceModel.id] matching a persisted source.
  Future<Either<Failure, ProductModel>> updateSourcePrices(
    String productId,
    List<ProductSourceModel> updatedSources,
  ) async {
    try {
      _currencyHelperService.validate(
        updatedSources
            .map((ProductSourceModel source) => source.currentPrice)
            .whereType<Money>(),
      );
      final ProductModel? product = await _db.transaction(() async {
        final ProductRow? row = await (_db.select(
          _db.productTable,
        )..where((table) => table.id.equals(productId))).getSingleOrNull();
        if (row == null) {
          return null;
        }
        for (final ProductSourceModel source in updatedSources) {
          await (_db.update(_db.productSourceTable)
                ..where((table) => table.id.equals(source.id)))
              .write(
                ProductSourceTableCompanion(
                  minorUnits: Value(source.currentPrice?.minorUnits),
                  currencyCode: Value(source.currentPrice?.currencyCode),
                  isAvailable: Value(source.isAvailable),
                  lastCheckedAt: Value(source.lastCheckedAt),
                ),
              );
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

  Future<bool> _hasSourceForUrl({
    required String productId,
    required String url,
    required String? excludingSourceId,
  }) async {
    final SimpleSelectStatement<$ProductSourceTableTable, ProductSourceRow>
    query = _db.select(_db.productSourceTable)
      ..where(
        (table) => table.productId.equals(productId) & table.url.equals(url),
      );
    if (excludingSourceId != null) {
      query.where((table) => table.id.equals(excludingSourceId).not());
    }
    return await query.getSingleOrNull() != null;
  }

  Future<List<ProductModel>> _readProducts() async {
    final List<ProductRow> products = await _db.select(_db.productTable).get();
    final List<ProductModel> models = [];
    for (final ProductRow product in products) {
      final List<ProductSourceRow> sources = await (_db.select(
        _db.productSourceTable,
      )..where((table) => table.productId.equals(product.id))).get();
      final ProductModel model = ProductModel.fromRows(product, sources);
      _currencyHelperService.validate(
        model.sources
            .map((ProductSource source) => source.currentPrice)
            .whereType<Money>(),
      );
      models.add(model);
    }
    return models;
  }

  Future<ProductModel?> _touchProduct(String productId) async {
    return _db.transaction(() async {
      final ProductRow? row = await (_db.select(
        _db.productTable,
      )..where((table) => table.id.equals(productId))).getSingleOrNull();
      if (row == null) {
        return null;
      }
      await (_db.update(_db.productTable)
            ..where((table) => table.id.equals(productId)))
          .write(ProductTableCompanion(lastUpdatedAt: Value(DateTime.now())));
      final List<ProductModel> products = await _readProducts();
      return products.firstWhere((ProductModel item) => item.id == productId);
    });
  }
}
