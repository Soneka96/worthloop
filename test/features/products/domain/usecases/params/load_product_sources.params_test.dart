// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/load_product_sources.params.dart';

void main() {
  group('LoadProductSourcesParams equality', () {
    test('includes productId', () {
      const LoadProductSourcesParams params = LoadProductSourcesParams(
        productId: 'product-1',
      );

      expect(params.props, <Object?>['product-1']);
      expect(params, const LoadProductSourcesParams(productId: 'product-1'));
      expect(
        params,
        isNot(const LoadProductSourcesParams(productId: 'product-2')),
      );
    });
  });
}
