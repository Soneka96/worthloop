// Project imports:
import 'package:worth_loop/features/logs/data/models/log_entry.model.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Builds a [LogEntryModel] with default values for every field, overridable individually.
LogEntryModel buildLogEntryModel({
  DateTime? timestamp,
  LogLevel level = LogLevel.info,
  String message = 'Test log message',
  String? details,
}) => LogEntryModel(
  timestamp: timestamp ?? DateTime(2026, 1, 1),
  level: level,
  message: message,
  details: details,
);
