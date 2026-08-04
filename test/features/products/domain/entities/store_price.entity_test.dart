// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/store_price.fixture.dart';

void main() {
  group('StorePrice equality', () {
    test('includes every offer field', () {
      final StorePrice storePrice = buildStorePrice();

      expect(storePrice.props, <Object?>[
        'Example Store',
        'https://example.com/product',
        buildMoney(),
        true,
        DateTime(2026, 1, 1, 12),
      ]);
      expect(storePrice, buildStorePrice());
      expect(storePrice, isNot(buildStorePrice(storeName: 'Another Store')));
    });
  });
}
