// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';

/// Reducer responsible for handling changes to [LogsState] based on
/// dispatched actions.
///
/// [LoadLogEntriesAction], [ClearLogEntriesAction], [ExportLogEntriesAction],
/// and [OpenLogsFolderAction] are middleware-only triggers with no state of
/// their own — none has a [TypedReducer] here, so `combineReducers` leaves
/// the state unchanged for them.
Reducer<LogsState> logsReducer = combineReducers<LogsState>([
  /// Handles entries being loaded from the database.
  /// Updates [LogsState.entries], [LogsState.folderPath].
  TypedReducer<LogsState, LogEntriesLoadedAction>(logEntriesLoadedReducer).call,
]);

/// Handles entries being loaded from the database.
/// Updates [LogsState.entries], [LogsState.folderPath].
LogsState logEntriesLoadedReducer(
  LogsState state,
  LogEntriesLoadedAction action,
) => state.copyWith(entries: action.entries, folderPath: action.folderPath);
