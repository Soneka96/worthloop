// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/presentation/screens/logs_settings.screen.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the data required by [LogsSettingsScreen].
class LogsScreenViewModel extends Equatable {
  /// The currently-loaded log entries, newest first.
  final List<LogEntry> entries;

  /// The resolved logs folder path, or `''` before the first load.
  final String folderPath;

  /// Dispatches [OpenLogsFolderAction].
  final void Function() onOpenFolder;

  /// Dispatches [ExportLogEntriesAction].
  final void Function() onExport;

  /// Dispatches [ClearLogEntriesAction] with the cutoff captured at the
  /// moment of the call — never precomputed — so an entry logged during
  /// the clear operation itself survives.
  final void Function() onClear;

  const LogsScreenViewModel({
    required this.entries,
    required this.folderPath,
    required this.onOpenFolder,
    required this.onExport,
    required this.onClear,
  });

  factory LogsScreenViewModel.fromStore(Store<AppState> store) {
    return LogsScreenViewModel(
      entries: LogsSelectors.entriesSelector(store.state),
      folderPath: LogsSelectors.folderPathSelector(store.state) ?? '',
      onOpenFolder: () => store.dispatch(const OpenLogsFolderAction()),
      onExport: () => store.dispatch(const ExportLogEntriesAction()),
      onClear: () => store.dispatch(ClearLogEntriesAction(DateTime.now())),
    );
  }

  @override
  List<Object?> get props => [entries, folderPath];
}
