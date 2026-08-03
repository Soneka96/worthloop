// Flutter imports:
import 'package:flutter/material.dart';

/// Catppuccin Latte theme preset — light pastel palette. See
/// https://catppuccin.com/palette for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme catppuccinLatteColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1E66F5), // Blue
  onPrimary: Color(0xFFEFF1F5), // Base
  primaryContainer: Color(0xFFCCD0DA), // Surface0
  onPrimaryContainer: Color(0xFF4C4F69), // Text
  secondary: Color(0xFF8839EF), // Mauve
  onSecondary: Color(0xFFEFF1F5), // Base
  secondaryContainer: Color(0xFFCCD0DA), // Surface0
  onSecondaryContainer: Color(0xFF4C4F69), // Text
  tertiary: Color(0xFFEA76CB), // Pink
  onTertiary: Color(0xFFEFF1F5), // Base
  tertiaryContainer: Color(0xFFCCD0DA), // Surface0
  onTertiaryContainer: Color(0xFF4C4F69), // Text
  error: Color(0xFFD20F39), // Red
  onError: Color(0xFFEFF1F5), // Base
  errorContainer: Color(0xFFCCD0DA), // Surface0
  onErrorContainer: Color(0xFF4C4F69), // Text
  surface: Color(0xFFEFF1F5), // Base
  onSurface: Color(0xFF4C4F69), // Text
  onSurfaceVariant: Color(0xFF6C6F85), // Subtext0
  surfaceContainerHighest: Color(0xFFCCD0DA), // Surface0
  outline: Color(0xFF6C6F85), // Subtext0
  outlineVariant: Color(0xFFCCD0DA), // Surface0
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF4C4F69), // Text
  onInverseSurface: Color(0xFFEFF1F5), // Base
  inversePrimary: Color(0xFFCCD0DA), // Surface0
  surfaceTint: Color(0xFF1E66F5), // Blue
);
