// Package imports:
import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/usecases/clear_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/export_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/load_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/clear_log_entries.params.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/export_log_entries.params.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/state/create_store.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/system_opener.dart';

/// Handles Logs settings actions. Added to [CreateStore]'s middleware
/// list — see `lib/shared/state/create_store.dart`. [AppDataRootService]
/// and [SystemOpener] have no business rule of their own, so they're
/// resolved via [sl] and called directly here rather than through a
/// usecase/repository/datasource — see `ai/context/architecture.md`'s
/// "Services" section.
class LogsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case LoadLogEntriesAction _:
        _loadLogEntries(store);
      case ClearLogEntriesAction _:
        _clearLogEntries(store, action);
      case ExportLogEntriesAction _:
        _exportLogEntries(store);
      case OpenLogsFolderAction _:
        _openLogsFolder(store);
    }
  }

  /// Handles [LoadLogEntriesAction]. Resolves the logs folder path and
  /// loads the retained entries, then dispatches [LogEntriesLoadedAction]
  /// with both — or shows a popup on failure.
  Future<void> _loadLogEntries(Store<AppState> store) async {
    final Directory dataDirectory = await sl<AppDataRootService>()
        .resolveCurrentDataDirectory();
    final String folderPath = p.join(
      dataDirectory.path,
      LogsConstants.folderName,
    );

    await (await sl<LoadLogEntriesUseCase>()(NoParams())).fold(
      (failure) async =>
          sl<LoggerService>().e(failure.message, showPopup: true),
      (List<LogEntry> entries) async {
        store.dispatch(
          LogEntriesLoadedAction(entries: entries, folderPath: folderPath),
        );
      },
    );
  }

  /// Handles [ClearLogEntriesAction]. Deletes entries at or before
  /// [ClearLogEntriesAction.cutoff], then re-dispatches
  /// [LoadLogEntriesAction] to refresh from the database — or shows a
  /// popup on failure.
  Future<void> _clearLogEntries(
    Store<AppState> store,
    ClearLogEntriesAction action,
  ) async {
    await (await sl<ClearLogEntriesUseCase>()(
      ClearLogEntriesParams(cutoff: action.cutoff),
    )).fold(
      (failure) async =>
          sl<LoggerService>().e(failure.message, showPopup: true),
      (_) async {
        store.dispatch(const LoadLogEntriesAction());
      },
    );
  }

  /// Handles [ExportLogEntriesAction]. Exports the currently-loaded entries
  /// and shows a success popup with the chosen path — or a failure popup;
  /// no popup if the user cancelled the save dialog.
  Future<void> _exportLogEntries(Store<AppState> store) async {
    await (await sl<ExportLogEntriesUseCase>()(
      ExportLogEntriesParams(entries: store.state.logs.entries),
    )).fold(
      (failure) async =>
          sl<LoggerService>().e(failure.message, showPopup: true),
      (String? path) async {
        if (path != null) {
          sl<LoggerService>().i(
            t.settings.logs.exportSucceeded(path: path),
            showPopup: true,
          );
        }
      },
    );
  }

  /// Handles [OpenLogsFolderAction]. Opens the currently-resolved logs
  /// folder in the OS file explorer.
  Future<void> _openLogsFolder(Store<AppState> store) async {
    final String? folderPath = store.state.logs.folderPath;
    if (folderPath != null) {
      await sl<SystemOpener>().openFolder(folderPath);
    }
  }
}
