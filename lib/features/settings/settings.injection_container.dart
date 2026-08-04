// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/datasources/refresh_settings_local.datasource.dart';
import 'package:worth_loop/features/settings/data/repositories/refresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Registers the settings feature's dependencies. Called at the end of the
/// root [initDependencies].
void initSettingsDependencies() {
  sl.registerLazySingleton<RefreshSettingsLocalDatasource>(
    () => RefreshSettingsLocalDatasource(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<IRefreshSettingsRepository>(
    () => RefreshSettingsRepository(sl<RefreshSettingsLocalDatasource>()),
  );
  sl.registerLazySingleton<LoadRefreshSettingsUseCase>(
    () => LoadRefreshSettingsUseCase(sl<IRefreshSettingsRepository>()),
  );
  sl.registerLazySingleton<SaveRefreshIntervalUseCase>(
    () => SaveRefreshIntervalUseCase(sl<IRefreshSettingsRepository>()),
  );
  sl.registerFactoryParam<
    GeneralSettingsScreenViewModel,
    Store<AppState>,
    void
  >((store, _) => GeneralSettingsScreenViewModel.fromStore(store));
}
