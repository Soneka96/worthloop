// Package imports:
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import '../../fixtures/store_price_model.fixture.dart';

void main() {
  group('StorePriceModel is an implementation of StorePrice', () {
    test('StorePriceModel is a StorePrice', () {
      expect(buildStorePriceModel(), isA<StorePrice>());
    });
  });

  group("StorePriceModel's methods return the correct value", () {
    test('Method fromRow() should return a StorePriceModel', () {
      final StorePriceModel model = StorePriceModel.fromRow(
        StorePriceRow(
          productId: 'product-1',
          storeName: 'Example Store',
          productUrl: 'https://example.com/product',
          minorUnits: 49999,
          currencyCode: 'EUR',
          isAvailable: true,
          lastCheckedAt: DateTime(2026, 1, 1, 12),
        ),
      );

      expect(model.storeName, isA<String>());
      expect(model.storeName, 'Example Store');
      expect(model.productUrl, isA<String>());
      expect(model.productUrl, 'https://example.com/product');
      expect(model.currentPrice.minorUnits, isA<int>());
      expect(model.currentPrice.minorUnits, 49999);
      expect(model.currentPrice.currencyCode, isA<String>());
      expect(model.currentPrice.currencyCode, 'EUR');
      expect(model.isAvailable, isA<bool>());
      expect(model.isAvailable, isTrue);
      expect(model.lastCheckedAt, DateTime(2026, 1, 1, 12));
    });

    test('Method toCompanion() should return the correct companion', () {
      final StorePriceTableCompanion companion = buildStorePriceModel()
          .toCompanion('product-1');

      expect(companion.productId.value, isA<String>());
      expect(companion.productId.value, 'product-1');
      expect(companion.storeName.value, isA<String>());
      expect(companion.storeName.value, 'Example Store');
      expect(companion.productUrl.value, isA<String>());
      expect(companion.productUrl.value, 'https://example.com/product');
      expect(companion.minorUnits.value, isA<int>());
      expect(companion.minorUnits.value, 49999);
      expect(companion.currencyCode, const Value('EUR'));
      expect(companion.isAvailable.value, isTrue);
      expect(companion.lastCheckedAt.value, DateTime(2026, 1, 1, 12));
    });
  });
}
