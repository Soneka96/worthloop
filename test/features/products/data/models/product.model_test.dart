// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import '../../fixtures/product_model.fixture.dart';

void main() {
  group('ProductModel is an implementation of Product', () {
    test('ProductModel is a Product', () {
      expect(buildProductModel(), isA<Product>());
    });
  });

  group("ProductModel's methods return the correct value", () {
    test('Method fromRows() should return a ProductModel', () {
      final ProductModel model = ProductModel.fromRows(
        ProductRow(
          id: 'product-1',
          name: 'Example Product',
          imageUrl: null,
          lastUpdatedAt: DateTime(2026, 1, 1, 12),
        ),
        [
          StorePriceRow(
            productId: 'product-1',
            storeName: 'Example Store',
            productUrl: 'https://example.com/product',
            minorUnits: 49999,
            currencyCode: 'EUR',
            isAvailable: true,
            lastCheckedAt: DateTime(2026, 1, 1, 12),
          ),
        ],
      );

      expect(model.id, isA<String>());
      expect(model.id, 'product-1');
      expect(model.name, isA<String>());
      expect(model.name, 'Example Product');
      expect(model.imageUrl, isNull);
      expect(model.storePrices.length, isA<int>());
      expect(model.storePrices.length, 1);
      expect(model.lastUpdatedAt, DateTime(2026, 1, 1, 12));
    });

    test('Method toCompanion() should return the correct companion', () {
      final ProductTableCompanion companion = buildProductModel().toCompanion();

      expect(companion.id.value, 'product-1');
      expect(companion.name.value, isA<String>());
      expect(companion.name.value, 'Example Product');
      expect(companion.imageUrl.value, isA<String>());
      expect(companion.imageUrl.value, 'https://example.com/product.png');
      expect(companion.lastUpdatedAt.value, DateTime(2026, 1, 1, 12));
    });
  });
}
