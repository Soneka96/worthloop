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
  primaryContainer: Color(0xFF463B32), // Lifted blue-green surface
  onPrimaryContainer: Color(0xFFEBDBB2), // Light1
  secondary: Color(0xFFD3869B), // Purple (bright)
  onSecondary: Color(0xFF282828), // Dark0
  secondaryContainer: Color(0xFF4A3540), // Lifted purple surface
  onSecondaryContainer: Color(0xFFEBDBB2), // Light1
  tertiary: Color(0xFF8EC07C), // Aqua (bright)
  onTertiary: Color(0xFF282828), // Dark0
  tertiaryContainer: Color(0xFF34463A), // Lifted aqua surface
  onTertiaryContainer: Color(0xFFEBDBB2), // Light1
  error: Color(0xFFFF5A45), // Brighter red for controls
  onError: Color(0xFF282828), // Dark0
  errorContainer: Color(0xFF5A2E27), // Lifted red surface
  onErrorContainer: Color(0xFFEBDBB2), // Light1
  surface: Color(0xFF282828), // Dark0
  onSurface: Color(0xFFEBDBB2), // Light1
  onSurfaceVariant: Color(0xFFC2B39E), // Accessible muted tan
  surfaceContainerHighest: Color(0xFF3C3836), // Dark1
  outline: Color(0xFFC2B39E), // Accessible muted tan
  outlineVariant: Color(0xFF927A63), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFEBDBB2), // Light1
  onInverseSurface: Color(0xFF282828), // Dark0
  inversePrimary: Color(0xFF527A73), // Darker blue-green for inverse surfaces
  surfaceTint: Color(0xFF83A598), // Blue (bright)
);
