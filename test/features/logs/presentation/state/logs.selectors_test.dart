// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/state/logs.selectors.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/log_entry.fixture.dart';

void main() {
  group('Method entriesSelector() returns a List<LogEntry> instance', () {
    test('entriesSelector() returns the logs entries', () {
      final AppState state = AppState.initial().copyWith(
        logs: LogsState.initial().copyWith(entries: [buildLogEntry()]),
      );

      expect(LogsSelectors.entriesSelector(state), hasLength(1));
    });
  });

  group('Method folderPathSelector() returns a String instance', () {
    test('folderPathSelector() returns the logs folderPath', () {
      final AppState state = AppState.initial().copyWith(
        logs: LogsState.initial().copyWith(folderPath: 'C:/App/logs'),
      );

      expect(LogsSelectors.folderPathSelector(state), 'C:/App/logs');
    });
  });
}
