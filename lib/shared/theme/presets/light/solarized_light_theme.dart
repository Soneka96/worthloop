// Flutter imports:
import 'package:flutter/material.dart';

/// Solarized Light theme preset — precision-engineered low-contrast
/// palette. See https://ethanschoonover.com/solarized/ for the canonical
/// palette; every [ColorScheme] slot below is hand-mapped from it so no slot
/// falls back to Flutter's stock Material defaults.
const ColorScheme solarizedLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF268BD2), // Blue
  onPrimary: Color(0xFFFDF6E3), // Base3
  primaryContainer: Color(0xFFEEE8D5), // Base2
  onPrimaryContainer: Color(0xFF657B83), // Base00
  secondary: Color(0xFF6C71C4), // Violet
  onSecondary: Color(0xFFFDF6E3), // Base3
  secondaryContainer: Color(0xFFEEE8D5), // Base2
  onSecondaryContainer: Color(0xFF657B83), // Base00
  tertiary: Color(0xFF2AA198), // Cyan
  onTertiary: Color(0xFFFDF6E3), // Base3
  tertiaryContainer: Color(0xFFEEE8D5), // Base2
  onTertiaryContainer: Color(0xFF657B83), // Base00
  error: Color(0xFFDC322F), // Red
  onError: Color(0xFFFDF6E3), // Base3
  errorContainer: Color(0xFFEEE8D5), // Base2
  onErrorContainer: Color(0xFF657B83), // Base00
  surface: Color(0xFFFDF6E3), // Base3
  onSurface: Color(0xFF657B83), // Base00
  onSurfaceVariant: Color(0xFF93A1A1), // Base1 (comments)
  surfaceContainerHighest: Color(0xFFEEE8D5), // Base2
  outline: Color(0xFF93A1A1), // Base1
  outlineVariant: Color(0xFFEEE8D5), // Base2
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF657B83), // Base00
  onInverseSurface: Color(0xFFFDF6E3), // Base3
  inversePrimary: Color(0xFFEEE8D5), // Base2
  surfaceTint: Color(0xFF268BD2), // Blue
);
