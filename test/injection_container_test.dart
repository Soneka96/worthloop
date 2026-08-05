// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
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
      expect(
        options.headers['User-Agent'],
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120 Safari/537.36',
      );
      expect(options.headers['Accept'], isA<String>());
      expect(
        options.headers['Accept'],
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      );
      expect(options.headers['Accept-Language'], isA<String>());
      expect(options.headers['Accept-Language'], 'pt-PT,pt;q=0.9,en;q=0.8');
      expect(options.headers['Connection'], isA<String>());
      expect(options.headers['Connection'], 'keep-alive');
      expect(options.connectTimeout, isA<Duration>());
      expect(options.connectTimeout, PriceFetchConstants.connectTimeout);
      expect(options.receiveTimeout, isA<Duration>());
      expect(options.receiveTimeout, PriceFetchConstants.receiveTimeout);
      expect(options.sendTimeout, isA<Duration>());
      expect(options.sendTimeout, PriceFetchConstants.sendTimeout);
    });

    test('Dio has RetryOnConnectionErrorInterceptor attached', () {
      expect(
        sl<Dio>().interceptors.whereType<RetryOnConnectionErrorInterceptor>(),
        hasLength(1),
      );
    });
  });
}
