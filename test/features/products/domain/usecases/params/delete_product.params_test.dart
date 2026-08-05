// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';

void main() {
  group('DeleteProductParams equality', () {
    test('includes the product identifier', () {
      const DeleteProductParams params = DeleteProductParams(
        productId: 'product-1',
      );

      expect(params.props, <Object?>['product-1']);
      expect(params, const DeleteProductParams(productId: 'product-1'));
      expect(params, isNot(const DeleteProductParams(productId: 'product-2')));
    });
  });
}
