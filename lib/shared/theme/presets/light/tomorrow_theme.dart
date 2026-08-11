// Flutter imports:
import 'package:flutter/material.dart';

/// Tomorrow theme preset — Chris Kempson's clean, muted light palette. See
/// https://github.com/chriskempson/tomorrow-theme for the canonical palette;
/// every [ColorScheme] slot below is hand-mapped from it so no slot falls
/// back to Flutter's stock Material defaults.
const ColorScheme tomorrowColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF4271AE), // Blue
  onPrimary: Color(0xFFFFFFFF), // Background
  primaryContainer: Color(0xFFE4ECF8), // Lifted blue surface
  onPrimaryContainer: Color(0xFF4D4D4C), // Foreground
  secondary: Color(0xFF8959A8), // Purple
  onSecondary: Color(0xFFFFFFFF), // Background
  secondaryContainer: Color(0xFFEADFF1), // Lifted purple surface
  onSecondaryContainer: Color(0xFF4D4D4C), // Foreground
  tertiary: Color(0xFF2F7D82), // Darker cyan for controls
  onTertiary: Color(0xFFFFFFFF), // Background
  tertiaryContainer: Color(0xFFDCEFF0), // Lifted cyan surface
  onTertiaryContainer: Color(0xFF4D4D4C), // Foreground
  error: Color(0xFFC82829), // Red
  onError: Color(0xFFFFFFFF), // Background
  errorContainer: Color(0xFFF5D9D9), // Lifted red surface
  onErrorContainer: Color(0xFF4D4D4C), // Foreground
  surface: Color(0xFFFFFFFF), // Background
  onSurface: Color(0xFF4D4D4C), // Foreground
  onSurfaceVariant: Color(0xFF62635F), // Accessible muted grey
  surfaceContainerHighest: Color(0xFFEFEFEF), // Window/Line
  outline: Color(0xFF62635F), // Accessible muted grey
  outlineVariant: Color(0xFF838780), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF4D4D4C), // Foreground
  onInverseSurface: Color(0xFFFFFFFF), // Background
  inversePrimary: Color(0xFF315D94), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF4271AE), // Blue
);
