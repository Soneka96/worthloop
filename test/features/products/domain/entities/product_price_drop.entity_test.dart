// Flutter imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_price_drop.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import '../../fixtures/product.fixture.dart';

void main() {
  group('ProductPriceDrop equality', () {
    test('includes product and both best prices', () {
      final ProductPriceDrop drop = ProductPriceDrop(
        product: buildProduct(),
        previousBestPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
        currentBestPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
      );

      expect(drop.props, [
        buildProduct(),
        const Money(minorUnits: 2999, currencyCode: 'EUR'),
        const Money(minorUnits: 1999, currencyCode: 'EUR'),
      ]);
    });
  });
}
