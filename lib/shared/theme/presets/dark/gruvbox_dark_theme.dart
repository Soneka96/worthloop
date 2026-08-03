// Flutter imports:
import 'package:flutter/material.dart';

/// Gruvbox Dark theme preset — retro, warm-contrast palette. See
/// https://github.com/morhetz/gruvbox for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme gruvboxDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF83A598), // Blue (bright)
  onPrimary: Color(0xFF282828), // Dark0
  primaryContainer: Color(0xFF3C3836), // Dark1
  onPrimaryContainer: Color(0xFFEBDBB2), // Light1
  secondary: Color(0xFFD3869B), // Purple (bright)
  onSecondary: Color(0xFF282828), // Dark0
  secondaryContainer: Color(0xFF3C3836), // Dark1
  onSecondaryContainer: Color(0xFFEBDBB2), // Light1
  tertiary: Color(0xFF8EC07C), // Aqua (bright)
  onTertiary: Color(0xFF282828), // Dark0
  tertiaryContainer: Color(0xFF3C3836), // Dark1
  onTertiaryContainer: Color(0xFFEBDBB2), // Light1
  error: Color(0xFFFB4934), // Red (bright)
  onError: Color(0xFF282828), // Dark0
  errorContainer: Color(0xFF3C3836), // Dark1
  onErrorContainer: Color(0xFFEBDBB2), // Light1
  surface: Color(0xFF282828), // Dark0
  onSurface: Color(0xFFEBDBB2), // Light1
  onSurfaceVariant: Color(0xFF928374), // Gray
  surfaceContainerHighest: Color(0xFF3C3836), // Dark1
  outline: Color(0xFF928374), // Gray
  outlineVariant: Color(0xFF3C3836), // Dark1
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFEBDBB2), // Light1
  onInverseSurface: Color(0xFF282828), // Dark0
  inversePrimary: Color(0xFF3C3836), // Dark1
  surfaceTint: Color(0xFF83A598), // Blue (bright)
);
