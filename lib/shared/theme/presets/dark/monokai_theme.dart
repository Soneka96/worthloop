// Flutter imports:
import 'package:flutter/material.dart';

/// Monokai theme preset — the classic high-saturation editor palette
/// originally created by Wimer Hazenberg. Every [ColorScheme] slot below is
/// hand-mapped from it so no slot falls back to Flutter's stock Material
/// defaults.
const ColorScheme monokaiColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF66D9EF), // Cyan
  onPrimary: Color(0xFF272822), // Background
  primaryContainer: Color(0xFF45443A), // Lifted cyan surface
  onPrimaryContainer: Color(0xFFF8F8F2), // Foreground
  secondary: Color(0xFFAE81FF), // Purple
  onSecondary: Color(0xFF272822), // Background
  secondaryContainer: Color(0xFF46394B), // Lifted purple surface
  onSecondaryContainer: Color(0xFFF8F8F2), // Foreground
  tertiary: Color(0xFFA6E22E), // Green
  onTertiary: Color(0xFF272822), // Background
  tertiaryContainer: Color(0xFF344534), // Lifted green surface
  onTertiaryContainer: Color(0xFFF8F8F2), // Foreground
  error: Color(0xFFFF4D8A), // Brighter magenta for controls
  onError: Color(0xFF272822), // Background
  errorContainer: Color(0xFF552C3B), // Lifted magenta surface
  onErrorContainer: Color(0xFFF8F8F2), // Foreground
  surface: Color(0xFF272822), // Background
  onSurface: Color(0xFFF8F8F2), // Foreground
  onSurfaceVariant: Color(0xFFBDBA9E), // Accessible muted olive
  surfaceContainerHighest: Color(0xFF3E3D32), // Current line
  outline: Color(0xFFBDBA9E), // Accessible muted olive
  outlineVariant: Color(0xFF8E8A70), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFF8F8F2), // Foreground
  onInverseSurface: Color(0xFF272822), // Background
  inversePrimary: Color(0xFF3C98A9), // Darker cyan for inverse surfaces
  surfaceTint: Color(0xFF66D9EF), // Cyan
);
