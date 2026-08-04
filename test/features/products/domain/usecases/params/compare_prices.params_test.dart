// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/compare_prices.params.dart';
import '../../../fixtures/product.fixture.dart';

void main() {
  group('ComparePricesParams equality', () {
    test('includes product', () {
      final ComparePricesParams params = ComparePricesParams(
        product: buildProduct(),
      );

      expect(params.props, <Object?>[buildProduct()]);
      expect(params, ComparePricesParams(product: buildProduct()));
      expect(
        params,
        isNot(ComparePricesParams(product: buildProduct(id: 'product-2'))),
      );
    });
  });
}
