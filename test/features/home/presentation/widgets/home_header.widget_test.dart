// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/home_header.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({VoidCallback? onOpenSettings}) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(body: HomeHeader(onOpenSettings: onOpenSettings ?? () {})),
    ),
  );

  group('HomeHeader contains widgets', () {
    testWidgets(
      'HomeHeader contains title, subtitle, and settings button with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.appTitle), findsOneWidget);
        expect(find.text(t.home.subtitle), findsOneWidget);
        expect(find.byKey(const Key('home-settings-button')), findsOneWidget);
      },
    );
  });

  group("HomeHeader's elements behavior", () {
    testWidgets(
      'HomeHeader calls onOpenSettings when settings button is tapped',
      (WidgetTester tester) async {
        bool settingsOpened = false;

        await tester.pumpWidget(
          buildWidget(onOpenSettings: () => settingsOpened = true),
        );

        await tester.tap(find.byKey(const Key('home-settings-button')));

        expect(settingsOpened, isA<bool>());
        expect(settingsOpened, isTrue);
      },
    );
  });

  group("HomeHeader's translations", () {
    testWidgets('HomeHeader displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      await LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.appTitle), findsOneWidget);
        expect(find.text(t.home.subtitle), findsOneWidget);
        expect(find.byTooltip(t.settings.title), findsOneWidget);
      } finally {
        await LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
