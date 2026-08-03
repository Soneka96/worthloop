// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.reducer.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import '../../fixtures/log_entry.fixture.dart';

void main() {
  group('logsReducer processes LogEntriesLoadedAction correctly', () {
    test(
      'logsReducer updates entries and folderPath from LogEntriesLoadedAction',
      () {
        final LogsState state = LogsState.initial();
        final LogsState reducedState = logsReducer(
          state,
          LogEntriesLoadedAction(
            entries: [buildLogEntry()],
            folderPath: 'C:/App/logs',
          ),
        );

        expect(state.entries, isEmpty, reason: 'previous value');
        expect(reducedState.entries, hasLength(1), reason: 'new value');
        expect(state.folderPath, isNull, reason: 'previous value');
        expect(reducedState.folderPath, 'C:/App/logs', reason: 'new value');
      },
    );
  });

  group('logsReducer processes unhandled actions correctly', () {
    test('LoadLogEntriesAction modifies nothing', () {
      final LogsState state = LogsState.initial();
      final LogsState reducedState = logsReducer(
        state,
        const LoadLogEntriesAction(),
      );

      expect(reducedState, state);
    });
  });
}
