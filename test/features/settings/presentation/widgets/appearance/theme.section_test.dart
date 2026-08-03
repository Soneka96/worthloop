// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/appearance/theme.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/theme_card.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import '../../../../../support/test_helper.dart';

void main() {
  late AppTheme appTheme;

  setUp(() {
    appTheme = AppTheme();
    sl.registerLazySingleton<AppTheme>(() => appTheme);
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return const MaterialApp(home: Scaffold(body: ThemeSection()));
  }

  group('ThemeSection contains widgets', () {
    testWidgets(
      'ThemeSection contains a "Theme" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Theme'), findsOneWidget);
      },
    );

    testWidgets(
      'ThemeSection contains a ThemeCard for Brightness.light with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ThemeCard card = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ThemeCard && widget.brightness == Brightness.light,
          ),
        );

        expect(card.selectedThemeId, appTheme.lightThemeId);
        expect(card.isActive, false);
      },
    );

    testWidgets(
      'ThemeSection contains a ThemeCard for Brightness.dark with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ThemeCard card = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ThemeCard && widget.brightness == Brightness.dark,
          ),
        );

        expect(card.selectedThemeId, appTheme.darkThemeId);
        expect(card.isActive, true);
      },
    );
  });

  group("ThemeSection's translations", () {
    testWidgets('ThemeSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.appearance.theme), findsOneWidget);
      });
    });
  });
}
