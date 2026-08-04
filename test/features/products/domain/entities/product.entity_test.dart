// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
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
}
