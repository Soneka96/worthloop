// Flutter imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_price_change.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../fixtures/product.fixture.dart';

void main() {
  group('ProductPriceChange equality', () {
    test('includes product, both best prices, and direction', () {
      final ProductPriceChange change = ProductPriceChange(
        product: buildProduct(),
        previousBestPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
        currentBestPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
        direction: PriceChangeDirection.drop,
      );

      expect(change.props, [
        buildProduct(),
        const Money(minorUnits: 2999, currencyCode: 'EUR'),
        const Money(minorUnits: 1999, currencyCode: 'EUR'),
        PriceChangeDirection.drop,
      ]);
      expect(
        change,
        isNot(
          ProductPriceChange(
            product: buildProduct(),
            previousBestPrice: const Money(
              minorUnits: 2999,
              currencyCode: 'EUR',
            ),
            currentBestPrice: const Money(
              minorUnits: 1999,
              currencyCode: 'EUR',
            ),
            direction: PriceChangeDirection.increase,
          ),
        ),
      );
    });

    test('two instances with identical fields are equal', () {
      ProductPriceChange build() => ProductPriceChange(
        product: buildProduct(),
        previousBestPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
        currentBestPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
        direction: PriceChangeDirection.none,
      );

      expect(build(), build());
    });
  });
}
