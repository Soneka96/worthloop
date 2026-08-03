// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/general/default_save_location.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({
    String? path,
    String? pendingPath,
    VoidCallback? onRestartNow,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: DefaultSaveLocationSection(
          path: path,
          pendingPath: pendingPath,
          onPathSelected: (_) {},
          onRestartNow: onRestartNow ?? () {},
        ),
      ),
    );
  }

  group('DefaultSaveLocationSection contains widgets', () {
    testWidgets(
      'DefaultSaveLocationSection contains a "Default save location" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Default save location'), findsOneWidget);
      },
    );

    testWidgets(
      'DefaultSaveLocationSection displays "No folder selected" when path is null',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('No folder selected'), findsOneWidget);
      },
    );

    testWidgets(
      'DefaultSaveLocationSection displays the path when one is set',
      (tester) async {
        await tester.pumpWidget(buildWidget(path: r'C:\App Projects'));

        expect(find.text(r'C:\App Projects'), findsOneWidget);
        expect(find.text('No folder selected'), findsNothing);
      },
    );

    testWidgets(
      'DefaultSaveLocationSection contains a "general-settings-browse-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('general-settings-browse-button')),
          findsOneWidget,
        );
        expect(find.text('Browse'), findsOneWidget);
      },
    );

    testWidgets(
      'DefaultSaveLocationSection displays the pending-move caption when pendingPath is set',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(pendingPath: r'D:\New App Folder'),
        );

        expect(
          find.text(
            r'The app will move your data to D:\New App Folder on next restart.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'DefaultSaveLocationSection does not display the pending-move caption when pendingPath is null',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.textContaining('on next restart'), findsNothing);
      },
    );

    testWidgets(
      'DefaultSaveLocationSection contains a "general-settings-restart-now-button" button with the correct parameters when pendingPath is set',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(pendingPath: r'D:\New App Folder'),
        );

        expect(
          find.byKey(const Key('general-settings-restart-now-button')),
          findsOneWidget,
        );
        expect(find.text('Restart now'), findsOneWidget);
      },
    );

    testWidgets(
      'DefaultSaveLocationSection does not contain a "general-settings-restart-now-button" button when pendingPath is null',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('general-settings-restart-now-button')),
          findsNothing,
        );
      },
    );
  });

  group("DefaultSaveLocationSection's elements behavior", () {
    testWidgets(
      'DefaultSaveLocationSection contains a "general-settings-restart-now-button" button with the correct behavior when tapped',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            pendingPath: r'D:\New App Folder',
            onRestartNow: () => print('onRestartNow called'),
          ),
        );

        await expectLater(
          () => tester.tap(
            find.byKey(const Key('general-settings-restart-now-button')),
          ),
          prints('onRestartNow called\n'),
        );
      },
    );
  });

  group("DefaultSaveLocationSection's translations", () {
    testWidgets(
      'DefaultSaveLocationSection displays the correct translations',
      (tester) async {
        await TestHelper.pumpEachLocale(
          tester,
          () => buildWidget(pendingPath: r'D:\New App Folder'),
          () async {
            expect(
              find.text(t.settings.general.defaultSaveLocation.title),
              findsOneWidget,
            );
            expect(
              find.text(t.settings.general.defaultSaveLocation.browse),
              findsOneWidget,
            );
            expect(
              find.text(
                t.settings.general.defaultSaveLocation.pendingMove(
                  path: r'D:\New App Folder',
                ),
              ),
              findsOneWidget,
            );
            expect(
              find.text(t.settings.general.defaultSaveLocation.restartNow),
              findsOneWidget,
            );
          },
        );
      },
    );

    testWidgets(
      'DefaultSaveLocationSection displays the correct translation for noFolderSelected',
      (tester) async {
        await TestHelper.pumpEachLocale(tester, buildWidget, () async {
          expect(
            find.text(t.settings.general.defaultSaveLocation.noFolderSelected),
            findsOneWidget,
          );
        });
      },
    );
  });
}
