// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import 'package:worth_loop/features/logs/presentation/state/viewmodels/logs_screen.viewmodel.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../fixtures/log_entry.fixture.dart';

void main() {
  late List<dynamic> dispatchedActions;
  late Store<AppState> store;

  setUp(() {
    dispatchedActions = [];

    store = Store<AppState>(
      (AppState state, dynamic action) {
        dispatchedActions.add(action);
        return state;
      },
      initialState: AppState.initial().copyWith(
        logs: LogsState.initial().copyWith(
          entries: [buildLogEntry()],
          folderPath: 'C:/App/logs',
        ),
      ),
    );
  });

  group('LogsScreenViewModel constructor initializes all parameters correctly', () {
    test('Method fromStore() constructs LogsScreenViewModel correctly', () {
      final LogsScreenViewModel viewmodel = LogsScreenViewModel.fromStore(
        store,
      );

      expect(viewmodel.entries, hasLength(1));
      expect(viewmodel.folderPath, 'C:/App/logs');
    });

    test(
      'Method fromStore() constructs LogsScreenViewModel with folderPath = "" when not yet loaded',
      () {
        final Store<AppState> emptyStore = Store<AppState>(
          (AppState state, dynamic action) => state,
          initialState: AppState.initial(),
        );

        final LogsScreenViewModel viewmodel = LogsScreenViewModel.fromStore(
          emptyStore,
        );

        expect(viewmodel.folderPath, '');
      },
    );

    test('Method onOpenFolder dispatches OpenLogsFolderAction when called', () {
      final LogsScreenViewModel viewmodel = LogsScreenViewModel.fromStore(
        store,
      );

      viewmodel.onOpenFolder();

      expect(dispatchedActions, [isA<OpenLogsFolderAction>()]);
    });

    test('Method onExport dispatches ExportLogEntriesAction when called', () {
      final LogsScreenViewModel viewmodel = LogsScreenViewModel.fromStore(
        store,
      );

      viewmodel.onExport();

      expect(dispatchedActions, [isA<ExportLogEntriesAction>()]);
    });

    test(
      'Method onClear dispatches ClearLogEntriesAction with cutoff close to DateTime.now() when called',
      () {
        final LogsScreenViewModel viewmodel = LogsScreenViewModel.fromStore(
          store,
        );

        final DateTime before = DateTime.now();
        viewmodel.onClear();
        final DateTime after = DateTime.now();

        expect(dispatchedActions, hasLength(1));
        final ClearLogEntriesAction action =
            dispatchedActions.single as ClearLogEntriesAction;
        expect(
          action.cutoff.isAfter(before.subtract(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          action.cutoff.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
      },
    );
  });
}
