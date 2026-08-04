// Package imports:
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late AppDatabase db;
  late MockLoggerService mockLoggerService;
  late ProductsLocalDatasource datasource;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockLoggerService = MockLoggerService();
    sl.registerSingleton<LoggerService>(mockLoggerService);
    datasource = ProductsLocalDatasource(db);
  });

  tearDown(() async {
    await db.close();
    await sl.reset();
    reset(mockLoggerService);
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
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('does not duplicate illustrative products on a second load', () async {
      await datasource.loadProducts();

      await datasource.loadProducts();
      final List<ProductRow> rows = await db.select(db.productTable).get();

      expect(rows.length, isA<int>());
      expect(rows.length, 2);
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
}
