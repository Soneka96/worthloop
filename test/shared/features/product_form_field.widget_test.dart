// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/features/product_form_field.widget.dart';

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

    testWidgets(
      'ProductFormField does not request focus when autofocus is omitted',
      (WidgetTester tester) async {
        final TextEditingController controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductFormField(
                controller: controller,
                key: const Key('test-field'),
                label: 'Product name',
                validator: (_) => null,
              ),
            ),
          ),
        );

        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .focusNode
              .hasFocus,
          isFalse,
        );
      },
    );

    testWidgets('ProductFormField requests focus when autofocus = true', (
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
              validator: (_) => null,
              autofocus: true,
            ),
          ),
        ),
      );

      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue,
      );
    });
  });
}
