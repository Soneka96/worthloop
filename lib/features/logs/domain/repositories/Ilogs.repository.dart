// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Coordinates the local datasource for the logs feature.
abstract class ILogsRepository {
  /// Loads the retained log entries, newest first.
  Future<Either<Failure, List<LogEntry>>> loadRecentLogEntries();

  /// Deletes every entry logged at or before [cutoff].
  Future<Either<Failure, Unit>> clearLogEntries(DateTime cutoff);

  /// Opens the platform save dialog and writes [entries] as plain text if
  /// the user picks a location. The right value is `null` if the user
  /// cancels without choosing one.
  Future<Either<Failure, String?>> exportLogEntries(List<LogEntry> entries);
}
