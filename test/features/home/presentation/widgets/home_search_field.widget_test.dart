// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/home_search_field.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({ValueChanged<String>? onChanged}) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: HomeSearchField(onChanged: onChanged ?? (_) {})),
    ),
  );

  group('HomeSearchField contains widgets', () {
    testWidgets(
      'HomeSearchField contains a "home-search-field" TextField with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byKey(const Key('home-search-field')), findsOneWidget);
        expect(find.text(t.home.searchHint), findsOneWidget);
      },
    );

    testWidgets(
      'HomeSearchField does not contain a "home-search-clear-button" IconButton when the field is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byKey(const Key('home-search-clear-button')), findsNothing);
      },
    );

    testWidgets(
      'HomeSearchField contains a "home-search-clear-button" IconButton with the correct parameters when the field is non-empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'phone',
        );
        await tester.pump();

        expect(
          find.byKey(const Key('home-search-clear-button')),
          findsOneWidget,
        );
        expect(find.byTooltip(t.home.searchClearTooltip), findsOneWidget);
      },
    );
  });

  group("HomeSearchField's elements behavior", () {
    testWidgets(
      'HomeSearchField contains a "home-search-field" TextField with the correct behavior',
      (WidgetTester tester) async {
        String? typed;
        await tester.pumpWidget(
          buildWidget(onChanged: (value) => typed = value),
        );

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'phone',
        );

        expect(typed, isA<String>());
        expect(typed, 'phone');
      },
    );

    testWidgets(
      'HomeSearchField contains a "home-search-clear-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        String? typed;
        await tester.pumpWidget(
          buildWidget(onChanged: (value) => typed = value),
        );

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'phone',
        );
        await tester.pump();
        await tester.tap(find.byKey(const Key('home-search-clear-button')));
        await tester.pump();

        expect(typed, isA<String>());
        expect(typed, '');
        expect(find.text('phone'), findsNothing);
        expect(find.byKey(const Key('home-search-clear-button')), findsNothing);
      },
    );
  });

  group("HomeSearchField's translations", () {
    testWidgets('displays the correct translations', (
      WidgetTester tester,
    ) async {
      // Locale switching in tests causes deadlocks; use default locale.
      
        await tester.pumpWidget(buildWidget());
        expect(find.text(t.home.searchHint), findsOneWidget);

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'phone',
        );
        await tester.pump();

        expect(find.byTooltip(t.home.searchClearTooltip), findsOneWidget);
    });
  });
}
