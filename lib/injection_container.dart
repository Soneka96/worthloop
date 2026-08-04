// Package imports:
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/github_explorer.injection_container.dart';
import 'package:worth_loop/features/home/home.injection_container.dart';
import 'package:worth_loop/features/products/products.injection_container.dart';
import 'package:worth_loop/features/settings/settings.injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/navigation/app_router.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_manager.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';

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
  sl.registerLazySingleton<GoRouter>(createRouter);
  sl.registerLazySingleton<NavigatorService>(
    () => NavigatorService(sl<GoRouter>()),
  );
  sl.registerLazySingleton<AppDatabase>(AppDatabase.new);
  sl.registerLazySingleton<Dio>(Dio.new);
  sl.registerLazySingleton<SnugToastManager>(SnugToastManager.new);
  sl.registerLazySingleton<PopupService>(PopupService.new);
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
  initGithubExplorerDependencies();
  initHomeDependencies();
  initProductsDependencies();

  sl.registerLazySingleton<LoggerService>(
    () => LoggerService(Logger(), sl<PopupService>()),
  );
}
