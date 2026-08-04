// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_best_price_card.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../fixtures/store_price.fixture.dart';

void main() {
  Widget buildWidget({StorePrice? bestPrice}) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: ProductBestPriceCard(bestPrice: bestPrice)),
    ),
  );

  group('ProductBestPriceCard contains widgets', () {
    testWidgets(
      'ProductBestPriceCard contains best price and store data with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(bestPrice: buildStorePrice()));

        expect(
          find.byKey(const Key('product-details-best-price')),
          findsOneWidget,
        );
        expect(find.text(t.productDetails.bestPrice), findsOneWidget);
        expect(find.text('499.99 €'), findsOneWidget);
        expect(find.text('Example Store'), findsOneWidget);
      },
    );

    testWidgets(
      'ProductBestPriceCard contains no-availability copy when bestPrice == null',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.bestPrice), findsOneWidget);
        expect(find.text(t.home.noAvailablePrice), findsOneWidget);
        expect(find.text('Example Store'), findsNothing);
      },
    );
  });

  group("ProductBestPriceCard's translations", () {
    testWidgets('ProductBestPriceCard displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget(bestPrice: buildStorePrice()));

        expect(find.text(t.productDetails.bestPrice), findsOneWidget);
        expect(find.text(t.home.noAvailablePrice), findsNothing);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
