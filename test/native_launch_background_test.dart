import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('native launch backgrounds do not render the launcher icon', () {
    const paths = [
      'android/app/src/main/res/drawable/launch_background.xml',
      'android/app/src/main/res/drawable-v21/launch_background.xml',
    ];

    final backgrounds = paths.map(File.new).map((file) {
      final contents = file.readAsStringSync();

      expect(contents, contains('@color/launch_background'));
      expect(contents, isNot(contains('@mipmap/ic_launcher')));
      expect(contents, isNot(contains('<bitmap')));
      return contents;
    }).toList();

    expect(backgrounds[1], backgrounds[0]);
  });
}
