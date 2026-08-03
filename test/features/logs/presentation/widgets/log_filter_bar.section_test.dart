// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/widgets/log_filter_bar.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({
    String searchQuery = '',
    ValueChanged<String>? onSearchChanged,
    LogLevel? selectedLevel,
    ValueChanged<LogLevel?>? onLevelSelected,
    VoidCallback? onExport,
    VoidCallback? onClear,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LogFilterBarSection(
          searchQuery: searchQuery,
          onSearchChanged: onSearchChanged ?? (_) {},
          selectedLevel: selectedLevel,
          onLevelSelected: onLevelSelected ?? (_) {},
          onExport: onExport ?? () {},
          onClear: onClear ?? () {},
        ),
      ),
    );
  }

  group('LogFilterBarSection contains widgets', () {
    testWidgets(
      'LogFilterBarSection contains a "logs-settings-search-field" TextField with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-search-field')),
          findsOneWidget,
        );
        expect(find.text('Search log messages'), findsOneWidget);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-all" chip with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-filter-all')),
          findsOneWidget,
        );
        expect(find.text('All'), findsOneWidget);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-info" chip with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-filter-info')),
          findsOneWidget,
        );
        expect(find.text('Info'), findsOneWidget);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-warning" chip with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-filter-warning')),
          findsOneWidget,
        );
        expect(find.text('Warning'), findsOneWidget);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-error" chip with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-filter-error')),
          findsOneWidget,
        );
        expect(find.text('Error'), findsOneWidget);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-export-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-export-button')),
          findsOneWidget,
        );
        expect(find.text('Export logs'), findsOneWidget);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-clear-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('logs-settings-clear-button')),
          findsOneWidget,
        );
        expect(find.text('Clear logs'), findsOneWidget);
      },
    );
  });

  group("LogFilterBarSection's elements behavior", () {
    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-all" chip with the correct behavior when selectedLevel = null',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ChoiceChip chip = tester.widget(
          find.byKey(const Key('logs-settings-filter-all')),
        );
        expect(chip.selected, isTrue);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-warning" chip with the correct behavior when selectedLevel = LogLevel.warning',
      (tester) async {
        await tester.pumpWidget(buildWidget(selectedLevel: LogLevel.warning));

        final ChoiceChip allChip = tester.widget(
          find.byKey(const Key('logs-settings-filter-all')),
        );
        final ChoiceChip warningChip = tester.widget(
          find.byKey(const Key('logs-settings-filter-warning')),
        );
        expect(allChip.selected, isFalse);
        expect(warningChip.selected, isTrue);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-search-field" TextField with the correct behavior when text is entered',
      (tester) async {
        String? typedQuery;

        await tester.pumpWidget(
          buildWidget(onSearchChanged: (value) => typedQuery = value),
        );
        await tester.enterText(
          find.byKey(const Key('logs-settings-search-field')),
          'timeout',
        );

        expect(typedQuery, 'timeout');
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-error" chip with the correct behavior when tapped',
      (tester) async {
        LogLevel? selected;

        await tester.pumpWidget(
          buildWidget(onLevelSelected: (level) => selected = level),
        );
        await tester.tap(find.byKey(const Key('logs-settings-filter-error')));

        expect(selected, LogLevel.error);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-filter-all" chip with the correct behavior when tapped',
      (tester) async {
        LogLevel? selected = LogLevel.error;

        await tester.pumpWidget(
          buildWidget(
            selectedLevel: LogLevel.error,
            onLevelSelected: (level) => selected = level,
          ),
        );
        await tester.tap(find.byKey(const Key('logs-settings-filter-all')));

        expect(selected, isNull);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-export-button" button with the correct behavior when tapped',
      (tester) async {
        bool exported = false;

        await tester.pumpWidget(buildWidget(onExport: () => exported = true));
        await tester.tap(find.byKey(const Key('logs-settings-export-button')));

        expect(exported, isTrue);
      },
    );

    testWidgets(
      'LogFilterBarSection contains a "logs-settings-clear-button" button with the correct behavior when tapped',
      (tester) async {
        bool cleared = false;

        await tester.pumpWidget(buildWidget(onClear: () => cleared = true));
        await tester.tap(find.byKey(const Key('logs-settings-clear-button')));

        expect(cleared, isTrue);
      },
    );
  });

  group("LogFilterBarSection's translations", () {
    testWidgets('LogFilterBarSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.logs.search.hint), findsOneWidget);
        expect(find.text(t.settings.logs.filterAll), findsOneWidget);
        expect(find.text(t.settings.logs.export), findsOneWidget);
        expect(find.text(t.settings.logs.clear), findsOneWidget);
      });
    });
  });
}
