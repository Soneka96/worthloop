// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/general/browser_refresh.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    bool enabled = false,
    bool isBusy = false,
    ValueChanged<bool>? onChanged,
    VoidCallback? onOpenBackgroundRestrictions,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: BrowserRefreshSection(
          enabled: enabled,
          isBusy: isBusy,
          onChanged: onChanged ?? (_) {},
          onOpenBackgroundRestrictions: onOpenBackgroundRestrictions ?? () {},
        ),
      ),
    ),
  );

  group('BrowserRefreshSection contains widgets', () {
    testWidgets(
      'BrowserRefreshSection contains a switch with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('browser-refresh-switch')),
        );

        expect(switchTile.value, isTrue);
        expect(
          find.text(t.settings.general.browserRefresh.status),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('browser-refresh-fix-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets('BrowserRefreshSection disables controls when isBusy = true', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(enabled: true, isBusy: true));

      final SwitchListTile switchTile = tester.widget(
        find.byKey(const Key('browser-refresh-switch')),
      );
      final OutlinedButton button = tester.widget(
        find.byKey(const Key('browser-refresh-fix-button')),
      );

      expect(switchTile.onChanged, isNull);
      expect(button.onPressed, isNull);
    });
  });

  group("BrowserRefreshSection's elements behavior", () {
    testWidgets(
      'BrowserRefreshSection calls onChanged when the switch changes',
      (tester) async {
        bool? changedValue;
        await tester.pumpWidget(
          buildWidget(onChanged: (bool value) => changedValue = value),
        );

        await tester.tap(find.byKey(const Key('browser-refresh-switch')));

        expect(changedValue, isTrue);
      },
    );

    testWidgets(
      'BrowserRefreshSection calls onOpenBackgroundRestrictions when tapped',
      (tester) async {
        bool called = false;
        await tester.pumpWidget(
          buildWidget(
            enabled: true,
            onOpenBackgroundRestrictions: () => called = true,
          ),
        );

        await tester.tap(find.byKey(const Key('browser-refresh-fix-button')));

        expect(called, isTrue);
      },
    );
  });

  group("BrowserRefreshSection's translations", () {
    testWidgets('BrowserRefreshSection displays Portuguese translations', (
      tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget(enabled: true));

        expect(
          find.text(t.settings.general.browserRefresh.title),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.general.browserRefresh.enabledDescription),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
