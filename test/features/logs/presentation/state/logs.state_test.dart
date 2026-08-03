// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import '../../fixtures/log_entry.fixture.dart';

void main() {
  group('LogsState — initial', () {
    test('LogsState.initial has no entries and no folderPath', () {
      final LogsState state = LogsState.initial();

      expect(state.entries, isEmpty);
      expect(state.folderPath, isNull);
    });
  });

  group('LogsState — copyWith', () {
    test('LogsState copyWith replaces entries when passed', () {
      final LogsState state = LogsState.initial();
      final List<LogEntry> entries = [buildLogEntry()];

      final LogsState next = state.copyWith(entries: entries);

      expect(next.entries, entries);
    });

    test('LogsState copyWith replaces folderPath when passed', () {
      final LogsState state = LogsState.initial();

      final LogsState next = state.copyWith(folderPath: 'C:/App/logs');

      expect(next.folderPath, 'C:/App/logs');
    });

    test('LogsState copyWith preserves entries when omitted', () {
      final LogsState state = LogsState.initial().copyWith(
        entries: [buildLogEntry()],
      );

      final LogsState next = state.copyWith();

      expect(next.entries, state.entries);
    });

    test('LogsState copyWith preserves folderPath when omitted', () {
      final LogsState state = LogsState.initial().copyWith(
        folderPath: 'C:/App/logs',
      );

      final LogsState next = state.copyWith();

      expect(next.folderPath, state.folderPath);
    });
  });
}
