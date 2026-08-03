// Flutter imports:
import 'package:flutter/material.dart';

/// Everforest Light theme preset — green, forest-inspired palette (medium
/// contrast). See https://github.com/sainnhe/everforest/blob/master/palette.md
/// for the canonical palette; every [ColorScheme] slot below is hand-mapped
/// from it so no slot falls back to Flutter's stock Material defaults.
const ColorScheme everforestLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3A94C5), // Blue
  onPrimary: Color(0xFFFDF6E3), // Bg0
  primaryContainer: Color(0xFFF4F0D9), // Bg1
  onPrimaryContainer: Color(0xFF5C6A72), // Fg
  secondary: Color(0xFFDF69BA), // Purple
  onSecondary: Color(0xFFFDF6E3), // Bg0
  secondaryContainer: Color(0xFFF4F0D9), // Bg1
  onSecondaryContainer: Color(0xFF5C6A72), // Fg
  tertiary: Color(0xFF35A77C), // Aqua
  onTertiary: Color(0xFFFDF6E3), // Bg0
  tertiaryContainer: Color(0xFFF4F0D9), // Bg1
  onTertiaryContainer: Color(0xFF5C6A72), // Fg
  error: Color(0xFFF85552), // Red
  onError: Color(0xFFFDF6E3), // Bg0
  errorContainer: Color(0xFFF4F0D9), // Bg1
  onErrorContainer: Color(0xFF5C6A72), // Fg
  surface: Color(0xFFFDF6E3), // Bg0
  onSurface: Color(0xFF5C6A72), // Fg
  onSurfaceVariant: Color(0xFF939F91), // Grey1
  surfaceContainerHighest: Color(0xFFF4F0D9), // Bg1
  outline: Color(0xFF939F91), // Grey1
  outlineVariant: Color(0xFFF4F0D9), // Bg1
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF5C6A72), // Fg
  onInverseSurface: Color(0xFFFDF6E3), // Bg0
  inversePrimary: Color(0xFFF4F0D9), // Bg1
  surfaceTint: Color(0xFF3A94C5), // Blue
);
