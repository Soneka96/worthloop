// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';

void main() {
  group('CreateProductParams equality', () {
    test('includes the product name and URL', () {
      const CreateProductParams params = CreateProductParams(
        name: 'Example Product',
        url: 'https://example.com/products/1',
      );

      expect(
        params,
        const CreateProductParams(
          name: 'Example Product',
          url: 'https://example.com/products/1',
        ),
      );
      expect(
        params,
        isNot(
          const CreateProductParams(
            name: 'Other Product',
            url: 'https://example.com/products/1',
          ),
        ),
      );
    });
  });
}
