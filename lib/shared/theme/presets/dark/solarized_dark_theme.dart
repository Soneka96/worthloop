// Flutter imports:
import 'package:flutter/material.dart';

/// Solarized Dark theme preset — precision-engineered low-contrast palette.
/// See https://ethanschoonover.com/solarized/ for the canonical palette;
/// every [ColorScheme] slot below is hand-mapped from it so no slot falls
/// back to Flutter's stock Material defaults.
const ColorScheme solarizedDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF2E9FE6), // Brighter blue for controls
  onPrimary: Color(0xFF002B36), // Base03
  primaryContainer: Color(0xFF0A4250), // Lifted blue surface
  onPrimaryContainer: Color(0xFFD7E2E2), // Accessible light text
  secondary: Color(0xFF8589D8), // Brighter violet for controls
  onSecondary: Color(0xFF002B36), // Base03
  secondaryContainer: Color(0xFF3B3E63), // Lifted violet surface
  onSecondaryContainer: Color(0xFFD7E2E2), // Accessible light text
  tertiary: Color(0xFF35B6AA), // Brighter cyan for controls
  onTertiary: Color(0xFF002B36), // Base03
  tertiaryContainer: Color(0xFF0B4C4C), // Lifted cyan surface
  onTertiaryContainer: Color(0xFFD7E2E2), // Accessible light text
  error: Color(0xFFF05B56), // Brighter red for controls
  onError: Color(0xFF002B36), // Base03
  errorContainer: Color(0xFF5B282A), // Lifted red surface
  onErrorContainer: Color(0xFFD7E2E2), // Accessible light text
  surface: Color(0xFF002B36), // Base03
  onSurface: Color(0xFFB7C5C7), // Accessible Base0
  onSurfaceVariant: Color(0xFFB0C0C4), // Accessible muted blue-grey
  surfaceContainerHighest: Color(0xFF073642), // Base02
  outline: Color(0xFFB0C0C4), // Accessible muted blue-grey
  outlineVariant: Color(0xFF5A858C), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF839496), // Base0
  onInverseSurface: Color(0xFF002B36), // Base03
  inversePrimary: Color(0xFF167A9B), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF268BD2), // Blue
);
