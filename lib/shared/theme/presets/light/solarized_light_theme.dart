// Flutter imports:
import 'package:flutter/material.dart';

/// Solarized Light theme preset — precision-engineered low-contrast
/// palette. See https://ethanschoonover.com/solarized/ for the canonical
/// palette; every [ColorScheme] slot below is hand-mapped from it so no slot
/// falls back to Flutter's stock Material defaults.
const ColorScheme solarizedLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1B6FAE), // Darker blue for controls
  onPrimary: Color(0xFFFDF6E3), // Base3
  primaryContainer: Color(0xFFE1D8BE), // Lifted blue surface
  onPrimaryContainer: Color(0xFF4A5A60), // Accessible dark text
  secondary: Color(0xFF5A5FA8), // Darker violet for controls
  onSecondary: Color(0xFFFDF6E3), // Base3
  secondaryContainer: Color(0xFFDDDDF0), // Lifted violet surface
  onSecondaryContainer: Color(0xFF4A5A60), // Accessible dark text
  tertiary: Color(0xFF1E736D), // Darker cyan for controls
  onTertiary: Color(0xFFFDF6E3), // Base3
  tertiaryContainer: Color(0xFFD5E8E4), // Lifted cyan surface
  onTertiaryContainer: Color(0xFF4A5A60), // Accessible dark text
  error: Color(0xFFA51F1D), // Darker red for controls
  onError: Color(0xFFFDF6E3), // Base3
  errorContainer: Color(0xFFF1D0CD), // Lifted red surface
  onErrorContainer: Color(0xFF4A5A60), // Accessible dark text
  surface: Color(0xFFFDF6E3), // Base3
  onSurface: Color(0xFF526A6F), // Accessible Base01
  onSurfaceVariant: Color(0xFF465C60), // Accessible muted blue-grey
  surfaceContainerHighest: Color(0xFFEEE8D5), // Base2
  outline: Color(0xFF465C60), // Accessible muted blue-grey
  outlineVariant: Color(0xFF8B7F66), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF657B83), // Base00
  onInverseSurface: Color(0xFFFDF6E3), // Base3
  inversePrimary: Color(0xFF17618E), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF268BD2), // Blue
);
