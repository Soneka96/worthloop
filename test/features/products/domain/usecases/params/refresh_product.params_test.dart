// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';

void main() {
  group('RefreshProductParams equality', () {
    test('includes productId', () {
      const RefreshProductParams params = RefreshProductParams(
        productId: 'product-1',
      );

      expect(params.props, <Object?>['product-1']);
      expect(params, const RefreshProductParams(productId: 'product-1'));
      expect(params, isNot(const RefreshProductParams(productId: 'product-2')));
    });
  });
}
