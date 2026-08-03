// Flutter imports:
import 'package:flutter/material.dart';

/// Rosé Pine theme preset — dark, soho-vibes palette. See
/// https://rosepinetheme.com/palette for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme rosePineColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9CCFD8), // Foam
  onPrimary: Color(0xFF191724), // Base
  primaryContainer: Color(0xFF26233A), // Overlay
  onPrimaryContainer: Color(0xFFE0DEF4), // Text
  secondary: Color(0xFFC4A7E7), // Iris
  onSecondary: Color(0xFF191724), // Base
  secondaryContainer: Color(0xFF26233A), // Overlay
  onSecondaryContainer: Color(0xFFE0DEF4), // Text
  tertiary: Color(0xFF31748F), // Pine
  onTertiary: Color(0xFF191724), // Base
  tertiaryContainer: Color(0xFF26233A), // Overlay
  onTertiaryContainer: Color(0xFFE0DEF4), // Text
  error: Color(0xFFEB6F92), // Love
  onError: Color(0xFF191724), // Base
  errorContainer: Color(0xFF26233A), // Overlay
  onErrorContainer: Color(0xFFE0DEF4), // Text
  surface: Color(0xFF191724), // Base
  onSurface: Color(0xFFE0DEF4), // Text
  onSurfaceVariant: Color(0xFF6E6A86), // Muted
  surfaceContainerHighest: Color(0xFF26233A), // Overlay
  outline: Color(0xFF6E6A86), // Muted
  outlineVariant: Color(0xFF26233A), // Overlay
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE0DEF4), // Text
  onInverseSurface: Color(0xFF191724), // Base
  inversePrimary: Color(0xFF26233A), // Overlay
  surfaceTint: Color(0xFF9CCFD8), // Foam
);
