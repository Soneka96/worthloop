// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/general/updates.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({VoidCallback? onCheckForUpdates}) {
    return MaterialApp(
      home: Scaffold(
        body: UpdatesSection(
          version: '0.1.0',
          onCheckForUpdates: onCheckForUpdates ?? () {},
        ),
      ),
    );
  }

  group('UpdatesSection contains widgets', () {
    testWidgets(
      'UpdatesSection contains an "Updates" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Updates'), findsOneWidget);
      },
    );

    testWidgets(
      'UpdatesSection contains a Version Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Version 0.1.0'), findsOneWidget);
      },
    );

    testWidgets(
      'UpdatesSection contains a "general-settings-check-for-updates-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('general-settings-check-for-updates-button')),
          findsOneWidget,
        );
        expect(find.text('Check for updates'), findsOneWidget);
      },
    );

    testWidgets(
      'UpdatesSection contains an update-check description Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.text(
            'The app checks for updates on launch. Downloads open in your '
            'browser — nothing installs automatically.',
          ),
          findsOneWidget,
        );
      },
    );
  });

  group("UpdatesSection's elements behavior", () {
    testWidgets(
      'UpdatesSection contains a "general-settings-check-for-updates-button" button with the correct behavior when tapped',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            onCheckForUpdates: () => print('onCheckForUpdates called'),
          ),
        );

        await expectLater(
          () => tester.tap(
            find.byKey(const Key('general-settings-check-for-updates-button')),
          ),
          prints('onCheckForUpdates called\n'),
        );
      },
    );
  });

  group("UpdatesSection's translations", () {
    testWidgets('UpdatesSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.general.updates.title), findsOneWidget);
        expect(
          find.text(t.settings.general.updates.version(version: '0.1.0')),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.general.updates.checkForUpdates),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.general.updates.description),
          findsOneWidget,
        );
      });
    });
  });
}
