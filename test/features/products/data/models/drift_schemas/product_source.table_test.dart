// Package imports:
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db
        .into(db.productTable)
        .insert(
          ProductTableCompanion.insert(
            id: 'product-1',
            name: 'Example Product',
            lastUpdatedAt: DateTime(2026, 1, 1),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('ProductSourceTable — round trip', () {
    test('stores and reads a product source row with no offer yet', () async {
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

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.id, 'source-1');
      expect(row.productId, 'product-1');
      expect(row.url, 'https://example.com/products/1');
      expect(row.merchantDomain, 'example.com');
      expect(row.createdAt, DateTime(2026, 1, 1));
      expect(row.minorUnits, isNull);
      expect(row.currencyCode, isNull);
      expect(row.isAvailable, isNull);
      expect(row.lastCheckedAt, isNull);
      expect(row.lastRefreshStatus, isNull);
      expect(row.lastRefreshAt, isNull);
      expect(row.liveStatus, isNull);
    });

    test(
      'stores and reads a product source row with a fetched offer',
      () async {
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceTableCompanion.insert(
                id: 'source-1',
                productId: 'product-1',
                url: 'https://example.com/products/1',
                merchantDomain: 'example.com',
                minorUnits: const Value(49999),
                currencyCode: const Value('EUR'),
                isAvailable: const Value(true),
                lastCheckedAt: Value(DateTime(2026, 1, 1, 12)),
                lastRefreshStatus: const Value('blocked'),
                lastRefreshAt: Value(DateTime(2026, 1, 3, 12)),
                liveStatus: const Value('fetching'),
                createdAt: DateTime(2026, 1, 1),
              ),
            );

        final ProductSourceRow row = await db
            .select(db.productSourceTable)
            .getSingle();

        expect(row.minorUnits, isA<int>());
        expect(row.minorUnits, 49999);
        expect(row.currencyCode, isA<String>());
        expect(row.currencyCode, 'EUR');
        expect(row.isAvailable, isA<bool>());
        expect(row.isAvailable, isTrue);
        expect(row.lastCheckedAt, DateTime(2026, 1, 1, 12));
        expect(row.lastRefreshStatus, PriceFetchStatus.blocked.name);
        expect(row.lastRefreshAt, DateTime(2026, 1, 3, 12));
        expect(row.liveStatus, isA<String>());
        expect(row.liveStatus, SourceRefreshStatus.fetching.name);
      },
    );

    test('stores and reads isAvailable = false', () async {
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              minorUnits: const Value(49999),
              currencyCode: const Value('EUR'),
              isAvailable: const Value(false),
              lastCheckedAt: Value(DateTime(2026, 1, 1, 12)),
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.isAvailable, isA<bool>());
      expect(row.isAvailable, isFalse);
    });

    test('stores an offer field independently of the others', () async {
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              minorUnits: const Value(49999),
              currencyCode: const Value('EUR'),
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.minorUnits, isA<int>());
      expect(row.minorUnits, 49999);
      expect(row.isAvailable, isNull);
      expect(row.lastCheckedAt, isNull);
    });

    test('updates liveStatus independently of other columns', () async {
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              minorUnits: const Value(49999),
              currencyCode: const Value('EUR'),
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      await (db.update(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).write(
        const ProductSourceTableCompanion(liveStatus: Value('queued')),
      );

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.liveStatus, isA<String>());
      expect(row.liveStatus, SourceRefreshStatus.queued.name);
      expect(row.minorUnits, isA<int>());
      expect(row.minorUnits, 49999);
    });

    test('clears liveStatus back to null', () async {
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              liveStatus: const Value('fetching'),
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      await (db.update(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).write(
        const ProductSourceTableCompanion(liveStatus: Value(null)),
      );

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.liveStatus, isNull);
    });

    test('updating another column leaves liveStatus untouched', () async {
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceTableCompanion.insert(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/products/1',
              merchantDomain: 'example.com',
              liveStatus: const Value('queued'),
              createdAt: DateTime(2026, 1, 1),
            ),
          );

      await (db.update(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).write(
        const ProductSourceTableCompanion(minorUnits: Value(49999)),
      );

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.liveStatus, isA<String>());
      expect(row.liveStatus, SourceRefreshStatus.queued.name);
    });

    test('rejects a duplicate id', () async {
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

      await expectLater(
        () => db
            .into(db.productSourceTable)
            .insert(
              ProductSourceTableCompanion.insert(
                id: 'source-1',
                productId: 'product-1',
                url: 'https://example.com/products/2',
                merchantDomain: 'other.com',
                createdAt: DateTime(2026, 1, 1),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();
      expect(rows.length, isA<int>());
      expect(rows.length, 1);
    });

    test('rejects a duplicate url for the same product', () async {
      final ProductSourceTableCompanion source =
          ProductSourceTableCompanion.insert(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: DateTime(2026, 1, 1),
          );
      await db.into(db.productSourceTable).insert(source);

      await expectLater(
        () => db
            .into(db.productSourceTable)
            .insert(
              ProductSourceTableCompanion.insert(
                id: 'source-2',
                productId: 'product-1',
                url: 'https://example.com/products/1',
                merchantDomain: 'example.com',
                createdAt: DateTime(2026, 1, 1),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();
      expect(rows.length, isA<int>());
      expect(rows.length, 1);
    });

    test('allows the same url for different products', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-2',
              name: 'Another Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      for (final String productId in ['product-1', 'product-2']) {
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceTableCompanion.insert(
                id: 'source-$productId',
                productId: productId,
                url: 'https://example.com/products/1',
                merchantDomain: 'example.com',
                createdAt: DateTime(2026, 1, 1),
              ),
            );
      }

      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();

      expect(rows.length, isA<int>());
      expect(rows.length, 2);
    });

    test('deletes sources when their product is deleted', () async {
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

      await (db.delete(
        db.productTable,
      )..where((table) => table.id.equals('product-1'))).go();

      expect(await db.select(db.productSourceTable).get(), isEmpty);
    });

    test('deleting a product cascades only its own sources', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-2',
              name: 'Another Product',
              lastUpdatedAt: DateTime(2026, 1, 1),
            ),
          );
      for (final String productId in ['product-1', 'product-2']) {
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceTableCompanion.insert(
                id: 'source-$productId',
                productId: productId,
                url: 'https://example.com/$productId',
                merchantDomain: 'example.com',
                createdAt: DateTime(2026, 1, 1),
              ),
            );
      }

      await (db.delete(
        db.productTable,
      )..where((table) => table.id.equals('product-1'))).go();
      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();

      expect(rows.length, isA<int>());
      expect(rows.length, 1);
      expect(rows.single.productId, isA<String>());
      expect(rows.single.productId, 'product-2');
    });

    test('rejects a source for a missing product', () async {
      await expectLater(
        () => db
            .into(db.productSourceTable)
            .insert(
              ProductSourceTableCompanion.insert(
                id: 'source-1',
                productId: 'missing-product',
                url: 'https://example.com/products/1',
                merchantDomain: 'example.com',
                createdAt: DateTime(2026, 1, 1),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      expect(await db.select(db.productSourceTable).get(), isEmpty);
    });
  });
}
