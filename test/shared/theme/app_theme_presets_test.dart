// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_theme_presets.dart';
import 'package:worth_loop/shared/theme/presets/dark/slugger_dark_theme.dart';

double contrastRatio(Color foreground, Color background) {
  final double foregroundLuminance = foreground.computeLuminance();
  final double backgroundLuminance = background.computeLuminance();
  final double lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final double darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('themePresets behaves correctly', () {
    test('themePresets has an entry for every ThemeId', () {
      for (final ThemeId themeId in ThemeId.values) {
        expect(
          themePresets.containsKey(themeId),
          isTrue,
          reason: 'missing preset entry for $themeId',
        );
      }
    });
  });

  group('sluggerDarkColorScheme behaves correctly', () {
    test('uses distinct state containers', () {
      final Set<Color> stateContainers = {
        sluggerDarkColorScheme.primaryContainer,
        sluggerDarkColorScheme.secondaryContainer,
        sluggerDarkColorScheme.tertiaryContainer,
        sluggerDarkColorScheme.errorContainer,
      };

      expect(stateContainers.length, 4);
    });

    test('is registered as the dark preset', () {
      expect(themePresets[ThemeId.sluggerDark], sluggerDarkColorScheme);
      expect(sluggerDarkColorScheme.brightness, Brightness.dark);
    });

    test('has accessible text on every state container', () {
      final List<Color> stateContainers = [
        sluggerDarkColorScheme.primaryContainer,
        sluggerDarkColorScheme.secondaryContainer,
        sluggerDarkColorScheme.tertiaryContainer,
        sluggerDarkColorScheme.errorContainer,
      ];

      for (final Color container in stateContainers) {
        expect(
          contrastRatio(sluggerDarkColorScheme.onSurfaceVariant, container),
          greaterThanOrEqualTo(4.5),
        );
      }
    });

    test('has accessible contrast for paired semantic roles', () {
      final List<({Color background, Color foreground})> pairs = [
        (
          foreground: sluggerDarkColorScheme.onPrimary,
          background: sluggerDarkColorScheme.primary,
        ),
        (
          foreground: sluggerDarkColorScheme.onSecondary,
          background: sluggerDarkColorScheme.secondary,
        ),
        (
          foreground: sluggerDarkColorScheme.onTertiary,
          background: sluggerDarkColorScheme.tertiary,
        ),
        (
          foreground: sluggerDarkColorScheme.onError,
          background: sluggerDarkColorScheme.error,
        ),
        (
          foreground: sluggerDarkColorScheme.onSurface,
          background: sluggerDarkColorScheme.surface,
        ),
        (
          foreground: sluggerDarkColorScheme.onPrimaryContainer,
          background: sluggerDarkColorScheme.primaryContainer,
        ),
        (
          foreground: sluggerDarkColorScheme.onSecondaryContainer,
          background: sluggerDarkColorScheme.secondaryContainer,
        ),
        (
          foreground: sluggerDarkColorScheme.onTertiaryContainer,
          background: sluggerDarkColorScheme.tertiaryContainer,
        ),
        (
          foreground: sluggerDarkColorScheme.onErrorContainer,
          background: sluggerDarkColorScheme.errorContainer,
        ),
      ];

      for (final ({Color background, Color foreground}) pair in pairs) {
        expect(
          contrastRatio(pair.foreground, pair.background),
          greaterThanOrEqualTo(4.5),
        );
      }
    });

    test('keeps the outline visibly separate from state containers', () {
      expect(
        sluggerDarkColorScheme.outlineVariant,
        isNot(sluggerDarkColorScheme.surfaceContainerHighest),
      );
      expect(
        contrastRatio(
          sluggerDarkColorScheme.outlineVariant,
          sluggerDarkColorScheme.surface,
        ),
        greaterThanOrEqualTo(3),
      );
    });
  });

  group('hand-authored dark presets behave correctly', () {
    final Iterable<MapEntry<ThemeId, ColorScheme>> darkPresets = themePresets
        .entries
        .where(
          (MapEntry<ThemeId, ColorScheme> entry) =>
              entry.value.brightness == Brightness.dark &&
              entry.key != ThemeId.none &&
              entry.key != ThemeId.defaultDark,
        );

    test('uses distinct state containers', () {
      for (final MapEntry<ThemeId, ColorScheme> entry in darkPresets) {
        final ColorScheme colors = entry.value;
        expect(
          {
            colors.primaryContainer,
            colors.secondaryContainer,
            colors.tertiaryContainer,
            colors.errorContainer,
          }.length,
          4,
          reason: '${entry.key} reuses state containers',
        );
      }
    });

    test('has accessible metadata on every state container', () {
      for (final MapEntry<ThemeId, ColorScheme> entry in darkPresets) {
        final ColorScheme colors = entry.value;
        final List<Color> containers = [
          colors.primaryContainer,
          colors.secondaryContainer,
          colors.tertiaryContainer,
          colors.errorContainer,
        ];

        for (final Color container in containers) {
          expect(
            contrastRatio(colors.onSurfaceVariant, container),
            greaterThanOrEqualTo(4.5),
            reason: '${entry.key} has low metadata contrast on $container',
          );
        }
      }
    });

    test('keeps the outline visible against the base surface', () {
      for (final MapEntry<ThemeId, ColorScheme> entry in darkPresets) {
        final ColorScheme colors = entry.value;
        expect(
          colors.outlineVariant,
          isNot(colors.surfaceContainerHighest),
          reason: '${entry.key} reuses its panel color as outlineVariant',
        );
        expect(
          contrastRatio(colors.outlineVariant, colors.surface),
          greaterThanOrEqualTo(3),
          reason: '${entry.key} has a low-contrast outlineVariant',
        );
      }
    });

    test('has accessible paired semantic roles', () {
      for (final MapEntry<ThemeId, ColorScheme> entry in darkPresets) {
        final ColorScheme colors = entry.value;
        final List<({Color background, Color foreground})> pairs = [
          (foreground: colors.onPrimary, background: colors.primary),
          (foreground: colors.onSecondary, background: colors.secondary),
          (foreground: colors.onTertiary, background: colors.tertiary),
          (foreground: colors.onError, background: colors.error),
          (foreground: colors.onSurface, background: colors.surface),
          (
            foreground: colors.onPrimaryContainer,
            background: colors.primaryContainer,
          ),
          (
            foreground: colors.onSecondaryContainer,
            background: colors.secondaryContainer,
          ),
          (
            foreground: colors.onTertiaryContainer,
            background: colors.tertiaryContainer,
          ),
          (
            foreground: colors.onErrorContainer,
            background: colors.errorContainer,
          ),
        ];

        for (final ({Color background, Color foreground}) pair in pairs) {
          expect(
            contrastRatio(pair.foreground, pair.background),
            greaterThanOrEqualTo(4.5),
            reason: '${entry.key} has an inaccessible semantic pair',
          );
        }
      }
    });
  });
}
