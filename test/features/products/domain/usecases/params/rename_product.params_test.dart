// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';

void main() {
  group('RenameProductParams equality', () {
    test('includes the product identifier and name', () {
      const RenameProductParams params = RenameProductParams(
        productId: 'product-1',
        name: 'Example Product',
      );

      expect(params.props, <Object?>['product-1', 'Example Product']);
      expect(
        params,
        const RenameProductParams(
          productId: 'product-1',
          name: 'Example Product',
        ),
      );
      expect(
        params,
        isNot(
          const RenameProductParams(
            productId: 'product-2',
            name: 'Example Product',
          ),
        ),
      );
      expect(
        params,
        isNot(
          const RenameProductParams(
            productId: 'product-1',
            name: 'Other Product',
          ),
        ),
      );
    });
  });
}
