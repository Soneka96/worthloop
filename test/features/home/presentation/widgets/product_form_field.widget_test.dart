// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/product_form_field.widget.dart';

void main() {
  group('ProductFormField contains widgets', () {
    testWidgets('ProductFormField displays its label and hint', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductFormField(
              controller: controller,
              key: const Key('test-field'),
              label: 'Product name',
              hint: 'Example Product',
              validator: (_) => null,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test-field')), findsOneWidget);
      expect(find.text('Product name'), findsOneWidget);
      expect(find.text('Example Product'), findsOneWidget);
    });
  });
}
