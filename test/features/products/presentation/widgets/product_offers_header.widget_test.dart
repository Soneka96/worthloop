// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_offers_header.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({int offerCount = 3}) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: ProductOffersHeader(offerCount: offerCount)),
    ),
  );

  group('ProductOffersHeader contains widgets', () {
    testWidgets(
      'ProductOffersHeader contains the offer count without refresh controls',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.offers(count: 3)), findsOneWidget);
        expect(
          find.byKey(const Key('product-details-refresh-button')),
          findsNothing,
        );
      },
    );

    testWidgets('ProductOffersHeader contains the zero-offer count', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(offerCount: 0));

      expect(find.text(t.productDetails.offers(count: 0)), findsOneWidget);
    });
  });

  group("ProductOffersHeader's translations", () {
    testWidgets('ProductOffersHeader displays the Portuguese translation', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.offers(count: 3)), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
