// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/utils/android_background_capabilities_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';
import 'package:worth_loop/shared/constants/price_fetch_constants.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';
import 'package:worth_loop/shared/utils/retry_on_connection_error_interceptor.dart';
import 'package:worth_loop/shared/utils/url_launcher_service.dart';

class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationSupportPath() async =>
      Directory.systemTemp.path;

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.path;
}

class FakePackageInfoPlatform extends PackageInfoPlatform {
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async => PackageInfoData(
    appName: 'WorthLoop Test',
    packageName: 'io.github.soneka96.worthloop.test',
    version: '0.0.0-test',
    buildNumber: '0',
    buildSignature: '',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    PackageInfoPlatform.instance = FakePackageInfoPlatform();
  });
  setUp(() async => initDependencies());
  tearDown(() async => sl.reset());

  group('injection_container — shared registrations', () {
    test('background capability service is registered', () {
      expect(
        sl<AndroidBackgroundCapabilitiesService>(),
        isA<AndroidBackgroundCapabilitiesService>(),
      );
    });

    test('background refresh service is registered', () {
      expect(
        sl<AndroidBackgroundRefreshService>(),
        isA<AndroidBackgroundRefreshService>(),
      );
    });

    test('price-alert notification service is registered', () {
      expect(
        sl<AndroidPriceAlertNotificationService>(),
        isA<AndroidPriceAlertNotificationService>(),
      );
    });
    test('services are registered', () {
      expect(
        sl.isRegistered<GoRouter>(),
        isTrue,
        reason: 'GoRouter should be registered',
      );
      expect(
        sl.isRegistered<NavigatorService>(),
        isTrue,
        reason: 'NavigatorService should be registered',
      );
      expect(
        sl.isRegistered<AppDatabase>(),
        isTrue,
        reason: 'AppDatabase should be registered',
      );
      expect(
        sl.isRegistered<PopupService>(),
        isTrue,
        reason: 'PopupService should be registered',
      );
      expect(
        sl.isRegistered<AppTheme>(),
        isTrue,
        reason: 'AppTheme should be registered',
      );
      expect(
        sl.isRegistered<AppPreferencesStore>(),
        isTrue,
        reason: 'AppPreferencesStore should be registered',
      );
      expect(
        sl.isRegistered<AppZoom>(),
        isTrue,
        reason: 'AppZoom should be registered',
      );
      expect(
        sl.isRegistered<AppShape>(),
        isTrue,
        reason: 'AppShape should be registered',
      );
      expect(
        sl.isRegistered<AppSpacing>(),
        isTrue,
        reason: 'AppSpacing should be registered',
      );
      expect(
        sl.isRegistered<AppFont>(),
        isTrue,
        reason: 'AppFont should be registered',
      );
      expect(
        sl.isRegistered<AppLanguage>(),
        isTrue,
        reason: 'AppLanguage should be registered',
      );
      expect(
        sl.isRegistered<LoggerService>(),
        isTrue,
        reason: 'LoggerService should be registered',
      );
      expect(
        sl.isRegistered<UrlLauncherService>(),
        isTrue,
        reason: 'UrlLauncherService should be registered',
      );
    });

    test('PackageInfo preserves platform metadata', () {
      expect(sl<PackageInfo>().appName, isA<String>());
      expect(sl<PackageInfo>().appName, 'WorthLoop Test');
      expect(sl<PackageInfo>().packageName, isA<String>());
      expect(
        sl<PackageInfo>().packageName,
        'io.github.soneka96.worthloop.test',
      );
      expect(sl<PackageInfo>().version, isA<String>());
      expect(sl<PackageInfo>().version, '0.0.0-test');
      expect(sl<PackageInfo>().buildNumber, isA<String>());
      expect(sl<PackageInfo>().buildNumber, '0');
    });

    test('Dio is configured with browser-like headers and timeouts', () {
      final BaseOptions options = sl<Dio>().options;

      expect(options.headers['User-Agent'], isA<String>());
      expect(options.headers['User-Agent'], startsWith('Mozilla/5.0'));
      expect(options.headers['Accept'], isA<String>());
      expect(
        options.headers['Accept'],
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      );
      expect(options.headers['Accept-Language'], isA<String>());
      expect(options.headers['Accept-Language'], contains(','));
      expect(options.headers['Accept-Encoding'], 'gzip, deflate');
      expect(options.connectTimeout, isA<Duration>());
      expect(options.connectTimeout, PriceFetchConstants.connectTimeout);
      expect(options.receiveTimeout, isA<Duration>());
      expect(options.receiveTimeout, PriceFetchConstants.receiveTimeout);
      expect(options.sendTimeout, isA<Duration>());
      expect(options.sendTimeout, PriceFetchConstants.sendTimeout);
      expect(options.followRedirects, isTrue);
      expect(options.maxRedirects, 5);
    });

    test('Dio has RetryOnConnectionErrorInterceptor attached', () {
      expect(
        sl<Dio>().interceptors.whereType<RetryOnConnectionErrorInterceptor>(),
        hasLength(1),
      );
    });

    test('Dio has an app-owned CookieManager attached', () {
      expect(sl<Dio>().interceptors.whereType<CookieManager>(), hasLength(1));
    });
  });
}
