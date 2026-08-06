import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('debug and release have distinct Android identities', () {
    final buildConfig = File('android/app/build.gradle.kts').readAsStringSync();
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final releaseStrings = File(
      'android/app/src/main/res/values/strings.xml',
    ).readAsStringSync();
    final debugStrings = File(
      'android/app/src/debug/res/values/strings.xml',
    ).readAsStringSync();
    final debugColors = File(
      'android/app/src/debug/res/values/colors.xml',
    ).readAsStringSync();
    final releaseColors = File(
      'android/app/src/main/res/values/colors.xml',
    ).readAsStringSync();
    final launcherIcon = File(
      'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml',
    ).readAsStringSync();

    expect(buildConfig, contains('applicationId = "io.github.soneka96.worthloop"'));
    expect(buildConfig, contains('applicationIdSuffix = ".debug"'));
    expect(manifest, contains('android:label="@string/app_name"'));
    expect(releaseStrings, contains('<string name="app_name">WorthLoop</string>'));
    expect(releaseStrings, isNot(contains('WorthLoop Debug')));
    expect(
      debugStrings,
      contains('<string name="app_name">WorthLoop Debug</string>'),
    );
    expect(debugStrings, isNot(contains('<string name="app_name">WorthLoop</string>')));
    expect(releaseColors, contains('<color name="icon_background">#0B0B10</color>'));
    expect(debugColors, contains('<color name="icon_background">#F59E0B</color>'));
    expect(launcherIcon, contains('@color/icon_background'));
  });
}
