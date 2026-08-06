// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/best_price_stamp.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget() => TranslationProvider(
    child: const MaterialApp(home: Scaffold(body: BestPriceStamp())),
  );

  group('BestPriceStamp contains widgets', () {
    testWidgets(
      'BestPriceStamp contains the best-price label with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.bestPrice), findsOneWidget);
      },
    );
  });

  group("BestPriceStamp's translations", () {
    testWidgets('BestPriceStamp displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.bestPrice), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
