// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/presentation/screens/logs_settings.screen.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/viewmodels/logs_screen.viewmodel.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_entry_tile.widget.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_filter_bar.section.dart';
import 'package:worth_loop/features/logs/presentation/widgets/log_location.section.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockLogsScreenViewModel extends Mock implements LogsScreenViewModel {}

void main() {
  late MockLogsScreenViewModel mockViewModel;
  late Store<AppState> store;
  late List<dynamic> dispatchedActions;

  final List<LogEntry> entries = [
    LogEntry(
      timestamp: DateTime(2026, 7, 10, 14, 2, 11),
      level: LogLevel.info,
      message: 'Run started — 42 files queued',
    ),
    LogEntry(
      timestamp: DateTime(2026, 7, 10, 14, 2, 14),
      level: LogLevel.warning,
      message: 'Retrying file 07 after timeout',
    ),
    LogEntry(
      timestamp: DateTime(2026, 7, 10, 14, 2, 19),
      level: LogLevel.error,
      message: 'File 12 failed — 500 response',
    ),
    LogEntry(
      timestamp: DateTime(2026, 7, 10, 14, 3, 2),
      level: LogLevel.info,
      message: 'Run complete — 41/42 sent',
    ),
  ];

  setUp(() {
    mockViewModel = MockLogsScreenViewModel();

    when(() => mockViewModel.entries).thenReturn(entries);
    when(() => mockViewModel.folderPath).thenReturn(r'C:\App\logs');
    when(() => mockViewModel.onOpenFolder).thenReturn(() {});
    when(() => mockViewModel.onExport).thenReturn(() {});
    when(() => mockViewModel.onClear).thenReturn(() {});

    sl.registerFactoryParam<LogsScreenViewModel, Store<AppState>, void>(
      (store, _) => mockViewModel,
    );

    dispatchedActions = [];
    store = Store<AppState>((AppState state, dynamic action) {
      dispatchedActions.add(action);
      return state;
    }, initialState: AppState.initial());
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: LogsSettingsScreen()),
        ),
      ),
    );
  }

  group('LogsSettingsScreen contains widgets', () {
    testWidgets(
      'LogsSettingsScreen contains a "Logs" headline Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Logs'), findsOneWidget);
      },
    );

    testWidgets(
      'LogsSettingsScreen contains LogLocationSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(LogLocationSection), findsOneWidget);
      },
    );

    testWidgets(
      'LogsSettingsScreen contains LogFilterBarSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(LogFilterBarSection), findsOneWidget);
      },
    );

    testWidgets(
      'LogsSettingsScreen contains LogEntryTile widgets with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(LogEntryTile), findsNWidgets(4));
      },
    );
  });

  group("LogsSettingsScreen's elements behavior", () {
    testWidgets(
      "LogsSettingsScreen's StoreConnector dispatches LoadLogEntriesAction on init",
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(dispatchedActions, contains(const LoadLogEntriesAction()));
      },
    );

    testWidgets(
      'LogsSettingsScreen contains a "logs-settings-search-field" TextField with the correct behavior when text is entered',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.enterText(
          find.byKey(const Key('logs-settings-search-field')),
          'timeout',
        );
        await tester.pump();

        expect(find.byType(LogEntryTile), findsOneWidget);
        expect(find.text('Retrying file 07 after timeout'), findsOneWidget);
      },
    );

    testWidgets(
      'LogsSettingsScreen contains a "logs-settings-filter-error" chip with the correct behavior when tapped',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('logs-settings-filter-error')));
        await tester.pump();

        expect(find.byType(LogEntryTile), findsOneWidget);
        expect(find.text('File 12 failed — 500 response'), findsOneWidget);
      },
    );

    testWidgets(
      'LogsSettingsScreen displays the empty-state message when no entry matches the filters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.enterText(
          find.byKey(const Key('logs-settings-search-field')),
          'nothing matches this',
        );
        await tester.pump();

        expect(find.byType(LogEntryTile), findsNothing);
        expect(find.text('No log entries match your filters.'), findsOneWidget);
      },
    );
  });

  group(
    'LogsSettingsScreen meets the accessibility recommended guidelines',
    () {
      testWidgets('LogsSettingsScreen meets WCAG contrast guidelines', (
        tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(buildWidget());

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });

      testWidgets('LogsSettingsScreen all tap targets meet minimum 48dp size', (
        tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(buildWidget());

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });

      testWidgets(
        'LogsSettingsScreen all interactive elements have semantic labels',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'LogsSettingsScreen renders without overflow at 150% text scale',
        (tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: buildWidget(),
            ),
          );

          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'LogsSettingsScreen renders without overflow at 200% text scale',
        (tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: buildWidget(),
            ),
          );

          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'LogsSettingsScreen Tab key traverses all focusable elements',
        (tester) async {
          await tester.pumpWidget(buildWidget());

          final int focusableCount = tester
              .widgetList(find.byWidgetPredicate((widget) => widget is Focus))
              .length;
          for (int i = 0; i < focusableCount; i++) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
          }

          expect(FocusManager.instance.primaryFocus, isNotNull);
        },
      );
    },
  );
}
