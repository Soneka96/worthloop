// Dart imports:
import 'dart:io';

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
    appName: 'worth_loop',
    packageName: 'com.soneka96.starter',
    version: '0.0.0-test',
    buildNumber: '1',
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
  });
}
