// Flutter imports:
import 'package:flutter/material.dart';

/// One Light theme preset — Atom/VS Code-style light theme, sibling of
/// [oneDarkProColorScheme]. See
/// https://github.com/atom/atom/tree/master/packages/one-light-syntax for
/// the canonical palette; every [ColorScheme] slot below is hand-mapped from
/// it so no slot falls back to Flutter's stock Material defaults.
const ColorScheme oneLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2F5FC2), // Darker blue for controls
  onPrimary: Color(0xFFFAFAFA), // Background
  primaryContainer: Color(0xFFE4ECFC), // Lifted blue surface
  onPrimaryContainer: Color(0xFF383A42), // Foreground
  secondary: Color(0xFF8E218E), // Darker purple for controls
  onSecondary: Color(0xFFFAFAFA), // Background
  secondaryContainer: Color(0xFFF2DDF0), // Lifted purple surface
  onSecondaryContainer: Color(0xFF383A42), // Foreground
  tertiary: Color(0xFF2F7F35), // Darker green for controls
  onTertiary: Color(0xFFFAFAFA), // Background
  tertiaryContainer: Color(0xFFE1F0E1), // Lifted green surface
  onTertiaryContainer: Color(0xFF383A42), // Foreground
  error: Color(0xFFE45649), // Red
  onError: Color(0xFF3A1110), // Accessible dark text
  errorContainer: Color(0xFFF9D9D5), // Lifted red surface
  onErrorContainer: Color(0xFF383A42), // Foreground
  surface: Color(0xFFFAFAFA), // Background
  onSurface: Color(0xFF383A42), // Foreground
  onSurfaceVariant: Color(0xFF5C5F67), // Accessible muted grey
  surfaceContainerHighest: Color(0xFFF0F0F1), // Panel
  outline: Color(0xFF5C5F67), // Accessible muted grey
  outlineVariant: Color(0xFF7C7F86), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF383A42), // Foreground
  onInverseSurface: Color(0xFFFAFAFA), // Background
  inversePrimary: Color(0xFF2F5EC4), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF4078F2), // Blue
);
