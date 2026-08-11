// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/main.dart';

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
  setUpAll(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    PackageInfoPlatform.instance = FakePackageInfoPlatform();
  });
  setUp(() async => initDependencies());
  tearDown(() async => sl.reset());

  group('App — smoke', () {
    testWidgets('App renders without throwing on launch', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(App), findsOneWidget);
    });

    testWidgets('App keeps routed content above the Android navigation bar', (
      tester,
    ) async {
      await tester.pumpWidget(const App());
      // Wait for splash to finish and app to initialize. In test mode, animations are instant,
      // but post-frame callbacks and database initialization need time.
      // Pump multiple times to ensure all deferred work (post-frame callbacks) processes.
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      final SafeArea safeArea = tester.widget(
        find.byKey(const Key('app-bottom-safe-area')),
      );
      expect(safeArea.top, isA<bool>());
      expect(safeArea.top, isFalse);
      expect(safeArea.bottom, isA<bool>());
      expect(safeArea.bottom, isTrue);
    });
  });
}
