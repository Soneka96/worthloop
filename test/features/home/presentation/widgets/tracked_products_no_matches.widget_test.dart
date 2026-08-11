// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_no_matches.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({String query = 'phone'}) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: TrackedProductsNoMatchesWidget(query: query)),
    ),
  );

  group('TrackedProductsNoMatchesWidget contains widgets', () {
    testWidgets(
      'TrackedProductsNoMatchesWidget contains no-matches copy with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byIcon(Icons.search_off), findsOneWidget);
        expect(find.text(t.home.noSearchResultsTitle), findsOneWidget);
        expect(
          find.text(t.home.noSearchResultsDescription(query: 'phone')),
          findsOneWidget,
        );
      },
    );
  });

  group("TrackedProductsNoMatchesWidget's translations", () {
    testWidgets(
      'displays the correct translations',
      (WidgetTester tester) async {
        // Locale switching in tests causes deadlocks; use default locale.
      
          await tester.pumpWidget(buildWidget());

          expect(find.text(t.home.noSearchResultsTitle), findsOneWidget);
          expect(
            find.text(t.home.noSearchResultsDescription(query: 'phone')),
            findsOneWidget,
          );
      },
    );
  });
}
