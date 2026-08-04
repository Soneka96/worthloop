// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_offers_header.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    int offerCount = 3,
    bool isRefreshing = false,
    VoidCallback? onRefresh,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: ProductOffersHeader(
          offerCount: offerCount,
          isRefreshing: isRefreshing,
          onRefresh: onRefresh ?? () {},
        ),
      ),
    ),
  );

  group('ProductOffersHeader contains widgets', () {
    testWidgets(
      'ProductOffersHeader contains offer count and refresh button with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.offers(count: 3)), findsOneWidget);
        expect(
          find.byKey(const Key('product-details-refresh-button')),
          findsOneWidget,
        );
        expect(find.text(t.productDetails.refresh), findsOneWidget);
      },
    );

    testWidgets(
      'ProductOffersHeader contains a disabled refresh button when isRefreshing = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isRefreshing: true));

        final FilledButton button = tester.widget(
          find.byKey(const Key('product-details-refresh-button')),
        );

        expect(button.onPressed, isNull);
        expect(find.text(t.productDetails.refreshing), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'ProductOffersHeader contains the zero-offer count when offerCount = 0',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(offerCount: 0));

        expect(find.text(t.productDetails.offers(count: 0)), findsOneWidget);
      },
    );
  });

  group("ProductOffersHeader's elements behavior", () {
    testWidgets(
      'ProductOffersHeader calls onRefresh when isRefreshing = false',
      (WidgetTester tester) async {
        bool wasRefreshed = false;

        await tester.pumpWidget(
          buildWidget(onRefresh: () => wasRefreshed = true),
        );

        await tester.tap(
          find.byKey(const Key('product-details-refresh-button')),
        );

        expect(wasRefreshed, isA<bool>());
        expect(wasRefreshed, isTrue);
      },
    );

    testWidgets(
      'ProductOffersHeader does not call onRefresh when isRefreshing = true',
      (WidgetTester tester) async {
        bool wasRefreshed = false;

        await tester.pumpWidget(
          buildWidget(isRefreshing: true, onRefresh: () => wasRefreshed = true),
        );

        await tester.tap(
          find.byKey(const Key('product-details-refresh-button')),
        );

        expect(wasRefreshed, isA<bool>());
        expect(wasRefreshed, isFalse);
      },
    );
  });

  group("ProductOffersHeader's translations", () {
    testWidgets('ProductOffersHeader displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.offers(count: 3)), findsOneWidget);
        expect(find.text(t.productDetails.refresh), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
