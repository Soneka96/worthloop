// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Implements [ILogsRepository]. Coordinates [LogEntryLocalDatasource] for
/// the logs feature. Returns [LogEntryModel] instances directly — it
/// satisfies [LogEntry] (domain) since [LogEntryModel] extends it.
class LogsRepository implements ILogsRepository {
  LogsRepository(this._local);

  /// Local datasource this repository coordinates.
  final LogEntryLocalDatasource _local;

  @override
  Future<Either<Failure, List<LogEntry>>> loadRecentLogEntries() {
    return _local.loadRecentEntries();
  }

  @override
  Future<Either<Failure, Unit>> clearLogEntries(DateTime cutoff) {
    return _local.clearEntries(cutoff);
  }

  @override
  Future<Either<Failure, String?>> exportLogEntries(List<LogEntry> entries) {
    return _local.exportEntries(entries);
  }
}
