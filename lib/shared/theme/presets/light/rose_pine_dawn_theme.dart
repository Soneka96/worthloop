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
  primaryContainer: Color(0xFFE5F0F0), // Lifted pine surface
  onPrimaryContainer: Color(0xFF464261), // Text
  secondary: Color(0xFF907AA9), // Iris
  onSecondary: Color(0xFF211630), // Accessible dark text
  secondaryContainer: Color(0xFFE7DFF0), // Lifted iris surface
  onSecondaryContainer: Color(0xFF464261), // Text
  tertiary: Color(0xFF56949F), // Foam
  onTertiary: Color(0xFF092229), // Accessible dark text
  tertiaryContainer: Color(0xFFDDEEEF), // Lifted foam surface
  onTertiaryContainer: Color(0xFF464261), // Text
  error: Color(0xFFB4637A), // Love
  onError: Color(0xFF180A12), // Accessible dark text
  errorContainer: Color(0xFFF2DCE4), // Lifted love surface
  onErrorContainer: Color(0xFF464261), // Text
  surface: Color(0xFFFAF4ED), // Base
  onSurface: Color(0xFF464261), // Text
  onSurfaceVariant: Color(0xFF645F70), // Accessible muted lavender
  surfaceContainerHighest: Color(0xFFF2E9E1), // Overlay
  outline: Color(0xFF645F70), // Accessible muted lavender
  outlineVariant: Color(0xFF847A8A), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF464261), // Text
  onInverseSurface: Color(0xFFFAF4ED), // Base
  inversePrimary: Color(0xFF205E76), // Darker pine for inverse surfaces
  surfaceTint: Color(0xFF286983), // Pine
);
