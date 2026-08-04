// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/tracked_product.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_list.widget.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import '../../../products/fixtures/product.fixture.dart';

void main() {
  Widget buildWidget({
    List<Product> products = const [],
    ValueChanged<String>? onProductTap,
  }) => MaterialApp(
    home: Scaffold(
      body: TrackedProductsListWidget(
        products: products,
        onProductTap: onProductTap ?? (_) {},
      ),
    ),
  );

  group('TrackedProductsListWidget contains widgets', () {
    testWidgets('TrackedProductsListWidget contains every tracked product', (
      WidgetTester tester,
    ) async {
      final List<Product> products = [
        buildProduct(id: 'product-1', name: 'First Product'),
        buildProduct(id: 'product-2', name: 'Second Product'),
      ];

      await tester.pumpWidget(buildWidget(products: products));

      expect(find.byType(TrackedProductWidget), findsNWidgets(2));
      expect(find.text('First Product'), findsOneWidget);
      expect(find.text('Second Product'), findsOneWidget);

      final List<TrackedProductWidget> productWidgets = tester
          .widgetList<TrackedProductWidget>(find.byType(TrackedProductWidget))
          .toList(growable: false);
      expect(
        productWidgets.map((TrackedProductWidget widget) => widget.product.id),
        ['product-1', 'product-2'],
      );
    });

    testWidgets(
      'TrackedProductsListWidget contains no children when products is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(TrackedProductWidget), findsNothing);
      },
    );

    testWidgets('TrackedProductsListWidget uses a lazy product list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(products: [buildProduct()]));

      final ListView listView = tester.widget(find.byType(ListView));

      expect(listView.childrenDelegate, isA<SliverChildBuilderDelegate>());
    });
  });

  group("TrackedProductsListWidget's elements behavior", () {
    testWidgets(
      'TrackedProductsListWidget calls onProductTap with the selected product id',
      (WidgetTester tester) async {
        String? selectedProductId;
        final List<Product> products = [
          buildProduct(id: 'first-product'),
          buildProduct(id: 'selected-product'),
        ];

        await tester.pumpWidget(
          buildWidget(
            products: products,
            onProductTap: (String productId) => selectedProductId = productId,
          ),
        );

        await tester.tap(find.byKey(Key('tracked-product-${products[0].id}')));

        expect(selectedProductId, isA<String>());
        expect(selectedProductId, products[0].id);

        await tester.tap(find.byKey(Key('tracked-product-${products[1].id}')));

        expect(selectedProductId, isA<String>());
        expect(selectedProductId, products[1].id);
      },
    );
  });
}
