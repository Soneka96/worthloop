// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_offers.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/store_price.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../fixtures/store_price.fixture.dart';

void main() {
  Widget buildWidget({
    List<StorePrice> availablePrices = const [],
    List<StorePrice> unavailablePrices = const [],
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: ProductOffersWidget(
          availablePrices: availablePrices,
          unavailablePrices: unavailablePrices,
        ),
      ),
    ),
  );

  group('ProductOffersWidget contains widgets', () {
    testWidgets(
      'ProductOffersWidget displays available and unavailable sections',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            availablePrices: [buildStorePrice(storeName: 'Available Store')],
            unavailablePrices: [
              buildStorePrice(
                storeName: 'Unavailable Store',
                isAvailable: false,
              ),
            ],
          ),
        );

        expect(find.text(t.productDetails.availableOffers), findsOneWidget);
        expect(find.text('Available Store'), findsOneWidget);
        expect(find.text(t.productDetails.unavailableOffers), findsOneWidget);
        expect(
          find.text(t.productDetails.unavailableDescription),
          findsOneWidget,
        );
        expect(find.text('Unavailable Store'), findsOneWidget);
        expect(find.byType(StorePriceWidget), findsNWidgets(2));
      },
    );

    testWidgets(
      'ProductOffersWidget displays no-offers copy when both lists are empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.noOffers), findsOneWidget);
        expect(find.byType(StorePriceWidget), findsNothing);
      },
    );

    testWidgets(
      'ProductOffersWidget omits unavailable section when no unavailable offers exist',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(availablePrices: [buildStorePrice()]),
        );

        expect(find.text(t.productDetails.availableOffers), findsOneWidget);
        expect(find.text(t.productDetails.unavailableOffers), findsNothing);
        expect(find.byType(StorePriceWidget), findsOneWidget);
      },
    );

    testWidgets(
      'ProductOffersWidget renders unavailable section when no available offers exist',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(unavailablePrices: [buildStorePrice(isAvailable: false)]),
        );

        expect(find.text(t.productDetails.availableOffers), findsNothing);
        expect(find.text(t.productDetails.unavailableOffers), findsOneWidget);
        expect(
          find.text(t.productDetails.unavailableDescription),
          findsOneWidget,
        );
        expect(find.byType(StorePriceWidget), findsOneWidget);
      },
    );
  });

  testWidgets('ProductOffersWidget uses a lazy offer list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildWidget(availablePrices: [buildStorePrice()]));

    final ListView listView = tester.widget(find.byType(ListView));

    expect(listView.childrenDelegate, isA<SliverChildBuilderDelegate>());
  });
}
