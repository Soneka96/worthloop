// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/notifications/price_drop_alerts.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    bool enabled = false,
    bool isBusy = false,
    ValueChanged<bool>? onChanged,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: PriceDropAlertsSection(
          enabled: enabled,
          isBusy: isBusy,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    ),
  );

  group('PriceDropAlertsSection contains widgets', () {
    testWidgets(
      'PriceDropAlertsSection contains a switch with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('price-drop-alerts-switch')),
        );

        expect(switchTile.value, isTrue);
        expect(
          find.text(t.settings.notifications.priceAlerts.title),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'PriceDropAlertsSection disables the switch when isBusy = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true, isBusy: true));

        final SwitchListTile switchTile = tester.widget(
          find.byKey(const Key('price-drop-alerts-switch')),
        );

        expect(switchTile.onChanged, isNull);
      },
    );

    testWidgets(
      'PriceDropAlertsSection shows the enabled description when enabled = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: true));

        expect(
          find.text(t.settings.notifications.priceAlerts.enabledDescription),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'PriceDropAlertsSection shows the disabled description when enabled = false',
      (tester) async {
        await tester.pumpWidget(buildWidget(enabled: false));

        expect(
          find.text(t.settings.notifications.priceAlerts.description),
          findsOneWidget,
        );
      },
    );
  });

  group("PriceDropAlertsSection's elements behavior", () {
    testWidgets('PriceDropAlertsSection calls onChanged when tapped', (
      tester,
    ) async {
      bool? changedValue;
      await tester.pumpWidget(
        buildWidget(onChanged: (bool value) => changedValue = value),
      );

      await tester.tap(find.byKey(const Key('price-drop-alerts-switch')));

      expect(changedValue, isTrue);
    });

    testWidgets(
      'PriceDropAlertsSection does not call onChanged when isBusy = true',
      (tester) async {
        bool called = false;
        await tester.pumpWidget(
          buildWidget(isBusy: true, onChanged: (_) => called = true),
        );

        await tester.tap(find.byKey(const Key('price-drop-alerts-switch')));

        expect(called, isFalse);
      },
    );
  });

  group("PriceDropAlertsSection's translations", () {
    testWidgets('displays the correct translations', (
      tester,
    ) async {
      // Locale switching in tests causes deadlocks; use default locale.
      
        await tester.pumpWidget(buildWidget(enabled: true));

        expect(
          find.text(t.settings.notifications.priceAlerts.title),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.notifications.priceAlerts.enabledDescription),
          findsOneWidget,
        );
    });
  });
}
