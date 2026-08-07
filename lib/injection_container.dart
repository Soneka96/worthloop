// Package imports:
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:worth_loop/features/home/home.injection_container.dart';
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/features/products/products.injection_container.dart';
import 'package:worth_loop/features/settings/settings.injection_container.dart';
import 'package:worth_loop/shared/constants/price_fetch_constants.dart';
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
import 'package:worth_loop/shared/utils/browser_request_headers.dart';
import 'package:worth_loop/shared/utils/android_background_capabilities_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';
import 'package:worth_loop/shared/utils/dio_product_fetcher_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';
import 'package:worth_loop/shared/utils/product_offer_decoder_service.dart';
import 'package:worth_loop/shared/utils/product_price_fetch_orchestrator_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';
import 'package:worth_loop/shared/utils/retry_on_connection_error_interceptor.dart';
import 'package:worth_loop/shared/utils/url_launcher_service.dart';
import 'package:worth_loop/shared/utils/webview_product_fetcher_service.dart';

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
  final Map<String, String> browserRequestHeaders =
      await BrowserRequestHeaders.build();
  sl.registerLazySingleton<PackageInfo>(() => packageInfo);
  sl.registerLazySingleton<AppPreferencesStore>(AppPreferencesStore.new);
  sl.registerLazySingleton<GoRouter>(createRouter);
  sl.registerLazySingleton<NavigatorService>(
    () => NavigatorService(sl<GoRouter>()),
  );
  sl.registerLazySingleton<AppDatabase>(AppDatabase.new);
  sl.registerLazySingleton<Dio>(() {
    final Dio dio = Dio(_buildDioBaseOptions(browserRequestHeaders));
    dio.interceptors
      ..add(CookieManager(CookieJar()))
      ..add(RetryOnConnectionErrorInterceptor(dio));
    return dio;
  });
  sl.registerLazySingleton<SnugToastManager>(SnugToastManager.new);
  sl.registerLazySingleton<PopupService>(PopupService.new);
  sl.registerLazySingleton<ProductUrlCleanerService>(
    ProductUrlCleanerService.new,
  );
  sl.registerLazySingleton<UrlLauncherService>(UrlLauncherService.new);
  sl.registerLazySingleton<AndroidBackgroundCapabilitiesService>(
    AndroidBackgroundCapabilitiesService.new,
  );
  sl.registerLazySingleton<AndroidBackgroundRefreshService>(
    AndroidBackgroundRefreshService.new,
  );
  sl.registerLazySingleton<DioProductFetcherService>(
    () => DioProductFetcherService(sl<Dio>()),
  );
  sl.registerLazySingleton<WebViewProductFetcherService>(
    WebViewProductFetcherService.new,
  );
  sl.registerLazySingleton<ProductOfferDecoderService>(
    ProductOfferDecoderService.new,
  );
  sl.registerLazySingleton<ProductPriceFetchOrchestratorService>(
    () => ProductPriceFetchOrchestratorService(
      sl<ProductUrlCleanerService>(),
      sl<DioProductFetcherService>(),
      sl<WebViewProductFetcherService>(),
      sl<ProductOfferDecoderService>(),
      sl<PriceResponseDetector>(),
    ),
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
  initHomeDependencies();
  initProductsDependencies();

  sl.registerLazySingleton<LoggerService>(
    () => LoggerService(Logger(), sl<PopupService>()),
  );
}

// Browser-like headers so merchant sites don't reject the app as a bot;
// timeouts bound requests to sites that never respond.
BaseOptions _buildDioBaseOptions(Map<String, String> headers) => BaseOptions(
  connectTimeout: PriceFetchConstants.connectTimeout,
  receiveTimeout: PriceFetchConstants.receiveTimeout,
  sendTimeout: PriceFetchConstants.sendTimeout,
  followRedirects: true,
  maxRedirects: 5,
  headers: {...headers, 'Accept-Encoding': 'gzip, deflate'},
);
