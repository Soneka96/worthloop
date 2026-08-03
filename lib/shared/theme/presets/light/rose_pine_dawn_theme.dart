// Flutter imports:
import 'package:flutter/material.dart';

/// Rosé Pine Dawn theme preset — light, soho-vibes palette. See
/// https://rosepinetheme.com/palette for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme rosePineDawnColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF286983), // Pine
  onPrimary: Color(0xFFFAF4ED), // Base
  primaryContainer: Color(0xFFF2E9E1), // Overlay
  onPrimaryContainer: Color(0xFF464261), // Text
  secondary: Color(0xFF907AA9), // Iris
  onSecondary: Color(0xFFFAF4ED), // Base
  secondaryContainer: Color(0xFFF2E9E1), // Overlay
  onSecondaryContainer: Color(0xFF464261), // Text
  tertiary: Color(0xFF56949F), // Foam
  onTertiary: Color(0xFFFAF4ED), // Base
  tertiaryContainer: Color(0xFFF2E9E1), // Overlay
  onTertiaryContainer: Color(0xFF464261), // Text
  error: Color(0xFFB4637A), // Love
  onError: Color(0xFFFAF4ED), // Base
  errorContainer: Color(0xFFF2E9E1), // Overlay
  onErrorContainer: Color(0xFF464261), // Text
  surface: Color(0xFFFAF4ED), // Base
  onSurface: Color(0xFF464261), // Text
  onSurfaceVariant: Color(0xFF9893A5), // Muted
  surfaceContainerHighest: Color(0xFFF2E9E1), // Overlay
  outline: Color(0xFF9893A5), // Muted
  outlineVariant: Color(0xFFF2E9E1), // Overlay
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF464261), // Text
  onInverseSurface: Color(0xFFFAF4ED), // Base
  inversePrimary: Color(0xFFF2E9E1), // Overlay
  surfaceTint: Color(0xFF286983), // Pine
);
