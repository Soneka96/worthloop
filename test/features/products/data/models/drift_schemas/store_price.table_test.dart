// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';

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
            lastUpdatedAt: DateTime(2026, 1, 1, 12),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('StorePriceTable — round trip', () {
    test('stores and reads a merchant offer row', () async {
      await db
          .into(db.storePriceTable)
          .insert(
            StorePriceTableCompanion.insert(
              productId: 'product-1',
              storeName: 'Example Store',
              productUrl: 'https://example.com/product',
              minorUnits: 49999,
              currencyCode: 'EUR',
              isAvailable: true,
              lastCheckedAt: DateTime(2026, 1, 1, 12),
            ),
          );

      final StorePriceRow row = await db.select(db.storePriceTable).getSingle();

      expect(row.storeName, isA<String>());
      expect(row.storeName, 'Example Store');
      expect(row.minorUnits, isA<int>());
      expect(row.minorUnits, 49999);
      expect(row.isAvailable, isA<bool>());
      expect(row.isAvailable, isTrue);
    });

    test('rejects a duplicate product and store pair', () async {
      final StorePriceTableCompanion offer = StorePriceTableCompanion.insert(
        productId: 'product-1',
        storeName: 'Example Store',
        productUrl: 'https://example.com/product',
        minorUnits: 49999,
        currencyCode: 'EUR',
        isAvailable: true,
        lastCheckedAt: DateTime(2026, 1, 1, 12),
      );
      await db.into(db.storePriceTable).insert(offer);

      expect(
        () => db.into(db.storePriceTable).insert(offer),
        throwsA(isA<SqliteException>()),
      );
    });

    test('rejects an offer for a missing product', () async {
      expect(
        () => db
            .into(db.storePriceTable)
            .insert(
              StorePriceTableCompanion.insert(
                productId: 'missing',
                storeName: 'Example Store',
                productUrl: 'https://example.com/product',
                minorUnits: 49999,
                currencyCode: 'EUR',
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 1, 12),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('allows the same store name for different products', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-2',
              name: 'Another Product',
              lastUpdatedAt: DateTime(2026, 1, 1, 12),
            ),
          );
      for (final String productId in ['product-1', 'product-2']) {
        await db
            .into(db.storePriceTable)
            .insert(
              StorePriceTableCompanion.insert(
                productId: productId,
                storeName: 'Example Store',
                productUrl: 'https://example.com/$productId',
                minorUnits: 49999,
                currencyCode: 'EUR',
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 1, 12),
              ),
            );
      }

      final List<StorePriceRow> rows = await db
          .select(db.storePriceTable)
          .get();

      expect(rows.length, isA<int>());
      expect(rows.length, 2);
    });

    test('deleting a product cascades only its offers', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-2',
              name: 'Another Product',
              lastUpdatedAt: DateTime(2026, 1, 1, 12),
            ),
          );
      for (final String productId in ['product-1', 'product-2']) {
        await db
            .into(db.storePriceTable)
            .insert(
              StorePriceTableCompanion.insert(
                productId: productId,
                storeName: 'Example Store',
                productUrl: 'https://example.com/$productId',
                minorUnits: 49999,
                currencyCode: 'EUR',
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 1, 12),
              ),
            );
      }

      await (db.delete(
        db.productTable,
      )..where((table) => table.id.equals('product-1'))).go();
      final List<StorePriceRow> rows = await db
          .select(db.storePriceTable)
          .get();

      expect(rows.length, isA<int>());
      expect(rows.length, 1);
      expect(rows.single.productId, isA<String>());
      expect(rows.single.productId, 'product-2');
    });
  });
}
