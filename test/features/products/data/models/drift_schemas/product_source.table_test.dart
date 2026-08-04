// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('ProductSourceTable — round trip', () {
    test('stores and reads a product source row', () async {
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

      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.id, 'source-1');
      expect(row.productId, 'product-1');
      expect(row.url, 'https://example.com/products/1');
      expect(row.merchantDomain, 'example.com');
      expect(row.createdAt, DateTime(2026, 1, 1));
    });

    test('deletes sources when their product is deleted', () async {
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

      await (db.delete(
        db.productTable,
      )..where((table) => table.id.equals('product-1'))).go();

      expect(await db.select(db.productSourceTable).get(), isEmpty);
    });

    test('rejects sources for a missing product', () async {
      expect(
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
        throwsA(isA<Exception>()),
      );
    });
  });
}
