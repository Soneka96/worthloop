// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';

/// Redux state for the Logs settings category.
@immutable
class LogsState extends Equatable {
  /// The currently-loaded log entries, newest first.
  final List<LogEntry> entries;

  /// The resolved logs folder path, or `null` before the first load.
  final String? folderPath;

  const LogsState({required this.entries, required this.folderPath});

  /// Returns the default state, used until entries are first loaded.
  factory LogsState.initial() => const LogsState(entries: [], folderPath: null);

  /// Returns a copy with the given fields replaced.
  LogsState copyWith({List<LogEntry>? entries, String? folderPath}) {
    return LogsState(
      entries: entries ?? this.entries,
      folderPath: folderPath ?? this.folderPath,
    );
  }

  @override
  List<Object?> get props => [entries, folderPath];
}
