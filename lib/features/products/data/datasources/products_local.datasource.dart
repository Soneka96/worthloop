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
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';

/// Local product and merchant-offer persistence.
class ProductsLocalDatasource {
  final AppDatabase _db;
  final LoggerService _loggerService;
  final ProductUrlCleanerService _urlCleanerService;

  /// Creates local product persistence backed by [AppDatabase].
  ProductsLocalDatasource(
    this._db,
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

  /// Watches every persisted product and its saved sources.
  Stream<List<ProductModel>> watchProducts() {
    final JoinedSelectStatement query = _db.select(_db.productTable).join([
      leftOuterJoin(
        _db.productSourceTable,
        _db.productSourceTable.productId.equalsExp(_db.productTable.id),
      ),
    ]);
    return query.watch().map((List<TypedResult> rows) {
      final Map<String, ProductRow> products = {};
      final Map<String, List<ProductSourceRow>> sourcesByProduct = {};
      for (final TypedResult row in rows) {
        final ProductRow product = row.readTable(_db.productTable);
        products[product.id] = product;
        final ProductSourceRow? source = row.readTableOrNull(
          _db.productSourceTable,
        );
        if (source != null) {
          sourcesByProduct
              .putIfAbsent(product.id, () => <ProductSourceRow>[])
              .add(source);
        }
      }
      return products.values
          .map(
            (ProductRow product) => ProductModel.fromRows(
              product,
              sourcesByProduct[product.id] ?? const <ProductSourceRow>[],
            ),
          )
          .toList(growable: false);
    });
  }

  /// Loads one persisted product by [productId].
  Future<Either<Failure, ProductModel>> loadProduct(String productId) async {
    try {
      final List<ProductModel> products = await _readProducts();
      for (final ProductModel product in products) {
        if (product.id == productId) {
          return Right(product);
        }
      }
      return const Left(NotFoundFailure('Product not found'));
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
      await (_db.update(
        _db.productTable,
      )).write(ProductTableCompanion(lastUpdatedAt: Value(DateTime.now())));
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
      await (_db.update(
        _db.productSourceTable,
      )..where((table) => table.id.equals(sourceId))).write(
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
        products.firstWhere((ProductModel item) => item.id == row.productId),
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
        products.firstWhere((ProductModel item) => item.id == row.productId),
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
      final ProductModel? product = await _db.transaction(() async {
        final ProductRow? row = await (_db.select(
          _db.productTable,
        )..where((table) => table.id.equals(productId))).getSingleOrNull();
        if (row == null) {
          return null;
        }
        final List<ProductSourceRow> existingSources = await (_db.select(
          _db.productSourceTable,
        )..where((table) => table.productId.equals(productId))).get();
        final ProductModel previousProduct = ProductModel.fromRows(
          row,
          existingSources,
        );
        final Money? previousBestPrice =
            previousProduct.bestAvailablePrice?.currentPrice;
        for (final ProductSourceModel source in updatedSources) {
          ProductSourceRow? existingSource;
          for (final ProductSourceRow item in existingSources) {
            if (item.id == source.id) {
              existingSource = item;
              break;
            }
          }
          final Money? existingPrice = existingSource == null
              ? null
              : _moneyFromRow(existingSource);
          final bool hasPriceChange =
              existingPrice != null &&
              source.currentPrice != null &&
              existingPrice != source.currentPrice;
          await (_db.update(
            _db.productSourceTable,
          )..where((table) => table.id.equals(source.id))).write(
            ProductSourceTableCompanion(
              minorUnits: Value(source.currentPrice?.minorUnits),
              currencyCode: Value(source.currentPrice?.currencyCode),
              previousPriceMinorUnits: hasPriceChange
                  ? Value(existingPrice.minorUnits)
                  : const Value.absent(),
              previousPriceCurrencyCode: hasPriceChange
                  ? Value(existingPrice.currencyCode)
                  : const Value.absent(),
              isAvailable: Value(source.isAvailable),
              lastCheckedAt: Value(source.lastCheckedAt),
              priceChangedAt: hasPriceChange
                  ? Value(source.lastCheckedAt ?? DateTime.now())
                  : const Value.absent(),
              lastRefreshStatus: Value(
                (source.lastRefreshStatus ?? PriceFetchStatus.success).name,
              ),
              lastRefreshAt: Value(source.lastRefreshAt ?? DateTime.now()),
            ),
          );
        }
        final List<ProductSourceRow> refreshedSources = await (_db.select(
          _db.productSourceTable,
        )..where((table) => table.productId.equals(productId))).get();
        final ProductModel refreshedProduct = ProductModel.fromRows(
          row,
          refreshedSources,
        );
        final Money? refreshedBestPrice =
            refreshedProduct.bestAvailablePrice?.currentPrice;
        final bool hasBestPriceChange =
            previousBestPrice != null &&
            refreshedBestPrice != null &&
            previousBestPrice != refreshedBestPrice;
        await (_db.update(
          _db.productTable,
        )..where((table) => table.id.equals(productId))).write(
          ProductTableCompanion(
            lastUpdatedAt: Value(DateTime.now()),
            previousBestPriceMinorUnits: hasBestPriceChange
                ? Value(previousBestPrice.minorUnits)
                : const Value.absent(),
            previousBestPriceCurrencyCode: hasBestPriceChange
                ? Value(previousBestPrice.currencyCode)
                : const Value.absent(),
            bestPriceChangedAt: hasBestPriceChange
                ? Value(_latestCheckedAt(updatedSources) ?? DateTime.now())
                : const Value.absent(),
          ),
        );
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

  Money? _moneyFromRow(ProductSourceRow row) {
    final int? minorUnits = row.minorUnits;
    final String? currencyCode = row.currencyCode;
    return minorUnits != null && currencyCode != null
        ? Money(minorUnits: minorUnits, currencyCode: currencyCode)
        : null;
  }

  DateTime? _latestCheckedAt(List<ProductSourceModel> sources) {
    final List<DateTime> checkedAt = sources
        .map((ProductSourceModel source) => source.lastCheckedAt)
        .whereType<DateTime>()
        .toList(growable: false);
    if (checkedAt.isEmpty) {
      return null;
    }
    checkedAt.sort();
    return checkedAt.last;
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
