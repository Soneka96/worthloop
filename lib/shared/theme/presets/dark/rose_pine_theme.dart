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
  primaryContainer: Color(0xFF2D2A4B), // Lifted foam surface
  onPrimaryContainer: Color(0xFFE0DEF4), // Text
  secondary: Color(0xFFC4A7E7), // Iris
  onSecondary: Color(0xFF191724), // Base
  secondaryContainer: Color(0xFF3D2B48), // Lifted iris surface
  onSecondaryContainer: Color(0xFFE0DEF4), // Text
  tertiary: Color(0xFF3E8CAA), // Brighter pine for controls
  onTertiary: Color(0xFF191724), // Base
  tertiaryContainer: Color(0xFF223F4D), // Lifted pine surface
  onTertiaryContainer: Color(0xFFE0DEF4), // Text
  error: Color(0xFFEB6F92), // Love
  onError: Color(0xFF191724), // Base
  errorContainer: Color(0xFF4D2938), // Lifted love surface
  onErrorContainer: Color(0xFFE0DEF4), // Text
  surface: Color(0xFF191724), // Base
  onSurface: Color(0xFFE0DEF4), // Text
  onSurfaceVariant: Color(0xFFB7B1D0), // Accessible muted lavender
  surfaceContainerHighest: Color(0xFF26233A), // Overlay
  outline: Color(0xFFB7B1D0), // Accessible muted lavender
  outlineVariant: Color(0xFF716B9D), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFE0DEF4), // Text
  onInverseSurface: Color(0xFF191724), // Base
  inversePrimary: Color(0xFF5D8E99), // Darker foam for inverse surfaces
  surfaceTint: Color(0xFF9CCFD8), // Foam
);
