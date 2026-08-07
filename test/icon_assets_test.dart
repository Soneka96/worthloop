import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('canonical WorthLoop mark is a padded RGBA PNG', () async {
    final File file = File('assets/worthloop_mark.png');
    expect(file.existsSync(), isTrue);

    final Uint8List bytes = file.readAsBytesSync();
    expect(bytes.length, greaterThan(32));
    expect(bytes.sublist(0, 8), <int>[137, 80, 78, 71, 13, 10, 26, 10]);

    final ByteData header = ByteData.sublistView(bytes, 16, 29);
    expect(header.getUint32(0), 1254);
    expect(header.getUint32(4), 1254);
    expect(header.getUint8(8), 8);
    expect(header.getUint8(9), 6);

    final ByteData bundled = await rootBundle.load('assets/worthloop_mark.png');
    final ui.Codec codec = await ui.instantiateImageCodec(
      bundled.buffer.asUint8List(
        bundled.offsetInBytes,
        bundled.offsetInBytes + bundled.lengthInBytes,
      ),
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ByteData? pixels = await frame.image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    expect(pixels, isNotNull);
    expect(pixels!.getUint8(3), 0);
    expect(pixels.getUint8((frame.image.width - 1) * 4 + 3), 0);
    frame.image.dispose();
    codec.dispose();
  });

  test('Android launcher keeps full-color and themed icon layers wired', () {
    final File adaptiveIcon = File(
      'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml',
    );
    final String xml = adaptiveIcon.readAsStringSync();
    expect(xml, contains('<monochrome'));
    expect(xml, contains('@drawable/ic_launcher_monochrome'));

    for (final String path in <String>[
      'android/app/src/main/res/drawable-nodpi/ic_launcher_foreground.png',
      'android/app/src/main/res/drawable-nodpi/ic_launcher_monochrome.png',
    ]) {
      final File file = File(path);
      expect(file.existsSync(), isTrue, reason: path);
      final Uint8List bytes = file.readAsBytesSync();
      expect(bytes.sublist(0, 8), <int>[
        137,
        80,
        78,
        71,
        13,
        10,
        26,
        10,
      ]);
    }
  });

  test('Android launcher layers preserve purple default and monochrome tinting', () async {
    final ui.Image foreground = await _decodePng(
      'android/app/src/main/res/drawable-nodpi/ic_launcher_foreground.png',
    );
    final ByteData? foregroundPixels = await foreground.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    expect(foregroundPixels, isNotNull);

    int purplePixels = 0;
    for (int offset = 0; offset < foregroundPixels!.lengthInBytes; offset += 4) {
      final int red = foregroundPixels.getUint8(offset);
      final int green = foregroundPixels.getUint8(offset + 1);
      final int blue = foregroundPixels.getUint8(offset + 2);
      final int alpha = foregroundPixels.getUint8(offset + 3);
      if (alpha > 0 && blue > red && blue > green * 2) {
        purplePixels++;
      }
    }
    expect(purplePixels, greaterThan(100));
    foreground.dispose();

    final ui.Image monochrome = await _decodePng(
      'android/app/src/main/res/drawable-nodpi/ic_launcher_monochrome.png',
    );
    final ByteData? monochromePixels = await monochrome.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    expect(monochromePixels, isNotNull);

    for (int offset = 0; offset < monochromePixels!.lengthInBytes; offset += 4) {
      final int alpha = monochromePixels.getUint8(offset + 3);
      if (alpha > 0) {
        expect(monochromePixels.getUint8(offset), monochromePixels.getUint8(offset + 1));
        expect(monochromePixels.getUint8(offset + 1), monochromePixels.getUint8(offset + 2));
      }
    }
    monochrome.dispose();
  });

  test('adaptive launcher layers keep the mark inside the 66dp safe zone', () async {
    for (final String path in <String>[
      'android/app/src/main/res/drawable-nodpi/ic_launcher_foreground.png',
      'android/app/src/main/res/drawable-nodpi/ic_launcher_monochrome.png',
    ]) {
      final ui.Image image = await _decodePng(path);
      expect(image.width, 1254);
      expect(image.height, 1254);

      final ByteData? pixels = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      expect(pixels, isNotNull);

      int minX = image.width;
      int minY = image.height;
      int maxX = -1;
      int maxY = -1;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final int alpha = pixels!.getUint8((y * image.width + x) * 4 + 3);
          if (alpha > 12) {
            minX = minX < x ? minX : x;
            minY = minY < y ? minY : y;
            maxX = maxX > x ? maxX : x;
            maxY = maxY > y ? maxY : y;
          }
        }
      }

      final int safeMargin = (1254 * 21 / 108).round();
      expect(minX, greaterThanOrEqualTo(safeMargin));
      expect(minY, greaterThanOrEqualTo(safeMargin));
      expect(maxX, lessThan(1254 - safeMargin));
      expect(maxY, lessThan(1254 - safeMargin));
      image.dispose();
    }
  });
}

Future<ui.Image> _decodePng(String path) async {
  final Uint8List bytes = File(path).readAsBytesSync();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frame = await codec.getNextFrame();
  codec.dispose();
  return frame.image;
}
