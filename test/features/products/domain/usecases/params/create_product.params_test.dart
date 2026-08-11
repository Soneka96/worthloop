// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';

void main() {
  group('CreateProductParams equality', () {
    test('includes the product name', () {
      const CreateProductParams params = CreateProductParams(
        name: 'Example Product',
      );

      expect(params, const CreateProductParams(name: 'Example Product'));
      expect(params, isNot(const CreateProductParams(name: 'Other Product')));
    });
  });
}
