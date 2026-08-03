// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Builds a [LogEntry] with default values for every field, overridable individually.
LogEntry buildLogEntry({
  DateTime? timestamp,
  LogLevel level = LogLevel.info,
  String message = 'Test log message',
  String? details,
}) => LogEntry(
  timestamp: timestamp ?? DateTime(2026, 1, 1, 12),
  level: level,
  message: message,
  details: details,
);
