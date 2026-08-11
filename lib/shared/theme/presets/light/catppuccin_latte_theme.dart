// Flutter imports:
import 'package:flutter/material.dart';

/// Catppuccin Latte theme preset — light pastel palette. See
/// https://catppuccin.com/palette for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme catppuccinLatteColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1B5CC7), // Darker blue for controls
  onPrimary: Color(0xFFEFF1F5), // Base
  primaryContainer: Color(0xFFDDE4F5), // Lifted blue surface
  onPrimaryContainer: Color(0xFF4C4F69), // Text
  secondary: Color(0xFF8839EF), // Mauve
  onSecondary: Color(0xFFEFF1F5), // Base
  secondaryContainer: Color(0xFFE8DDF8), // Lifted mauve surface
  onSecondaryContainer: Color(0xFF4C4F69), // Text
  tertiary: Color(0xFFEA76CB), // Pink
  onTertiary: Color(0xFF4A173C), // Accessible dark text
  tertiaryContainer: Color(0xFFF4DCEB), // Lifted pink surface
  onTertiaryContainer: Color(0xFF4C4F69), // Text
  error: Color(0xFFD20F39), // Red
  onError: Color(0xFFEFF1F5), // Base
  errorContainer: Color(0xFFF5D9E0), // Lifted red surface
  onErrorContainer: Color(0xFF4C4F69), // Text
  surface: Color(0xFFEFF1F5), // Base
  onSurface: Color(0xFF4C4F69), // Text
  onSurfaceVariant: Color(0xFF5A6078), // Accessible muted blue-grey
  surfaceContainerHighest: Color(0xFFCCD0DA), // Surface0
  outline: Color(0xFF5A6078), // Accessible muted blue-grey
  outlineVariant: Color(0xFF566581), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF4C4F69), // Text
  onInverseSurface: Color(0xFFEFF1F5), // Base
  inversePrimary: Color(0xFF5C72C5), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF1E66F5), // Blue
);
