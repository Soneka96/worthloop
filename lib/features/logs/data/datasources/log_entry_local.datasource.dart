// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:drift/drift.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/models/log_entry.model.dart';
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Local I/O for the logs feature — drift persistence and the log export
/// dialog. Also serves as a [LogOutput]: every `logger` package call in the
/// app flows into [output], which inserts it directly, bypassing Redux.
class LogEntryLocalDatasource extends LogOutput {
  /// The app's drift database connection.
  final AppDatabase _db;

  /// Overridable in tests — the real implementation is [DateTime.now].
  final DateTime Function() _now;

  LogEntryLocalDatasource(this._db, {DateTime Function() now = DateTime.now})
    : _now = now;

  @override
  void output(OutputEvent event) {
    unawaited(_insert(event).catchError((_) {}));
  }

  // message is the raw string passed to the log call, shown on the Logs
  // screen; details is the printer's fully decorated (box-drawing, ANSI,
  // stack-frame) output, kept only for exporting to the dev team.
  Future<void> _insert(OutputEvent event) async {
    try {
      await _db
          .into(_db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: event.origin.time,
              level: _mapLevel(event.level),
              message: event.origin.message.toString(),
              details: Value(event.lines.join('\n')),
            ),
          );
    } on SqliteException {
      // Nothing to log the failure to — this is the log writer itself.
    }
  }

  /// Maps `logger` package [Level]s onto this app's own [LogLevel] severities.
  static LogLevel _mapLevel(Level level) => switch (level) {
    Level.trace || Level.debug || Level.info => LogLevel.info,
    Level.warning => LogLevel.warning,
    Level.error || Level.fatal => LogLevel.error,
    _ => LogLevel.none,
  };

  /// Formats [time] as `yyyy-MM-dd_HH-mm-ss` for an export filename — never
  /// `:`, which Windows rejects in file names.
  static String _filenameTimestamp(DateTime time) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${time.year}-${pad(time.month)}-${pad(time.day)}'
        '_${pad(time.hour)}-${pad(time.minute)}-${pad(time.second)}';
  }

  /// Deletes entries older than [LogsConstants.logRetentionWindow], then
  /// returns up to [limit] of the rest, newest first.
  /// Returns [DatabaseFailure] on the left if either step fails.
  Future<Either<Failure, List<LogEntryModel>>> loadRecentEntries({
    int limit = LogsConstants.logReadLimit,
  }) async {
    try {
      await (_db.delete(_db.logEntryTable)..where(
            (t) => t.timestamp.isSmallerThanValue(
              DateTime.now().subtract(LogsConstants.logRetentionWindow),
            ),
          ))
          .go();
      final List<LogEntryRow> rows =
          await (_db.select(_db.logEntryTable)
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.timestamp,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(limit))
              .get();
      return Right(rows.map(LogEntryModel.fromRow).toList());
    } on SqliteException catch (e) {
      sl<LoggerService>().e(e.toString());
      return Left(DatabaseFailure(e.toString()));
    }
  }

  /// Deletes every entry logged at or before [cutoff] — never everything
  /// unconditionally, so an entry logged during this very operation (e.g. an
  /// error thrown by the delete itself) is timestamped after [cutoff] and
  /// survives.
  /// Returns [DatabaseFailure] on the left if the delete fails.
  Future<Either<Failure, Unit>> clearEntries(DateTime cutoff) async {
    try {
      await (_db.delete(
        _db.logEntryTable,
      )..where((t) => t.timestamp.isSmallerOrEqualValue(cutoff))).go();
      return const Right(unit);
    } on SqliteException catch (e) {
      sl<LoggerService>().e(e.toString());
      return Left(DatabaseFailure(e.toString()));
    }
  }

  /// Opens the platform save dialog and writes [entries] as plain text if
  /// the user picks a location. Uses [LogEntry.details] when captured — the
  /// full decorated output is more useful to the dev team than the plain
  /// [LogEntry.message] the Logs screen shows. The right value is `null` if
  /// the user cancels without choosing one.
  /// Returns [FileSystemFailure] on the left if the picker or write fails.
  Future<Either<Failure, String?>> exportEntries(List<LogEntry> entries) async {
    try {
      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: 'app-${_filenameTimestamp(_now())}.log',
      );
      if (location == null) {
        return const Right(null);
      }
      final String contents = entries
          .map(
            (entry) =>
                '${entry.timestamp} [${entry.level.name}] '
                '${entry.details ?? entry.message}',
          )
          .join('\n');
      await File(location.path).writeAsString(contents);
      return Right(location.path);
    } on PlatformException catch (e) {
      sl<LoggerService>().e(e.toString());
      return Left(FileSystemFailure(e.toString()));
    } on FileSystemException catch (e) {
      sl<LoggerService>().e(e.toString());
      return Left(FileSystemFailure(e.toString()));
    }
  }
}
