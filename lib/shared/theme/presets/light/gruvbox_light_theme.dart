// Flutter imports:
import 'package:flutter/material.dart';

/// Gruvbox Light theme preset — retro, warm-contrast palette. See
/// https://github.com/morhetz/gruvbox for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme gruvboxLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF076678), // Blue (faded)
  onPrimary: Color(0xFFFBF1C7), // Light0
  primaryContainer: Color(0xFFEBDBB2), // Light1
  onPrimaryContainer: Color(0xFF3C3836), // Dark1
  secondary: Color(0xFF8F3F71), // Purple (faded)
  onSecondary: Color(0xFFFBF1C7), // Light0
  secondaryContainer: Color(0xFFEBDBB2), // Light1
  onSecondaryContainer: Color(0xFF3C3836), // Dark1
  tertiary: Color(0xFF427B58), // Aqua (faded)
  onTertiary: Color(0xFFFBF1C7), // Light0
  tertiaryContainer: Color(0xFFEBDBB2), // Light1
  onTertiaryContainer: Color(0xFF3C3836), // Dark1
  error: Color(0xFF9D0006), // Red (faded)
  onError: Color(0xFFFBF1C7), // Light0
  errorContainer: Color(0xFFEBDBB2), // Light1
  onErrorContainer: Color(0xFF3C3836), // Dark1
  surface: Color(0xFFFBF1C7), // Light0
  onSurface: Color(0xFF3C3836), // Dark1
  onSurfaceVariant: Color(0xFF928374), // Gray
  surfaceContainerHighest: Color(0xFFEBDBB2), // Light1
  outline: Color(0xFF928374), // Gray
  outlineVariant: Color(0xFFEBDBB2), // Light1
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF3C3836), // Dark1
  onInverseSurface: Color(0xFFFBF1C7), // Light0
  inversePrimary: Color(0xFFEBDBB2), // Light1
  surfaceTint: Color(0xFF076678), // Blue (faded)
);
