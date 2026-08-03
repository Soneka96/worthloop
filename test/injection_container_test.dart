// Dart imports:
import 'dart:io';

// Package imports:
import 'package:file/file.dart' show FileSystem;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/navigation/window_route_watcher.dart';
import 'package:worth_loop/shared/notifications/system_notification_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/utils/Iapp_relaunch.gateway.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';
import 'package:worth_loop/shared/utils/system_opener.dart';
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';
import 'package:worth_loop/shared/window/home_window_size_service.dart';
import 'package:worth_loop/shared/window/window_controller.dart';

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
        sl.isRegistered<AppDataRootService>(),
        isTrue,
        reason: 'AppDataRootService should be registered',
      );
      expect(
        sl.isRegistered<FileSystem>(),
        isTrue,
        reason: 'FileSystem should be registered',
      );
      expect(
        sl.isRegistered<PopupService>(),
        isTrue,
        reason: 'PopupService should be registered',
      );
      expect(
        sl.isRegistered<SystemNotificationService>(),
        isTrue,
        reason: 'SystemNotificationService should be registered',
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
        sl.isRegistered<IWindowGateway>(),
        isTrue,
        reason: 'IWindowGateway should be registered',
      );
      expect(
        sl.isRegistered<WindowController>(),
        isTrue,
        reason: 'WindowController should be registered',
      );
      expect(
        sl.isRegistered<WindowRouteWatcher>(),
        isTrue,
        reason: 'WindowRouteWatcher should be registered',
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
        sl.isRegistered<HomeWindowSizeService>(),
        isTrue,
        reason: 'HomeWindowSizeService should be registered',
      );
      expect(
        sl.isRegistered<IAppRelaunchGateway>(),
        isTrue,
        reason: 'IAppRelaunchGateway should be registered',
      );
      expect(
        sl.isRegistered<SystemOpener>(),
        isTrue,
        reason: 'SystemOpener should be registered',
      );
      expect(
        sl.isRegistered<LogEntryLocalDatasource>(),
        isTrue,
        reason: 'LogEntryLocalDatasource should be registered',
      );
      expect(
        sl.isRegistered<LoggerService>(),
        isTrue,
        reason: 'LoggerService should be registered',
      );
    });
  });
}
