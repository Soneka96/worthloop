// Project imports:
import 'package:worth_loop/features/logs/data/models/drift_schemas/log_entry.table.dart';
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// DTO mapping a drift [LogEntryTable] row to the domain [LogEntry] entity.
/// Extends [LogEntry] directly — no `toEntity()` mapping needed; a
/// [LogEntryModel] already satisfies anywhere a [LogEntry] is expected.
class LogEntryModel extends LogEntry {
  const LogEntryModel({
    required super.timestamp,
    required super.level,
    required super.message,
    super.details,
  });

  /// Builds a [LogEntryModel] from a generated drift row.
  factory LogEntryModel.fromRow(LogEntryRow row) => LogEntryModel(
    timestamp: row.timestamp,
    level: row.level,
    message: row.message,
    details: row.details,
  );
}
