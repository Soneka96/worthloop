import 'dart:io';
import 'dart:typed_data';

/// `FontId.inter`'s x-height-to-em-square aspect — duplicated from
/// `fontSizeFactorPresets.referenceXHeightAspect` in
/// `lib/shared/theme/app_font_presets.dart` rather than imported, since
/// importing anything under `package:worth_loop/` here drags in the
/// full pubspec dependency graph (including `sqlite3_flutter_libs`' FFI
/// native-asset build hooks), which crashes plain `dart run` on this
/// toolchain. `test/tool/font_metrics_test.dart` asserts the two stay equal,
/// so drift between them fails a test rather than silently diverging.
const double referenceXHeightAspect = 1118 / 2048;

/// A font file's `head`/`OS/2` sfnt metrics — the same data CSS's
/// `font-size-adjust` uses to normalize fonts with different
/// x-height-to-em-square ratios.
class FontMetrics {
  final int unitsPerEm;

  /// `null` if the font's `OS/2` table version is too old (<2) to carry
  /// `sxHeight` — happens for a handful of display faces (see
  /// `fontSizeFactorPresets`'s bundled fonts for real examples).
  final int? xHeight;

  const FontMetrics({required this.unitsPerEm, this.xHeight});

  /// x-height as a fraction of the em square — the aspect value
  /// `fontSizeFactorPresets` corrections are derived from.
  double? get xHeightAspect => xHeight == null ? null : xHeight! / unitsPerEm;
}

/// Reads [FontMetrics] straight out of `fontFile`'s sfnt table directory —
/// no font-parsing package dependency needed for two integers.
FontMetrics readFontMetrics(File fontFile) {
  final Uint8List bytes = fontFile.readAsBytesSync();
  final ByteData data = ByteData.sublistView(bytes);

  final bool isCollection =
      bytes[0] == 0x74 &&
      bytes[1] == 0x74 &&
      bytes[2] == 0x63 &&
      bytes[3] == 0x66;
  final int base = isCollection ? data.getUint32(12) : 0;

  final int numTables = data.getUint16(base + 4);
  int? headOffset;
  int? os2Offset;
  int? os2Length;
  for (int i = 0; i < numTables; i++) {
    final int recordOffset = base + 12 + i * 16;
    final String tag = String.fromCharCodes(
      bytes.sublist(recordOffset, recordOffset + 4),
    );
    final int offset = data.getUint32(recordOffset + 8);
    final int length = data.getUint32(recordOffset + 12);
    if (tag == 'head') {
      headOffset = offset;
    }
    if (tag == 'OS/2') {
      os2Offset = offset;
      os2Length = length;
    }
  }

  if (headOffset == null) {
    throw FormatException('${fontFile.path} has no head table');
  }
  final int unitsPerEm = data.getUint16(headOffset + 18);

  int? xHeight;
  if (os2Offset != null && os2Length != null) {
    final int version = data.getUint16(os2Offset);
    if (version >= 2 && os2Length >= 90) {
      xHeight = data.getInt16(os2Offset + 86);
    }
  }

  return FontMetrics(unitsPerEm: unitsPerEm, xHeight: xHeight);
}

/// The `fontSizeFactorPresets` correction factor for a font whose x-height
/// aspect is `xHeightAspect` — `referenceXHeightAspect / xHeightAspect`,
/// rounded to 2 decimals (matching every existing entry's precision).
double fontSizeFactorFor(double xHeightAspect) {
  final double factor = referenceXHeightAspect / xHeightAspect;
  return (factor * 100).round() / 100;
}

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/font_metrics.dart <font-file.ttf> [more files...]',
    );
    exit(1);
  }

  for (final String path in args) {
    final FontMetrics metrics = readFontMetrics(File(path));
    final double? aspect = metrics.xHeightAspect;
    if (aspect == null) {
      stdout.writeln(
        '$path: no sxHeight in OS/2 table (version too old) — eyeball this '
        'one manually against fontSizeFactorPresets\' existing entries',
      );
      continue;
    }
    stdout.writeln(
      '$path: xHeight/em=${aspect.toStringAsFixed(4)} → '
      'fontSizeFactor=${fontSizeFactorFor(aspect)}',
    );
  }
}
