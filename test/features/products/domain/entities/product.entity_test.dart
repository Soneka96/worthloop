// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/store_price.fixture.dart';

void main() {
  group('Product equality', () {
    test('includes every product field', () {
      final Product product = buildProduct(storePrices: [buildStorePrice()]);

      expect(product.props, <Object?>[
        'product-1',
        'Example Product',
        'https://example.com/product.png',
        [buildStorePrice()],
        DateTime(2026, 1, 1, 12),
      ]);
      expect(product, buildProduct(storePrices: [buildStorePrice()]));
      expect(product, isNot(buildProduct(id: 'product-2')));
    });

    test('supports a product without an image', () {
      final Product product = buildProduct(imageUrl: null);

      expect(product.imageUrl, isNull);
    });
  });

  group('Getter availablePricesSorted returns the correct value', () {
    test('returns available offers sorted by ascending minorUnits', () {
      final StorePrice expensive = buildStorePrice(
        storeName: 'Expensive',
        currentPrice: buildMoney(minorUnits: 60000),
      );
      final StorePrice unavailable = buildStorePrice(
        storeName: 'Unavailable',
        currentPrice: buildMoney(minorUnits: 10000),
        isAvailable: false,
      );
      final StorePrice cheapest = buildStorePrice(
        storeName: 'Cheapest',
        currentPrice: buildMoney(minorUnits: 40000),
      );
      final Product product = buildProduct(
        storePrices: [expensive, unavailable, cheapest],
      );

      expect(product.availablePricesSorted, [cheapest, expensive]);
      expect(product.storePrices, [expensive, unavailable, cheapest]);
    });

    test('returns an empty list when every offer is unavailable', () {
      final Product product = buildProduct(
        storePrices: [buildStorePrice(isAvailable: false)],
      );

      expect(product.availablePricesSorted, isEmpty);
    });
  });

  group('Getter bestAvailablePrice returns the correct value', () {
    test('returns the lowest available offer', () {
      final StorePrice expensive = buildStorePrice(
        currentPrice: buildMoney(minorUnits: 60000),
      );
      final StorePrice cheapest = buildStorePrice(
        storeName: 'Cheapest',
        currentPrice: buildMoney(minorUnits: 40000),
      );
      final Product product = buildProduct(storePrices: [expensive, cheapest]);

      expect(product.bestAvailablePrice, cheapest);
    });

    test('returns null when no offer is available', () {
      final Product product = buildProduct();

      expect(product.bestAvailablePrice, isNull);
    });

    test('returns null when every offer is unavailable', () {
      final Product product = buildProduct(
        storePrices: [buildStorePrice(isAvailable: false)],
      );

      expect(product.bestAvailablePrice, isNull);
    });
  });
}
