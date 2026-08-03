// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../../tool/font_metrics.dart' as font_metrics;

// Project imports:
import 'package:worth_loop/shared/theme/app_font_presets.dart'
    as app_font_presets;

void main() {
  group('referenceXHeightAspect behaves correctly', () {
    test(
      'referenceXHeightAspect stays equal to app_font_presets.referenceXHeightAspect',
      () {
        expect(
          font_metrics.referenceXHeightAspect,
          app_font_presets.referenceXHeightAspect,
          reason:
              'the tool duplicates this constant instead of importing it '
              '(see font_metrics.dart\'s doc comment) — this test is what '
              'keeps the two from silently drifting apart',
        );
      },
    );
  });

  group('Method readFontMetrics() returns the correct value', () {
    test(
      'Method readFontMetrics() reads Inter\'s unitsPerEm and xHeight from its OS/2 table',
      () {
        final font_metrics.FontMetrics metrics = font_metrics.readFontMetrics(
          File('assets/fonts/Inter[opsz,wght].ttf'),
        );

        expect(metrics.unitsPerEm, 2048);
        expect(metrics.xHeight, 1118);
      },
    );

    test(
      'Method readFontMetrics() reads Press Start 2P\'s unitsPerEm and xHeight from its OS/2 table',
      () {
        final font_metrics.FontMetrics metrics = font_metrics.readFontMetrics(
          File('assets/fonts/PressStart2P-Regular.ttf'),
        );

        expect(metrics.unitsPerEm, 1000);
        expect(metrics.xHeight, 750);
      },
    );
  });

  group('Getter xHeightAspect returns the correct value', () {
    test('Getter xHeightAspect returns xHeight divided by unitsPerEm', () {
      const font_metrics.FontMetrics metrics = font_metrics.FontMetrics(
        unitsPerEm: 1000,
        xHeight: 750,
      );

      expect(metrics.xHeightAspect, 0.75);
    });

    test('Getter xHeightAspect returns null when xHeight is null', () {
      const font_metrics.FontMetrics metrics = font_metrics.FontMetrics(
        unitsPerEm: 1000,
      );

      expect(metrics.xHeightAspect, isNull);
    });
  });

  group('Method fontSizeFactorFor() returns the correct value', () {
    test(
      'Method fontSizeFactorFor() returns 1.0 for the reference aspect itself',
      () {
        expect(
          font_metrics.fontSizeFactorFor(font_metrics.referenceXHeightAspect),
          1,
        );
      },
    );

    test(
      'Method fontSizeFactorFor() matches Press Start 2P\'s fontSizeFactorPresets entry',
      () {
        expect(font_metrics.fontSizeFactorFor(0.75), 0.73);
      },
    );

    test(
      'Method fontSizeFactorFor() matches Caveat\'s fontSizeFactorPresets entry',
      () {
        expect(font_metrics.fontSizeFactorFor(0.40), 1.36);
      },
    );
  });
}
