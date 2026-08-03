// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/shared/state/app.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../features/logs/fixtures/log_entry.fixture.dart';

void main() {
  group('AppReducer processes LogEntriesLoadedAction correctly', () {
    late AppState state;
    late AppState reducedState;

    setUp(() {
      state = AppState.initial();
      reducedState = appReducer(
        state,
        LogEntriesLoadedAction(
          entries: [buildLogEntry()],
          folderPath: 'C:/App/logs',
        ),
      );
    });

    test('appReducer delegates LogEntriesLoadedAction to the logs reducer', () {
      expect(state.logs.entries, isEmpty, reason: 'previous value');
      expect(reducedState.logs.entries, hasLength(1), reason: 'new value');
    });
  });
}
