// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import '../../fixtures/product.fixture.dart';

void main() {
  group('Source refresh actions carry their values', () {
    test('ProductsUpdatedFromDatabaseAction carries products', () {
      final product = buildProduct();
      const ProductsUpdatedFromDatabaseAction action =
          ProductsUpdatedFromDatabaseAction([]);

      expect(action.products, isA<List>());
      expect(action.products, isEmpty);
      expect(ProductsUpdatedFromDatabaseAction([product]).products, [product]);
    });

    test('RefreshSourceAction carries the source identifier', () {
      const RefreshSourceAction action = RefreshSourceAction('source-1');

      expect(action.sourceId, isA<String>());
      expect(action.sourceId, 'source-1');
      expect(action, const RefreshSourceAction('source-1'));
      expect(action, isNot(const RefreshSourceAction('source-2')));
    });

    test('SourceRefreshFinishedAction has no values', () {
      const SourceRefreshFinishedAction action = SourceRefreshFinishedAction();

      expect(action.props, isEmpty);
    });
  });
}
