// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/notifications/refresh_completed_alerts.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    bool enabled = false,
    bool isBusy = false,
    ValueChanged<bool>? onChanged,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: RefreshCompletedAlertsSection(
          enabled: enabled,
          isBusy: isBusy,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );

  group('RefreshCompletedAlertsSection contains widgets', () {
    testWidgets(
      'RefreshCompletedAlertsSection contains a switch with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('refresh-completed-alerts-switch')),
        );

        expect(switchTile.value, isTrue);
        expect(
          find.text(t.settings.notifications.refreshCompletedAlerts.title),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'RefreshCompletedAlertsSection disables the switch when isBusy = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true, isBusy: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('refresh-completed-alerts-switch')),
        );

        expect(switchTile.onChanged, isNull);
      },
    );

    testWidgets(
      'RefreshCompletedAlertsSection shows the enabled description when enabled = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true));

        expect(
          find.text(
            t.settings.notifications.refreshCompletedAlerts.enabledDescription,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'RefreshCompletedAlertsSection shows the disabled description when enabled = false',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: false));

        expect(
          find.text(
            t.settings.notifications.refreshCompletedAlerts.description,
          ),
          findsOneWidget,
        );
      },
    );
  });

  group("RefreshCompletedAlertsSection's elements behavior", () {
    testWidgets('RefreshCompletedAlertsSection calls onChanged when tapped', (
      tester,
    ) async {
      bool? changedValue;
      await tester.pumpWidget(
        buildWidget(onChanged: (bool value) => changedValue = value),
      );

      await tester.tap(
        find.byKey(const Key('refresh-completed-alerts-switch')),
      );

      expect(changedValue, isTrue);
    });

    testWidgets(
      'RefreshCompletedAlertsSection does not call onChanged when isBusy = true',
      (tester) async {
        bool called = false;
        await tester.pumpWidget(
          buildWidget(isBusy: true, onChanged: (_) => called = true),
        );

        await tester.tap(
          find.byKey(const Key('refresh-completed-alerts-switch')),
        );

        expect(called, isFalse);
      },
    );
  });

  group("RefreshCompletedAlertsSection's translations", () {
    testWidgets(
      'RefreshCompletedAlertsSection displays Portuguese translations',
      (tester) async {
        LocaleSettings.setLocale(AppLocale.pt);

        try {
          await tester.pumpWidget(buildWidget(enabled: true));

          expect(
            find.text(t.settings.notifications.refreshCompletedAlerts.title),
            findsOneWidget,
          );
          expect(
            find.text(
              t
                  .settings
                  .notifications
                  .refreshCompletedAlerts
                  .enabledDescription,
            ),
            findsOneWidget,
          );
        } finally {
          LocaleSettings.setLocale(AppLocale.en);
        }
      },
    );
  });
}
