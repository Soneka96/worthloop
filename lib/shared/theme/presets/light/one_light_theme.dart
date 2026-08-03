// Flutter imports:
import 'package:flutter/material.dart';

/// One Light theme preset — Atom/VS Code-style light theme, sibling of
/// [oneDarkProColorScheme]. See
/// https://github.com/atom/atom/tree/master/packages/one-light-syntax for
/// the canonical palette; every [ColorScheme] slot below is hand-mapped from
/// it so no slot falls back to Flutter's stock Material defaults.
const ColorScheme oneLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF4078F2), // Blue
  onPrimary: Color(0xFFFAFAFA), // Background
  primaryContainer: Color(0xFFF0F0F1), // Panel
  onPrimaryContainer: Color(0xFF383A42), // Foreground
  secondary: Color(0xFFA626A4), // Purple
  onSecondary: Color(0xFFFAFAFA), // Background
  secondaryContainer: Color(0xFFF0F0F1), // Panel
  onSecondaryContainer: Color(0xFF383A42), // Foreground
  tertiary: Color(0xFF50A14F), // Green
  onTertiary: Color(0xFFFAFAFA), // Background
  tertiaryContainer: Color(0xFFF0F0F1), // Panel
  onTertiaryContainer: Color(0xFF383A42), // Foreground
  error: Color(0xFFE45649), // Red
  onError: Color(0xFFFAFAFA), // Background
  errorContainer: Color(0xFFF0F0F1), // Panel
  onErrorContainer: Color(0xFF383A42), // Foreground
  surface: Color(0xFFFAFAFA), // Background
  onSurface: Color(0xFF383A42), // Foreground
  onSurfaceVariant: Color(0xFFA0A1A7), // Comment
  surfaceContainerHighest: Color(0xFFF0F0F1), // Panel
  outline: Color(0xFFA0A1A7), // Comment
  outlineVariant: Color(0xFFF0F0F1), // Panel
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF383A42), // Foreground
  onInverseSurface: Color(0xFFFAFAFA), // Background
  inversePrimary: Color(0xFFF0F0F1), // Panel
  surfaceTint: Color(0xFF4078F2), // Blue
);
