// Package imports:
import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:worth_loop/features/github_explorer/github_explorer.injection_container.dart';
import 'package:worth_loop/features/home/home.injection_container.dart';
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/features/logs/logs.injection_container.dart';
import 'package:worth_loop/features/settings/settings.injection_container.dart';
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/navigation/app_router.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/navigation/window_route_watcher.dart';
import 'package:worth_loop/shared/notifications/Inotification.gateway.dart';
import 'package:worth_loop/shared/notifications/notification_gateway.dart';
import 'package:worth_loop/shared/notifications/system_notification_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_manager.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/utils/Iapp_relaunch.gateway.dart';
import 'package:worth_loop/shared/utils/app_relaunch_gateway.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';
import 'package:worth_loop/shared/utils/system_opener.dart';
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';
import 'package:worth_loop/shared/window/home_window_size_service.dart';
import 'package:worth_loop/shared/window/window_controller.dart';
import 'package:worth_loop/shared/window/window_gateway.dart';

/// Global service locator. Widgets and use cases resolve dependencies via
/// `sl<Type>()` — never instantiate services directly.
final sl = GetIt.instance;

/// Root dependency injection container.
/// Wire all concrete implementations here. Call [initDependencies] once from
/// [main] before [runApp]. Shared dependencies are registered first, then each
/// feature's own injection container is called — features may depend on shared
/// registrations (e.g. [AppDatabase]), so order matters.
Future<void> initDependencies() async {
  // Shared
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton<PackageInfo>(() => packageInfo);
  sl.registerLazySingleton<AppPreferencesStore>(AppPreferencesStore.new);
  sl.registerLazySingleton<FileSystem>(() => const LocalFileSystem());
  sl.registerLazySingleton<AppDataRootService>(
    () => AppDataRootService(sl<AppPreferencesStore>(), sl<FileSystem>()),
  );
  sl.registerLazySingleton<IWindowGateway>(WindowGateway.new);
  sl.registerLazySingleton<HomeWindowSizeService>(HomeWindowSizeService.new);
  sl.registerLazySingleton<INotificationGateway>(NotificationGateway.new);
  sl.registerLazySingleton<SystemNotificationService>(
    () => SystemNotificationService(sl<INotificationGateway>()),
  );
  sl.registerLazySingleton<WindowController>(
    () => WindowController(
      sl<IWindowGateway>(),
      sl<AppPreferencesStore>(),
      sl<HomeWindowSizeService>(),
      sl<SystemNotificationService>(),
    ),
  );
  sl.registerLazySingleton<WindowRouteWatcher>(
    () => WindowRouteWatcher(sl<WindowController>()),
  );
  sl.registerLazySingleton<GoRouter>(() {
    final GoRouter router = createRouter();
    sl<WindowRouteWatcher>().attachTo(router);
    return router;
  });
  sl.registerLazySingleton<NavigatorService>(
    () => NavigatorService(sl<GoRouter>()),
  );
  sl.registerLazySingleton<AppDatabase>(AppDatabase.new);
  sl.registerLazySingleton<Dio>(Dio.new);
  sl.registerLazySingleton<SnugToastManager>(SnugToastManager.new);
  sl.registerLazySingleton<PopupService>(PopupService.new);
  sl.registerLazySingleton<IAppRelaunchGateway>(AppRelaunchGateway.new);
  sl.registerLazySingleton<SystemOpener>(
    () => SystemOpener(sl<LoggerService>()),
  );
  sl.registerSingleton<AppTheme>(
    await AppTheme.restore(sl<AppPreferencesStore>()),
  );
  sl.registerSingleton<AppZoom>(
    await AppZoom.restore(sl<AppPreferencesStore>()),
  );
  sl.registerSingleton<AppShape>(
    await AppShape.restore(sl<AppPreferencesStore>()),
  );
  sl.registerSingleton<AppSpacing>(
    await AppSpacing.restore(sl<AppPreferencesStore>()),
  );
  sl.registerSingleton<AppFont>(
    await AppFont.restore(sl<AppPreferencesStore>()),
  );
  sl.registerSingleton<AppLanguage>(
    await AppLanguage.restore(sl<AppPreferencesStore>()),
  );

  // Features
  initSettingsDependencies();
  initLogsDependencies();
  initGithubExplorerDependencies();
  initHomeDependencies();

  // The shared LoggerService is constructed last, after initLogsDependencies()
  // — one of its Logger's outputs is LogEntryLocalDatasource, a
  // logs-feature-owned datasource, which must already be registered by that
  // point.
  final Directory dataDirectory = await sl<AppDataRootService>()
      .resolveCurrentDataDirectory();
  sl.registerLazySingleton<LoggerService>(
    () => LoggerService(
      Logger(
        output: MultiOutput([
          sl<LogEntryLocalDatasource>(),
          AdvancedFileOutput(
            path: p.join(dataDirectory.path, LogsConstants.folderName),
          ),
        ]),
      ),
      sl<PopupService>(),
    ),
  );
}
