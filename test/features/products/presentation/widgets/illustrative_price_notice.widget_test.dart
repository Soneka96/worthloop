// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/illustrative_price_notice.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget() => TranslationProvider(
    child: const MaterialApp(home: Scaffold(body: IllustrativePriceNotice())),
  );

  group('IllustrativePriceNotice contains widgets', () {
    testWidgets(
      'IllustrativePriceNotice contains demo-data copy with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('illustrative-price-notice')),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        expect(find.text(t.home.sampleDataNotice), findsOneWidget);
      },
    );
  });

  group("IllustrativePriceNotice's translations", () {
    testWidgets('IllustrativePriceNotice displays the Portuguese translation', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.home.sampleDataNotice), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
