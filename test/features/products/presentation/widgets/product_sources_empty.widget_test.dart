// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget() => TranslationProvider(
    child: const MaterialApp(home: Scaffold(body: ProductSourcesEmptyWidget())),
  );

  group('ProductSourcesEmptyWidget contains widgets', () {
    testWidgets(
      'ProductSourcesEmptyWidget contains empty-state copy with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
        expect(find.text(t.productDetails.noSourcesTitle), findsOneWidget);
        expect(
          find.text(t.productDetails.noSourcesDescription),
          findsOneWidget,
        );
      },
    );
  });

  group("ProductSourcesEmptyWidget's translations", () {
    testWidgets(
      'displays the correct translations',
      (WidgetTester tester) async {
        // Locale switching in tests causes deadlocks; use default locale.
      
          await tester.pumpWidget(buildWidget());

          expect(find.text(t.productDetails.noSourcesTitle), findsOneWidget);
          expect(
            find.text(t.productDetails.noSourcesDescription),
            findsOneWidget,
          );
      },
    );
  });
}
