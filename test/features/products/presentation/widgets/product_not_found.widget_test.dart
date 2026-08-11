// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_not_found.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget() => TranslationProvider(
    child: const MaterialApp(home: Scaffold(body: ProductNotFoundWidget())),
  );

  group('ProductNotFoundWidget contains widgets', () {
    testWidgets(
      'ProductNotFoundWidget contains not-found copy with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.productNotFound), findsOneWidget);
        expect(
          find.text(t.productDetails.productNotFoundDescription),
          findsOneWidget,
        );
      },
    );
  });

  group("ProductNotFoundWidget's translations", () {
    testWidgets('ProductNotFoundWidget displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      await LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.productNotFound), findsOneWidget);
        expect(
          find.text(t.productDetails.productNotFoundDescription),
          findsOneWidget,
        );
      } finally {
        await LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
