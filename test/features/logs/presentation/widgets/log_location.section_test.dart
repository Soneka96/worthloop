// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/widgets/log_location.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({
    String path = r'C:\App\logs',
    VoidCallback? onOpenFolder,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LogLocationSection(
          path: path,
          onOpenFolder: onOpenFolder ?? () {},
        ),
      ),
    );
  }

  group('LogLocationSection contains widgets', () {
    testWidgets(
      'LogLocationSection contains a "Location" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Location'), findsOneWidget);
      },
    );

    testWidgets('LogLocationSection displays the path', (tester) async {
      await tester.pumpWidget(buildWidget(path: r'C:\App\logs'));

      expect(find.text(r'C:\App\logs'), findsOneWidget);
    });

    testWidgets(
      'LogLocationSection contains a "logs-settings-open-folder-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-open-folder-button')),
          findsOneWidget,
        );

        final IconButton button = tester.widget(
          find.byKey(const Key('logs-settings-open-folder-button')),
        );
        expect(button.tooltip, 'Open logs folder');
      },
    );
  });

  group("LogLocationSection's elements behavior", () {
    testWidgets(
      'LogLocationSection contains a "logs-settings-open-folder-button" button with the correct behavior when tapped',
      (tester) async {
        bool opened = false;

        await tester.pumpWidget(buildWidget(onOpenFolder: () => opened = true));
        await tester.tap(
          find.byKey(const Key('logs-settings-open-folder-button')),
        );

        expect(opened, isTrue);
      },
    );
  });

  group("LogLocationSection's translations", () {
    testWidgets('LogLocationSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.logs.location.title), findsOneWidget);
      });
    });
  });
}
