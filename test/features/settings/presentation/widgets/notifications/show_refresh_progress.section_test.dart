// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/notifications/show_refresh_progress.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    bool enabled = false,
    bool isBusy = false,
    ValueChanged<bool>? onChanged,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: ShowRefreshProgressSection(
          enabled: enabled,
          isBusy: isBusy,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );

  group('ShowRefreshProgressSection contains widgets', () {
    testWidgets(
      'ShowRefreshProgressSection contains a switch with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('show-refresh-progress-switch')),
        );

        expect(switchTile.value, isTrue);
        expect(
          find.text(t.settings.notifications.showRefreshProgress.title),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.notifications.showRefreshProgress.description),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ShowRefreshProgressSection disables the switch when isBusy = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true, isBusy: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('show-refresh-progress-switch')),
        );

        expect(switchTile.onChanged, isNull);
      },
    );
  });

  group("ShowRefreshProgressSection's elements behavior", () {
    testWidgets('ShowRefreshProgressSection calls onChanged when tapped', (
      tester,
    ) async {
      bool? changedValue;
      await tester.pumpWidget(
        buildWidget(onChanged: (bool value) => changedValue = value),
      );

      await tester.tap(find.byKey(const Key('show-refresh-progress-switch')));

      expect(changedValue, isTrue);
    });

    testWidgets(
      'ShowRefreshProgressSection does not call onChanged when isBusy = true',
      (tester) async {
        bool called = false;
        await tester.pumpWidget(
          buildWidget(isBusy: true, onChanged: (_) => called = true),
        );

        await tester.tap(find.byKey(const Key('show-refresh-progress-switch')));

        expect(called, isFalse);
      },
    );
  });

  group("ShowRefreshProgressSection's translations", () {
    testWidgets('ShowRefreshProgressSection displays Portuguese translations', (
      tester,
    ) async {
      await LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget(enabled: true));

        expect(
          find.text(t.settings.notifications.showRefreshProgress.title),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.notifications.showRefreshProgress.description),
          findsOneWidget,
        );
      } finally {
        await LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
