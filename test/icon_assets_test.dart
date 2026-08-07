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
}
