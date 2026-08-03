// Flutter imports:
import 'package:flutter/material.dart';

/// Ayu Light theme preset — bright, warm-accent palette. See
/// https://github.com/ayu-theme/ayu-colors for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme ayuLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF36A3D9), // Tag
  onPrimary: Color(0xFFFAFAFA), // Bg
  primaryContainer: Color(0xFFF0EEE4), // Selection
  onPrimaryContainer: Color(0xFF5C6773), // Fg
  secondary: Color(0xFFA37ACC), // Constant
  onSecondary: Color(0xFFFAFAFA), // Bg
  secondaryContainer: Color(0xFFF0EEE4), // Selection
  onSecondaryContainer: Color(0xFF5C6773), // Fg
  tertiary: Color(0xFF4CBF99), // Regexp
  onTertiary: Color(0xFFFAFAFA), // Bg
  tertiaryContainer: Color(0xFFF0EEE4), // Selection
  onTertiaryContainer: Color(0xFF5C6773), // Fg
  error: Color(0xFFFF3333), // Error
  onError: Color(0xFFFAFAFA), // Bg
  errorContainer: Color(0xFFF0EEE4), // Selection
  onErrorContainer: Color(0xFF5C6773), // Fg
  surface: Color(0xFFFAFAFA), // Bg
  onSurface: Color(0xFF5C6773), // Fg
  onSurfaceVariant: Color(0xFFABB0B6), // Comment
  surfaceContainerHighest: Color(0xFFF0EEE4), // Selection
  outline: Color(0xFFABB0B6), // Comment
  outlineVariant: Color(0xFFF0EEE4), // Selection
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF5C6773), // Fg
  onInverseSurface: Color(0xFFFAFAFA), // Bg
  inversePrimary: Color(0xFFF0EEE4), // Selection
  surfaceTint: Color(0xFF36A3D9), // Tag
);
