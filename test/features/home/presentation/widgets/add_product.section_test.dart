// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/add_product.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({
    bool isSubmitting = false,
    String? errorMessage,
    String? createdProductId,
    void Function(String name, String url)? onSubmit,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: AddProductSection(
          isSubmitting: isSubmitting,
          errorMessage: errorMessage,
          createdProductId: createdProductId,
          onSubmit: onSubmit ?? (_, _) {},
        ),
      ),
    ),
  );

  group('AddProductSection contains widgets', () {
    testWidgets('shows the collapsed add-product section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byKey(const Key('add-product-section')), findsOneWidget);
      expect(find.text(t.home.addProductTitle), findsOneWidget);
      expect(find.byKey(const Key('add-product-name-field')), findsNothing);
    });

    testWidgets('shows the form after expanding', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byKey(const Key('add-product-section')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add-product-name-field')), findsOneWidget);
      expect(find.byKey(const Key('add-product-url-field')), findsOneWidget);
      expect(
        find.text(
          'Links can be saved now. Automatic price updates are available only for supported websites.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('add-product-submit-button')),
        findsOneWidget,
      );
    });

    testWidgets('shows the submitting state and error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(isSubmitting: true, errorMessage: 'Could not save'),
      );
      await tester.tap(find.byKey(const Key('add-product-section')));
      await tester.pump(const Duration(milliseconds: 300));

      final FilledButton button = tester.widget(
        find.byKey(const Key('add-product-submit-button')),
      );
      expect(button.onPressed, isNull);
      expect(find.text('Could not save'), findsOneWidget);
      expect(find.text(t.home.addProductSaving), findsOneWidget);
    });
  });

  group('AddProductSection validation and submission', () {
    testWidgets('shows inline validation and does not submit invalid values', (
      WidgetTester tester,
    ) async {
      bool submitted = false;
      await tester.pumpWidget(
        buildWidget(onSubmit: (_, _) => submitted = true),
      );
      await tester.tap(find.byKey(const Key('add-product-section')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-product-submit-button')));
      await tester.pump();

      expect(find.text(t.home.productNameRequired), findsOneWidget);
      expect(find.text(t.home.productUrlInvalid), findsOneWidget);
      expect(submitted, isFalse);
    });

    testWidgets('submits trimmed valid values', (WidgetTester tester) async {
      String? submittedName;
      String? submittedUrl;
      await tester.pumpWidget(
        buildWidget(
          onSubmit: (String name, String url) {
            submittedName = name;
            submittedUrl = url;
          },
        ),
      );
      await tester.tap(find.byKey(const Key('add-product-section')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('add-product-name-field')),
          matching: find.byType(TextFormField),
        ),
        '  Example Product  ',
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('add-product-url-field')),
          matching: find.byType(TextFormField),
        ),
        '  https://example.com/products/1  ',
      );
      await tester.tap(find.byKey(const Key('add-product-submit-button')));

      expect(submittedName, 'Example Product');
      expect(submittedUrl, 'https://example.com/products/1');
    });

    testWidgets('submits valid values from the URL keyboard action', (
      WidgetTester tester,
    ) async {
      bool submitted = false;
      await tester.pumpWidget(
        buildWidget(onSubmit: (_, _) => submitted = true),
      );
      await tester.tap(find.byKey(const Key('add-product-section')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('add-product-name-field')),
          matching: find.byType(TextFormField),
        ),
        'Example Product',
      );
      final Finder urlField = find.descendant(
        of: find.byKey(const Key('add-product-url-field')),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(urlField, 'https://example.com/products/1');
      await tester.tap(urlField);
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, isTrue);
    });
  });

  group("AddProductSection's translations", () {
    testWidgets('displays the Portuguese source support explanation', (
      WidgetTester tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        if (LocaleSettings.currentLocale == AppLocale.pt) {
          await tester.tap(find.byKey(const Key('add-product-section')));
          await tester.pumpAndSettle();

          expect(
            find.text(
              'Os links podem ser guardados agora. A atualização automática só está disponível para sites suportados.',
            ),
            findsOneWidget,
          );
        }
      });
    });
  });
}
