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

  group('ProductTable — round trip', () {
    test('stores and reads a product row', () async {
      await db
          .into(db.productTable)
          .insert(
            ProductTableCompanion.insert(
              id: 'product-1',
              name: 'Example Product',
              lastUpdatedAt: DateTime(2026, 1, 1, 12),
            ),
          );

      final ProductRow row = await db.select(db.productTable).getSingle();

      expect(row.id, isA<String>());
      expect(row.id, 'product-1');
      expect(row.name, isA<String>());
      expect(row.name, 'Example Product');
      expect(row.imageUrl, isNull);
    });
  });
}
