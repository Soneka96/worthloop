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
  primaryContainer: Color(0xFFE2D2AA), // Lifted blue surface
  onPrimaryContainer: Color(0xFF3C3836), // Dark1
  secondary: Color(0xFF8F3F71), // Purple (faded)
  onSecondary: Color(0xFFFBF1C7), // Light0
  secondaryContainer: Color(0xFFE8D3DF), // Lifted purple surface
  onSecondaryContainer: Color(0xFF3C3836), // Dark1
  tertiary: Color(0xFF356644), // Darker aqua for controls
  onTertiary: Color(0xFFFBF1C7), // Light0
  tertiaryContainer: Color(0xFFDDE8D7), // Lifted green surface
  onTertiaryContainer: Color(0xFF3C3836), // Dark1
  error: Color(0xFF9D0006), // Red (faded)
  onError: Color(0xFFFBF1C7), // Light0
  errorContainer: Color(0xFFF2C9C4), // Lifted red surface
  onErrorContainer: Color(0xFF3C3836), // Dark1
  surface: Color(0xFFFBF1C7), // Light0
  onSurface: Color(0xFF3C3836), // Dark1
  onSurfaceVariant: Color(0xFF62584D), // Accessible muted brown
  surfaceContainerHighest: Color(0xFFEBDBB2), // Light1
  outline: Color(0xFF62584D), // Accessible muted brown
  outlineVariant: Color(0xFF877A63), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF3C3836), // Dark1
  onInverseSurface: Color(0xFFFBF1C7), // Light0
  inversePrimary: Color(0xFF0A5365), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF076678), // Blue (faded)
);
