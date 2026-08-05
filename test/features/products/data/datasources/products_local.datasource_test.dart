// Package imports:
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/utils/currency_helper_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import '../../fixtures/product_source.fixture.dart';

class MockLoggerService extends Mock implements LoggerService {}

class MockCurrencyHelperService extends Mock implements CurrencyHelperService {}

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  late AppDatabase db;
  late MockLoggerService mockLoggerService;
  late MockCurrencyHelperService mockCurrencyHelperService;
  late MockAppPreferencesStore mockAppPreferencesStore;
  late ProductsLocalDatasource datasource;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockLoggerService = MockLoggerService();
    mockCurrencyHelperService = MockCurrencyHelperService();
    mockAppPreferencesStore = MockAppPreferencesStore();
    when(
      () => mockAppPreferencesStore.readHasSeededIllustrativeProducts(),
    ).thenAnswer((_) async => false);
    when(
      () => mockAppPreferencesStore.writeHasSeededIllustrativeProducts(),
    ).thenAnswer((_) async {});
    when(() => mockCurrencyHelperService.validate(any())).thenAnswer((
      invocation,
    ) {
      final Iterable<Money> prices =
          invocation.positionalArguments.single as Iterable<Money>;
      final Set<String> currencyCodes = prices
          .map((Money money) => money.currencyCode)
          .toSet();
      if (currencyCodes.length > 1) {
        throw StateError('Prices must use one currency');
      }
    });
    datasource = ProductsLocalDatasource(
      db,
      mockCurrencyHelperService,
      mockLoggerService,
      mockAppPreferencesStore,
    );
  });

  tearDown(() async {
    await db.close();
    reset(mockLoggerService);
    reset(mockCurrencyHelperService);
    reset(mockAppPreferencesStore);
  });

  group('Method loadProducts() returns the correct value', () {
    test(
      'returns and persists illustrative products when storage is empty',
      () async {
        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final List<ProductModel> products =
            result.getRight().toNullable() ?? [];
        final List<ProductRow> rows = await db.select(db.productTable).get();

        expect(products.length, isA<int>());
        expect(products.length, 2);
        expect(rows.length, isA<int>());
        expect(rows.length, 2);
        verify(
          () => mockAppPreferencesStore.writeHasSeededIllustrativeProducts(),
        ).called(1);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'does not reseed illustrative products when the table is empty and hasSeeded == true',
      () async {
        when(
          () => mockAppPreferencesStore.readHasSeededIllustrativeProducts(),
        ).thenAnswer((_) async => true);

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final List<ProductModel> products =
            result.getRight().toNullable() ?? [];

        expect(products, isEmpty);
        verifyNever(
          () => mockAppPreferencesStore.writeHasSeededIllustrativeProducts(),
        );
      },
    );

    test('does not duplicate illustrative products on a second load', () async {
      await datasource.loadProducts();

      await datasource.loadProducts();
      final List<ProductRow> rows = await db.select(db.productTable).get();

      expect(rows.length, isA<int>());
      expect(rows.length, 2);
    });

    test('succeeds when two loads run concurrently', () async {
      final List<Either<Failure, List<ProductModel>>> results =
          await Future.wait([
            datasource.loadProducts(),
            datasource.loadProducts(),
          ]);
      final List<ProductRow> rows = await db.select(db.productTable).get();
      final List<StorePriceRow> priceRows = await db
          .select(db.storePriceTable)
          .get();

      expect(results, everyElement(isA<Right<Failure, List<ProductModel>>>()));
      for (final Either<Failure, List<ProductModel>> result in results) {
        final List<ProductModel> products =
            result.getRight().toNullable() ?? [];
        expect(products.length, 2);
        expect(
          products.every(
            (ProductModel product) => product.storePrices.isNotEmpty,
          ),
          isTrue,
        );
      }
      expect(rows.length, 2);
      expect(priceRows.length, 7);
      verify(
        () => mockAppPreferencesStore.writeHasSeededIllustrativeProducts(),
      ).called(2);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'preserves existing products without inserting illustrative data',
      () async {
        await db
            .into(db.productTable)
            .insert(
              ProductTableCompanion.insert(
                id: 'custom-product',
                name: 'Custom Product',
                lastUpdatedAt: DateTime(2026, 1, 1, 12),
              ),
            );

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final List<ProductModel> products =
            result.getRight().toNullable() ?? [];

        expect(products.length, isA<int>());
        expect(products.length, 1);
        expect(products.single.id, isA<String>());
        expect(products.single.id, 'custom-product');
        verify(
          () => mockAppPreferencesStore.writeHasSeededIllustrativeProducts(),
        ).called(1);
      },
    );

    test(
      'does not write hasSeeded when the table is non-empty and hasSeeded == true',
      () async {
        when(
          () => mockAppPreferencesStore.readHasSeededIllustrativeProducts(),
        ).thenAnswer((_) async => true);
        await db
            .into(db.productTable)
            .insert(
              ProductTableCompanion.insert(
                id: 'custom-product',
                name: 'Custom Product',
                lastUpdatedAt: DateTime(2026, 1, 1, 12),
              ),
            );

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final List<ProductModel> products =
            result.getRight().toNullable() ?? [];

        expect(products.length, 1);
        verifyNever(
          () => mockAppPreferencesStore.writeHasSeededIllustrativeProducts(),
        );
      },
    );

    test(
      'returns Left(DatabaseFailure) when the product table is missing',
      () async {
        await db.customStatement('DROP TABLE product_table');

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(CurrencyFailure) for mixed-currency stored offers',
      () async {
        await db
            .into(db.productTable)
            .insert(
              ProductTableCompanion.insert(
                id: 'mixed-product',
                name: 'Mixed Product',
                lastUpdatedAt: DateTime(2026, 1, 1, 12),
              ),
            );
        for (final String currencyCode in ['USD', 'EUR']) {
          await db
              .into(db.storePriceTable)
              .insert(
                StorePriceTableCompanion.insert(
                  productId: 'mixed-product',
                  storeName: currencyCode,
                  productUrl: 'https://example.com/$currencyCode',
                  minorUnits: 100,
                  currencyCode: currencyCode,
                  isAvailable: true,
                  lastCheckedAt: DateTime(2026, 1, 1, 12),
                ),
              );
        }

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<CurrencyFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method refreshProduct() returns the correct value', () {
    test('returns the product with newer checked timestamps', () async {
      await datasource.loadProducts();
      final DateTime oldCheckedAt = DateTime(2020);
      await db
          .update(db.productTable)
          .write(ProductTableCompanion(lastUpdatedAt: Value(oldCheckedAt)));
      await db
          .update(db.storePriceTable)
          .write(StorePriceTableCompanion(lastCheckedAt: Value(oldCheckedAt)));
      final List<ProductModel> products =
          (await datasource.loadProducts()).getRight().toNullable() ?? [];
      final DateTime previous = products.first.lastUpdatedAt;
      final ProductModel untouched = products.last;
      final int previousPrice =
          products.first.storePrices.first.currentPrice.minorUnits;
      final bool previousAvailability =
          products.first.storePrices.first.isAvailable;

      final Either<Failure, ProductModel> result = await datasource
          .refreshProduct(products.first.id);
      final ProductModel? refreshed = result.getRight().toNullable();

      if (refreshed == null) {
        fail('Expected Right(ProductModel)');
      }
      expect(refreshed.lastUpdatedAt.isAfter(previous), isTrue);
      expect(
        refreshed.storePrices.every(
          (StorePrice price) => price.lastCheckedAt == refreshed.lastUpdatedAt,
        ),
        isTrue,
      );
      expect(refreshed.storePrices.first.currentPrice.minorUnits, isA<int>());
      expect(
        refreshed.storePrices.first.currentPrice.minorUnits,
        previousPrice,
      );
      expect(refreshed.storePrices.first.isAvailable, isA<bool>());
      expect(refreshed.storePrices.first.isAvailable, previousAvailability);
      final ProductRow untouchedRow = await (db.select(
        db.productTable,
      )..where((table) => table.id.equals(untouched.id))).getSingle();
      expect(untouchedRow.lastUpdatedAt, untouched.lastUpdatedAt);
    });

    test('returns Left(NotFoundFailure) when productId is missing', () async {
      await datasource.loadProducts();

      final Either<Failure, ProductModel> result = await datasource
          .refreshProduct('missing');

      expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the product table is missing',
      () async {
        await db.customStatement('DROP TABLE product_table');

        final Either<Failure, ProductModel> result = await datasource
            .refreshProduct('product-1');
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(CurrencyFailure) when refreshed offers differ',
      () async {
        await db
            .into(db.productTable)
            .insert(
              ProductTableCompanion.insert(
                id: 'mixed-product',
                name: 'Mixed Product',
                lastUpdatedAt: DateTime(2026, 1, 1, 12),
              ),
            );
        for (final String currencyCode in ['USD', 'EUR']) {
          await db
              .into(db.storePriceTable)
              .insert(
                StorePriceTableCompanion.insert(
                  productId: 'mixed-product',
                  storeName: currencyCode,
                  productUrl: 'https://example.com/$currencyCode',
                  minorUnits: 100,
                  currencyCode: currencyCode,
                  isAvailable: true,
                  lastCheckedAt: DateTime(2026, 1, 1, 12),
                ),
              );
        }

        final Either<Failure, ProductModel> result = await datasource
            .refreshProduct('mixed-product');
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<CurrencyFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method refreshAllProducts() returns the correct value', () {
    test('returns every product with newer checked timestamps', () async {
      await datasource.loadProducts();
      final DateTime oldCheckedAt = DateTime(2020);
      await db
          .update(db.productTable)
          .write(ProductTableCompanion(lastUpdatedAt: Value(oldCheckedAt)));
      await db
          .update(db.storePriceTable)
          .write(StorePriceTableCompanion(lastCheckedAt: Value(oldCheckedAt)));
      final List<ProductModel> products =
          (await datasource.loadProducts()).getRight().toNullable() ?? [];
      final DateTime previous = products.first.lastUpdatedAt;
      final List<int> previousPrices = products
          .expand((ProductModel product) => product.storePrices)
          .map((StorePrice price) => price.currentPrice.minorUnits)
          .toList();

      final Either<Failure, List<ProductModel>> result = await datasource
          .refreshAllProducts();
      final List<ProductModel> refreshed = result.getRight().toNullable() ?? [];

      expect(refreshed.length, isA<int>());
      expect(refreshed.length, 2);
      expect(
        refreshed.every(
          (ProductModel product) => product.lastUpdatedAt.isAfter(previous),
        ),
        isTrue,
      );
      expect(
        refreshed
            .expand((ProductModel product) => product.storePrices)
            .every((StorePrice price) => price.lastCheckedAt.isAfter(previous)),
        isTrue,
      );
      expect(
        refreshed
            .expand((ProductModel product) => product.storePrices)
            .map((StorePrice price) => price.currentPrice.minorUnits)
            .toList(),
        previousPrices,
      );
      expect(
        refreshed
            .expand((ProductModel product) => product.storePrices)
            .every((StorePrice price) => price.isAvailable),
        isTrue,
      );
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the product table is missing',
      () async {
        await db.customStatement('DROP TABLE product_table');

        final Either<Failure, List<ProductModel>> result = await datasource
            .refreshAllProducts();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method saveProductSource() returns the correct value', () {
    test('saves and returns a product source', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026, 1, 1),
      );

      final Either<Failure, ProductSourceModel> result = await datasource
          .saveProductSource(source);
      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();

      expect(result.getRight().toNullable(), isA<ProductSourceModel>());
      expect(rows.length, 1);
      expect(rows.single.url, source.url);
      verifyZeroInteractions(mockLoggerService);
    });

    test('returns Left(DatabaseFailure) for a duplicate source id', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026, 1, 1),
      );
      await datasource.saveProductSource(source);

      final Either<Failure, ProductSourceModel> result = await datasource
          .saveProductSource(source);
      final Failure failure =
          result.getLeft().toNullable() ??
          const DatabaseFailure('Expected a failure');

      expect(failure, isA<DatabaseFailure>());
      verify(() => mockLoggerService.e(failure.message)).called(1);
    });
  });

  group('Method updateProductSource() returns the correct value', () {
    test('updates the source URL and merchant domain', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );

      final Either<Failure, ProductSourceModel> result = await datasource
          .updateProductSource('source-1', 'https://updated.example.com/1');
      final ProductSourceModel? updated = result.getRight().toNullable();
      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();

      expect(updated, isA<ProductSourceModel>());
      expect(updated?.url, 'https://updated.example.com/1');
      expect(updated?.merchantDomain, 'updated.example.com');
      expect(row.url, 'https://updated.example.com/1');
      expect(row.merchantDomain, 'updated.example.com');
      expect(row.productId, 'product-1');
      expect(row.createdAt, buildProductSource().createdAt);
      verifyZeroInteractions(mockLoggerService);
    });

    test('leaves other sources untouched', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(
              buildProductSource(
                id: 'source-2',
                url: 'https://other.example.com/1',
              ),
            ).toCompanion(),
          );

      await datasource.updateProductSource(
        'source-1',
        'https://updated.example.com/1',
      );
      final ProductSourceRow otherRow = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-2'))).getSingle();

      expect(otherRow.url, 'https://other.example.com/1');
      expect(otherRow.merchantDomain, 'other.example.com');
    });

    test(
      'returns Left(NotFoundFailure) when the source does not exist',
      () async {
        final Either<Failure, ProductSourceModel> result = await datasource
            .updateProductSource('missing-source', 'https://example.com/1');

        expect(result, const Left(NotFoundFailure('Source not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('returns ValidationFailure for an invalid URL', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );

      final Either<Failure, ProductSourceModel> result = await datasource
          .updateProductSource('source-1', 'http://example.com/1');

      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, ProductSourceModel> result = await datasource
            .updateProductSource('source-1', 'https://example.com/1');
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });

  group('Method createProduct() returns the correct value', () {
    test('creates the product and source atomically', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        storePrices: [],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();

      expect(result.getRight().toNullable(), isA<ProductModel>());
      expect(products.length, 1);
      expect(sources.length, 1);
      verifyZeroInteractions(mockLoggerService);
    });

    test('rejects mismatched product and source identifiers', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        storePrices: [],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-2',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);

      expect(
        result,
        const Left(
          ValidationFailure('Product and source identifiers do not match'),
        ),
      );
      expect(await db.select(db.productTable).get(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test('rolls back the product when the source insert fails', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'existing-product',
              name: 'Existing Product',
              lastUpdatedAt: DateTime(2026),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'existing-product',
              url: 'https://example.com/products/existing',
              merchantDomain: 'example.com',
              createdAt: DateTime(2026),
            ),
          );
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        storePrices: [],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );
      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);

      expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
      expect(await db.select(db.productTable).get(), hasLength(1));
      expect(await db.select(db.productSourceTable).get(), hasLength(1));
      verify(() => mockLoggerService.e(any())).called(1);
    });

    test('rejects non-empty storePrices', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        storePrices: [
          StorePrice(
            storeName: 'Example Store',
            productUrl: 'https://example.com/products/1',
            currentPrice: const Money(minorUnits: 999, currencyCode: 'USD'),
            isAvailable: true,
            lastCheckedAt: DateTime(2026),
          ),
        ],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);

      expect(
        result,
        const Left(
          ValidationFailure(
            'Product creation does not accept pre-populated store prices',
          ),
        ),
      );
      expect(await db.select(db.productTable).get(), isEmpty);
      expect(await db.select(db.productSourceTable).get(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns ValidationFailure for a directly constructed invalid source',
      () async {
        final Product product = Product(
          id: 'product-1',
          name: 'Example Product',
          storePrices: const [],
          lastUpdatedAt: DateTime(2026),
        );
        final ProductSource source = ProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'http://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: DateTime(2026),
        );

        final Either<Failure, ProductModel> result = await datasource
            .createProduct(product, source);

        expect(result.getLeft().toNullable(), isA<ValidationFailure>());
        expect(await db.select(db.productTable).get(), isEmpty);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('creates the product without a source when source == null', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        storePrices: [],
        lastUpdatedAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, null);
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();

      expect(result.getRight().toNullable(), isA<ProductModel>());
      expect(products.length, 1);
      expect(sources, isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns DatabaseFailure when the product insert fails and source == null',
      () async {
        await db
            .into(db.productTable)
            .insert(
              ProductTableCompanion.insert(
                id: 'product-1',
                name: 'Existing Product',
                lastUpdatedAt: DateTime(2026),
              ),
            );
        final Product product = Product(
          id: 'product-1',
          name: 'Example Product',
          storePrices: [],
          lastUpdatedAt: DateTime(2026),
        );

        final Either<Failure, ProductModel> result = await datasource
            .createProduct(product, null);

        expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
        expect(await db.select(db.productTable).get(), hasLength(1));
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });

  group('Method loadProductSourcesForProduct() returns the correct value', () {
    test('loads the saved source for a product', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      final Either<Failure, List<ProductSourceModel>> result = await datasource
          .loadProductSourcesForProduct('product-1');

      expect(result.getRight().toNullable()?.single.id, 'source-1');
      verifyZeroInteractions(mockLoggerService);
    });

    test('returns an empty list when a product has no saved source', () async {
      final Either<Failure, List<ProductSourceModel>> result = await datasource
          .loadProductSourcesForProduct('product-1');

      expect(result.getRight().toNullable(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('Method replaceProductPrices() returns the correct value', () {
    test('replaces persisted offers and updates the product', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      final StorePriceModel price = StorePriceModel(
        storeName: 'Example Store',
        productUrl: 'https://example.com/products/1',
        currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
        isAvailable: true,
        lastCheckedAt: DateTime(2026, 1, 2),
      );

      final Either<Failure, ProductModel> result = await datasource
          .replaceProductPrices('product-1', [price]);
      final List<StorePriceRow> rows = await (db.select(
        db.storePriceTable,
      )..where((table) => table.productId.equals('product-1'))).get();

      expect(result.getRight().toNullable()?.storePrices.single, price);
      expect(rows.single.minorUnits, 1999);
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('Method loadProductSources() returns the correct value', () {
    test('loads every saved product source', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      final Either<Failure, List<ProductSourceModel>> result = await datasource
          .loadProductSources();
      final List<ProductSourceModel> sources =
          result.getRight().toNullable() ?? [];

      expect(sources.length, 1);
      expect(sources.single.id, 'source-1');
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, List<ProductSourceModel>> result =
            await datasource.loadProductSources();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });
}
