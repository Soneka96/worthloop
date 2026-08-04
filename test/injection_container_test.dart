// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
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
    appName: 'worth_loop',
    packageName: 'com.soneka96.starter',
    version: '0.0.0-test',
    buildNumber: '1',
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
  });
}
