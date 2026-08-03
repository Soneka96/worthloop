// Flutter imports:
import 'package:flutter/material.dart';

/// Dracula theme preset — dark purple/grey palette with high-contrast
/// accent colours. See https://draculatheme.com/contribute for the
/// canonical palette; every [ColorScheme] slot below is hand-mapped from it
/// so no slot falls back to Flutter's stock Material defaults.
const ColorScheme draculaColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFBD93F9), // Purple
  onPrimary: Color(0xFF282A36), // Background
  primaryContainer: Color(0xFF44475A), // Current Line
  onPrimaryContainer: Color(0xFFF8F8F2), // Foreground
  secondary: Color(0xFFFF79C6), // Pink
  onSecondary: Color(0xFF282A36), // Background
  secondaryContainer: Color(0xFF44475A), // Current Line
  onSecondaryContainer: Color(0xFFF8F8F2), // Foreground
  tertiary: Color(0xFF8BE9FD), // Cyan
  onTertiary: Color(0xFF282A36), // Background
  tertiaryContainer: Color(0xFF44475A), // Current Line
  onTertiaryContainer: Color(0xFFF8F8F2), // Foreground
  error: Color(0xFFFF5555), // Red
  onError: Color(0xFF282A36), // Background
  errorContainer: Color(0xFF44475A), // Current Line
  onErrorContainer: Color(0xFFF8F8F2), // Foreground
  surface: Color(0xFF282A36), // Background
  onSurface: Color(0xFFF8F8F2), // Foreground
  onSurfaceVariant: Color(0xFF6272A4), // Comment
  surfaceContainerHighest: Color(0xFF44475A), // Current Line
  outline: Color(0xFF6272A4), // Comment
  outlineVariant: Color(0xFF44475A), // Current Line
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFF8F8F2), // Foreground
  onInverseSurface: Color(0xFF282A36), // Background
  inversePrimary: Color(0xFF44475A), // Current Line
  surfaceTint: Color(0xFFBD93F9), // Purple
);
