// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';

void main() {
  group('AddSourceParams equality', () {
    test('includes the product identifier and URL', () {
      const AddSourceParams params = AddSourceParams(
        productId: 'product-1',
        url: 'https://example.com/products/1',
      );

      expect(params.props, <Object?>[
        'product-1',
        'https://example.com/products/1',
      ]);
      expect(
        params,
        const AddSourceParams(
          productId: 'product-1',
          url: 'https://example.com/products/1',
        ),
      );
      expect(
        params,
        isNot(
          const AddSourceParams(
            productId: 'product-2',
            url: 'https://example.com/products/1',
          ),
        ),
      );
      expect(
        params,
        isNot(
          const AddSourceParams(
            productId: 'product-1',
            url: 'https://example.com/products/2',
          ),
        ),
      );
    });
  });
}
