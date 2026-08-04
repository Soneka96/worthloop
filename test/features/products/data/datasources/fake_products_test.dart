// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/fake_products.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';

void main() {
  group('buildFakeProducts behaves correctly', () {
    test('returns the two illustrative USD products', () {
      final DateTime checkedAt = DateTime(2026, 1, 1, 12);
      final List<ProductModel> products = buildFakeProducts(checkedAt);

      expect(products.length, isA<int>());
      expect(products.length, 2);
      expect(products.first.name, isA<String>());
      expect(products.first.name, 'Moza R12 V2 Wheelbase');
      expect(products.last.name, isA<String>());
      expect(products.last.name, 'Next Level Racing Wheel Stand 2.0');
      expect(products.first.id, isA<String>());
      expect(products.first.id, 'moza-r12-v2');
      expect(products.last.id, isA<String>());
      expect(products.last.id, 'nlr-wheel-stand-2');
      expect(products.first.storePrices.length, isA<int>());
      expect(products.first.storePrices.length, 4);
      expect(products.last.storePrices.length, isA<int>());
      expect(products.last.storePrices.length, 3);
      expect(
        products
            .expand((ProductModel product) => product.storePrices)
            .every(
              (StorePrice price) => price.currentPrice.currencyCode == 'USD',
            ),
        isTrue,
      );
      expect(
        products
            .expand((ProductModel product) => product.storePrices)
            .every((StorePrice price) => price.isAvailable),
        isTrue,
      );
      expect(
        products
            .expand((ProductModel product) => product.storePrices)
            .every(
              (StorePrice price) =>
                  price.productUrl.startsWith('https://example.com/'),
            ),
        isTrue,
      );
      expect(
        products
            .expand((ProductModel product) => product.storePrices)
            .every((StorePrice price) => price.lastCheckedAt == checkedAt),
        isTrue,
      );
      expect(
        products.every(
          (ProductModel product) => product.lastUpdatedAt == checkedAt,
        ),
        isTrue,
      );
    });
  });
}
