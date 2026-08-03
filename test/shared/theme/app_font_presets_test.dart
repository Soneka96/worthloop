// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_font_presets.dart';

void main() {
  group('fontFamilyPresets behaves correctly', () {
    test('fontFamilyPresets has an entry for every FontId', () {
      for (final FontId fontId in FontId.values) {
        expect(
          fontFamilyPresets.containsKey(fontId),
          isTrue,
          reason: 'missing preset entry for $fontId',
        );
      }
    });
  });

  group('fontSizeFactorPresets behaves correctly', () {
    test('fontSizeFactorPresets has an entry for every FontId', () {
      for (final FontId fontId in FontId.values) {
        expect(
          fontSizeFactorPresets.containsKey(fontId),
          isTrue,
          reason: 'missing size-factor entry for $fontId',
        );
      }
    });
  });

  group('applyFontFamily behaves correctly', () {
    const TextTheme base = TextTheme(bodyMedium: TextStyle(fontSize: 14));

    test(
      'applyFontFamily returns base unchanged when fontId = FontId.none',
      () {
        expect(applyFontFamily(base, FontId.none), base);
      },
    );

    test(
      'applyFontFamily returns base unchanged when fontId = FontId.systemDefault',
      () {
        expect(applyFontFamily(base, FontId.systemDefault), base);
      },
    );

    test(
      'applyFontFamily returns a TextTheme with fontFamily = Inter when fontId = FontId.inter',
      () {
        final TextTheme result = applyFontFamily(base, FontId.inter);

        expect(result.bodyMedium?.fontFamily, 'Inter');
      },
    );

    test(
      'applyFontFamily preserves the given TextTheme slot sizes when fontId = FontId.inter',
      () {
        final TextTheme result = applyFontFamily(base, FontId.inter);

        expect(result.bodyMedium?.fontSize, 14);
      },
    );
  });
}
