// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';

/// Requests loading the retained log entries, on first mount.
@immutable
class LoadLogEntriesAction extends Equatable {
  const LoadLogEntriesAction();

  @override
  List<Object?> get props => [];
}

/// Dispatched by middleware once entries have been loaded from the database.
@immutable
class LogEntriesLoadedAction extends Equatable {
  /// The loaded entries, newest first.
  final List<LogEntry> entries;

  /// The resolved logs folder path.
  final String folderPath;

  const LogEntriesLoadedAction({
    required this.entries,
    required this.folderPath,
  });

  @override
  List<Object?> get props => [entries, folderPath];
}

/// Requests deleting every entry logged at or before [cutoff]. [cutoff] is
/// captured by the caller at the moment of the request — never computed
/// here or further down the chain — so an entry logged during the clear
/// operation itself is timestamped after it and survives.
@immutable
class ClearLogEntriesAction extends Equatable {
  /// Deletes every entry logged at or before this moment.
  final DateTime cutoff;

  const ClearLogEntriesAction(this.cutoff);

  @override
  List<Object?> get props => [cutoff];
}

/// Requests exporting the currently-loaded log entries to a file.
@immutable
class ExportLogEntriesAction extends Equatable {
  const ExportLogEntriesAction();

  @override
  List<Object?> get props => [];
}

/// Requests opening the logs folder in the OS file explorer.
@immutable
class OpenLogsFolderAction extends Equatable {
  const OpenLogsFolderAction();

  @override
  List<Object?> get props => [];
}
