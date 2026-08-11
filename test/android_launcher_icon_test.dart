import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android 8+ launcher uses the padded transparent foreground', () async {
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
    final bytes = foreground.readAsBytesSync();
    expect(_pngDimensions(bytes), (1254, 1254));
    final ui.Rect bounds = await _alphaBounds(bytes);
    expect(bounds.left, greaterThanOrEqualTo(200));
    expect(bounds.top, greaterThanOrEqualTo(200));
    expect(bounds.right, lessThanOrEqualTo(1054));
    expect(bounds.bottom, lessThanOrEqualTo(1054));
    expect(
      File('assets/launch_icon_alpha.png').existsSync(),
      isTrue,
    );
  });
}

Future<ui.Rect> _alphaBounds(List<int> bytes) async {
  final ui.Codec codec = await ui.instantiateImageCodec(
    Uint8List.fromList(bytes),
  );
  final ui.FrameInfo frame = await codec.getNextFrame();
  final ByteData? data = await frame.image.toByteData(
    format: ui.ImageByteFormat.rawRgba,
  );
  if (data == null) {
    throw StateError('Could not decode launcher foreground pixels');
  }

  int left = frame.image.width;
  int top = frame.image.height;
  int right = 0;
  int bottom = 0;
  for (int y = 0; y < frame.image.height; y++) {
    for (int x = 0; x < frame.image.width; x++) {
      if (data.getUint8((y * frame.image.width + x) * 4 + 3) == 0) {
        continue;
      }
      left = left < x ? left : x;
      top = top < y ? top : y;
      right = right > x + 1 ? right : x + 1;
      bottom = bottom > y + 1 ? bottom : y + 1;
    }
  }
  return ui.Rect.fromLTRB(
    left.toDouble(),
    top.toDouble(),
    right.toDouble(),
    bottom.toDouble(),
  );
}

(int, int) _pngDimensions(List<int> bytes) {
  expect(bytes.length, greaterThanOrEqualTo(24));
  expect(bytes.take(8), [137, 80, 78, 71, 13, 10, 26, 10]);

  int readInt32(int offset) =>
      (bytes[offset] << 24) |
      (bytes[offset + 1] << 16) |
      (bytes[offset + 2] << 8) |
      bytes[offset + 3];

  return (readInt32(16), readInt32(20));
}
