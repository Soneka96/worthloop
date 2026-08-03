// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// Persisted app log entries — one row per captured `logger` package call.
@DataClassName('LogEntryRow')
class LogEntryTable extends Table {
  /// Primary key, auto-incremented by drift.
  IntColumn get id => integer().autoIncrement()();

  /// When this entry was logged.
  DateTimeColumn get timestamp => dateTime()();

  /// This entry's severity, stored as [LogLevel]'s enum index.
  IntColumn get level => intEnum<LogLevel>()();

  /// The log message text.
  TextColumn get message => text()();

  /// The `logger` package printer's fully decorated output (stack frame,
  /// box-drawing) for this entry — `null` if none was captured. Used for
  /// exporting to the dev team; never shown on the Logs screen itself.
  TextColumn get details => text().nullable()();
}
