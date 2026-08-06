import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android 8+ launcher uses the transparent adaptive foreground', () {
    final icon = File(
      'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml',
    ).readAsStringSync();
    final foreground = File(
      'android/app/src/main/res/drawable-nodpi/ic_launcher_foreground.png',
    );
    final colors = File(
      'android/app/src/main/res/values/colors.xml',
    ).readAsStringSync();

    expect(icon, contains('<adaptive-icon'));
    expect(icon, contains('@color/icon_background'));
    expect(icon, contains('@drawable/ic_launcher_foreground'));
    expect(colors, contains('<color name="icon_background">#0B0B10</color>'));
    expect(foreground.existsSync(), isTrue);
    expect(foreground.lengthSync(), greaterThan(0));
  });
}
