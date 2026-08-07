// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/shared/constants/enums.dart';

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

    test('excludes onSourceStatusChanged from equality', () {
      void listener(String sourceId, SourceRefreshStatus status) {}
      final RefreshProductParams withListener = RefreshProductParams(
        productId: 'product-1',
        onSourceStatusChanged: listener,
      );

      expect(withListener, const RefreshProductParams(productId: 'product-1'));
    });

    test('stores an onPriceDrop listener without affecting equality', () {
      Future<void> listener(value) async {}
      final RefreshProductParams withListener = RefreshProductParams(
        productId: 'product-1',
        onPriceDrop: listener,
      );

      expect(withListener.onPriceDrop, same(listener));
      expect(withListener, const RefreshProductParams(productId: 'product-1'));
    });
  });
}
