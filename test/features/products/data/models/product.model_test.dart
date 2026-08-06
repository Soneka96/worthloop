// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
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
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/product',
            merchantDomain: 'example.com',
            minorUnits: 49999,
            currencyCode: 'EUR',
            isAvailable: true,
            lastCheckedAt: DateTime(2026, 1, 1, 12),
            createdAt: DateTime(2026, 1, 1, 12),
          ),
        ],
      );

      expect(model.id, isA<String>());
      expect(model.id, 'product-1');
      expect(model.name, isA<String>());
      expect(model.name, 'Example Product');
      expect(model.imageUrl, isNull);
      expect(model.sources.length, isA<int>());
      expect(model.sources.length, 1);
      expect(model.sources.single.currentPrice?.minorUnits, 49999);
      expect(model.lastUpdatedAt, DateTime(2026, 1, 1, 12));
    });

    test(
      'Method fromRows() maps a source row with no offer fetched yet',
      () {
        final ProductModel model = ProductModel.fromRows(
          ProductRow(
            id: 'product-1',
            name: 'Example Product',
            imageUrl: null,
            lastUpdatedAt: DateTime(2026, 1, 1, 12),
          ),
          [
            ProductSourceRow(
              id: 'source-1',
              productId: 'product-1',
              url: 'https://example.com/product',
              merchantDomain: 'example.com',
              createdAt: DateTime(2026, 1, 1, 12),
            ),
          ],
        );

        expect(model.sources.single.currentPrice, isNull);
      },
    );

    test('Method fromRows() returns an empty sources list when given none', () {
      final ProductModel model = ProductModel.fromRows(
        ProductRow(
          id: 'product-1',
          name: 'Example Product',
          imageUrl: null,
          lastUpdatedAt: DateTime(2026, 1, 1, 12),
        ),
        const [],
      );

      expect(model.sources, isEmpty);
    });

    test('Method fromRows() maps every source row when given more than one', () {
      final ProductModel model = ProductModel.fromRows(
        ProductRow(
          id: 'product-1',
          name: 'Example Product',
          imageUrl: null,
          lastUpdatedAt: DateTime(2026, 1, 1, 12),
        ),
        [
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/product-1',
            merchantDomain: 'example.com',
            createdAt: DateTime(2026, 1, 1, 12),
          ),
          ProductSourceRow(
            id: 'source-2',
            productId: 'product-1',
            url: 'https://other.com/product-1',
            merchantDomain: 'other.com',
            createdAt: DateTime(2026, 1, 1, 12),
          ),
        ],
      );

      expect(model.sources.length, isA<int>());
      expect(model.sources.length, 2);
      expect(model.sources.map((ProductSource source) => source.id), [
        'source-1',
        'source-2',
      ]);
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
