// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// A single line from the app's log file — a timestamp, [LogLevel], and
/// message.
@immutable
class LogEntry extends Equatable {
  /// When this entry was logged.
  final DateTime timestamp;

  /// This entry's severity.
  final LogLevel level;

  /// The log message text.
  final String message;

  /// The `logger` package printer's fully decorated output (stack frame,
  /// box-drawing) — `null` if none was captured. Only ever used for
  /// exporting to the dev team; never shown on the Logs screen itself.
  final String? details;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.details,
  });

  @override
  List<Object?> get props => [timestamp, level, message, details];
}
