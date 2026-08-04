// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/widgets/store_price.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../fixtures/store_price.fixture.dart';

void main() {
  Widget buildWidget(StorePrice storePrice) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: StorePriceWidget(storePrice: storePrice)),
    ),
  );

  group('StorePriceWidget contains widgets', () {
    testWidgets(
      'StorePriceWidget contains available offer data with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(buildStorePrice()));

        expect(find.text('Example Store'), findsOneWidget);
        expect(find.text('499.99 €'), findsOneWidget);
        expect(find.text('In stock'), findsOneWidget);
        expect(find.textContaining('Checked at'), findsOneWidget);
      },
    );

    testWidgets(
      'StorePriceWidget contains unavailable offer data with the correct parameters when isAvailable = false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(buildStorePrice(isAvailable: false)),
        );

        expect(find.text('Out of stock'), findsOneWidget);
      },
    );
  });

  group("StorePriceWidget's translations", () {
    testWidgets('StorePriceWidget displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget(buildStorePrice()));

        expect(find.text(t.productDetails.available), findsOneWidget);
        expect(
          find.textContaining(t.productDetails.checkedAt(time: '').trim()),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
