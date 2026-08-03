// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/features/logs/data/repositories/logs.repository.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/clear_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/export_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/load_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/presentation/state/viewmodels/logs_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Registers the logs feature's dependencies. Called from the root
/// [initDependencies] — before the shared `Logger` is constructed, since
/// [LogEntryLocalDatasource] is one of its outputs.
void initLogsDependencies() {
  sl.registerLazySingleton<LogEntryLocalDatasource>(
    () => LogEntryLocalDatasource(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<ILogsRepository>(
    () => LogsRepository(sl<LogEntryLocalDatasource>()),
  );
  sl.registerLazySingleton<LoadLogEntriesUseCase>(
    () => LoadLogEntriesUseCase(sl<ILogsRepository>()),
  );
  sl.registerLazySingleton<ClearLogEntriesUseCase>(
    () => ClearLogEntriesUseCase(sl<ILogsRepository>()),
  );
  sl.registerLazySingleton<ExportLogEntriesUseCase>(
    () => ExportLogEntriesUseCase(sl<ILogsRepository>()),
  );
  sl.registerFactoryParam<LogsScreenViewModel, Store<AppState>, void>(
    (store, _) => LogsScreenViewModel.fromStore(store),
  );
}
