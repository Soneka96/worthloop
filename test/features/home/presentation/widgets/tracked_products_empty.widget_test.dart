// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_empty.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  group('TrackedProductsEmptyWidget contains widgets', () {
    testWidgets(
      'TrackedProductsEmptyWidget contains empty-state copy with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: TrackedProductsEmptyWidget())),
        );

        expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
        expect(find.text('No tracked products'), findsOneWidget);
        expect(
          find.text(
            'Products you track will appear here with their best available offer.',
          ),
          findsOneWidget,
        );
      },
    );
  });

  group("TrackedProductsEmptyWidget's translations", () {
    testWidgets(
      'TrackedProductsEmptyWidget displays the Portuguese translations',
      (WidgetTester tester) async {
        LocaleSettings.setLocale(AppLocale.pt);

        try {
          await tester.pumpWidget(
            TranslationProvider(
              child: const MaterialApp(
                home: Scaffold(body: TrackedProductsEmptyWidget()),
              ),
            ),
          );

          expect(find.text(t.home.emptyTitle), findsOneWidget);
          expect(find.text(t.home.emptyDescription), findsOneWidget);
        } finally {
          LocaleSettings.setLocale(AppLocale.en);
        }
      },
    );
  });
}
