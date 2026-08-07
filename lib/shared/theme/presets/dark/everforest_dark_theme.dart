// Flutter imports:
import 'package:flutter/material.dart';

/// Everforest Dark theme preset — green, forest-inspired palette (medium
/// contrast). See https://github.com/sainnhe/everforest/blob/master/palette.md
/// for the canonical palette; every [ColorScheme] slot below is hand-mapped
/// from it so no slot falls back to Flutter's stock Material defaults.
const ColorScheme everforestDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7FBBB3), // Blue
  onPrimary: Color(0xFF2D353B), // Bg0
  primaryContainer: Color(0xFF35443F), // Lifted blue-green surface
  onPrimaryContainer: Color(0xFFD3C6AA), // Fg
  secondary: Color(0xFFD699B6), // Purple
  onSecondary: Color(0xFF2D353B), // Bg0
  secondaryContainer: Color(0xFF463B43), // Lifted purple surface
  onSecondaryContainer: Color(0xFFD3C6AA), // Fg
  tertiary: Color(0xFF83C092), // Aqua
  onTertiary: Color(0xFF2D353B), // Bg0
  tertiaryContainer: Color(0xFF2E4945), // Lifted aqua surface
  onTertiaryContainer: Color(0xFFD3C6AA), // Fg
  error: Color(0xFFE67E80), // Red
  onError: Color(0xFF2D353B), // Bg0
  errorContainer: Color(0xFF4A3034), // Lifted red surface
  onErrorContainer: Color(0xFFD3C6AA), // Fg
  surface: Color(0xFF2D353B), // Bg0
  onSurface: Color(0xFFD3C6AA), // Fg
  onSurfaceVariant: Color(0xFFA7B8A6), // Accessible muted green-grey
  surfaceContainerHighest: Color(0xFF343F44), // Bg1
  outline: Color(0xFFA7B8A6), // Accessible muted green-grey
  outlineVariant: Color(0xFF718B82), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFD3C6AA), // Fg
  onInverseSurface: Color(0xFF2D353B), // Bg0
  inversePrimary: Color(0xFF4D8A82), // Darker blue-green for inverse surfaces
  surfaceTint: Color(0xFF7FBBB3), // Blue
);
