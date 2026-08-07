// Flutter imports:
import 'package:flutter/material.dart';

/// Ayu Light theme preset — bright, warm-accent palette. See
/// https://github.com/ayu-theme/ayu-colors for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme ayuLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF36A3D9), // Tag
  onPrimary: Color(0xFF123142), // Accessible dark text
  primaryContainer: Color(0xFFE0EEF3), // Lifted blue surface
  onPrimaryContainer: Color(0xFF3E5662), // Fg
  secondary: Color(0xFFA37ACC), // Constant
  onSecondary: Color(0xFF241635), // Accessible dark text
  secondaryContainer: Color(0xFFE8DFF1), // Lifted purple surface
  onSecondaryContainer: Color(0xFF4A3B57), // Fg
  tertiary: Color(0xFF4CBF99), // Regexp
  onTertiary: Color(0xFF123B31), // Accessible dark text
  tertiaryContainer: Color(0xFFDDF2EA), // Lifted green surface
  onTertiaryContainer: Color(0xFF315447), // Fg
  error: Color(0xFFFF5C5C), // Brighter red for controls
  onError: Color(0xFF5A1111), // Accessible dark text
  errorContainer: Color(0xFFF9DADA), // Lifted red surface
  onErrorContainer: Color(0xFF5A2A2A), // Fg
  surface: Color(0xFFFAFAFA), // Bg
  onSurface: Color(0xFF5C6773), // Fg
  onSurfaceVariant: Color(0xFF59656D), // Accessible muted blue-grey
  surfaceContainerHighest: Color(0xFFF0EEE4), // Selection
  outline: Color(0xFF59656D), // Accessible muted blue-grey
  outlineVariant: Color(0xFF7F8478), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF5C6773), // Fg
  onInverseSurface: Color(0xFFFAFAFA), // Bg
  inversePrimary: Color(0xFF267BA0), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF36A3D9), // Tag
);
