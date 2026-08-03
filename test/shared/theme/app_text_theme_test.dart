// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/theme/app_text_theme.dart';
import 'package:worth_loop/shared/theme/presets/dark/dracula_theme.dart';
import 'package:worth_loop/shared/theme/presets/light/catppuccin_latte_theme.dart';

void main() {
  group('buildAppTextTheme behaves correctly', () {
    test(
      'buildAppTextTheme returns a TextTheme with headlineSmall.fontWeight = FontWeight.bold',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.headlineSmall?.fontWeight, FontWeight.bold);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with labelSmall.letterSpacing = 1.2',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.labelSmall?.letterSpacing, 1.2);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with labelSmall.fontWeight = FontWeight.w600',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.labelSmall?.fontWeight, FontWeight.w600);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with labelSmall.color = colorScheme.primary when colorScheme = draculaColorScheme',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.labelSmall?.color, draculaColorScheme.primary);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with labelSmall.color = colorScheme.primary when colorScheme = catppuccinLatteColorScheme',
      () {
        final TextTheme result = buildAppTextTheme(catppuccinLatteColorScheme);

        expect(result.labelSmall?.color, catppuccinLatteColorScheme.primary);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with headlineSmall.color = colorScheme.onSurface',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.headlineSmall?.color, draculaColorScheme.onSurface);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with bodyMedium.color = colorScheme.onSurface',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.bodyMedium?.color, draculaColorScheme.onSurface);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with bodySmall.color = colorScheme.onSurfaceVariant',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.bodySmall?.color, draculaColorScheme.onSurfaceVariant);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with displayLarge.color = colorScheme.onSurface',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.displayLarge?.color, draculaColorScheme.onSurface);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with titleMedium.color = colorScheme.onSurface',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.titleMedium?.color, draculaColorScheme.onSurface);
      },
    );

    test(
      'buildAppTextTheme returns a TextTheme with labelMedium.color = colorScheme.onSurface',
      () {
        final TextTheme result = buildAppTextTheme(draculaColorScheme);

        expect(result.labelMedium?.color, draculaColorScheme.onSurface);
      },
    );
  });
}
