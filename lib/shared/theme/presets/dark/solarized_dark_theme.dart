// Flutter imports:
import 'package:flutter/material.dart';

/// Solarized Dark theme preset — precision-engineered low-contrast palette.
/// See https://ethanschoonover.com/solarized/ for the canonical palette;
/// every [ColorScheme] slot below is hand-mapped from it so no slot falls
/// back to Flutter's stock Material defaults.
const ColorScheme solarizedDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF268BD2), // Blue
  onPrimary: Color(0xFF002B36), // Base03
  primaryContainer: Color(0xFF073642), // Base02
  onPrimaryContainer: Color(0xFF839496), // Base0
  secondary: Color(0xFF6C71C4), // Violet
  onSecondary: Color(0xFF002B36), // Base03
  secondaryContainer: Color(0xFF073642), // Base02
  onSecondaryContainer: Color(0xFF839496), // Base0
  tertiary: Color(0xFF2AA198), // Cyan
  onTertiary: Color(0xFF002B36), // Base03
  tertiaryContainer: Color(0xFF073642), // Base02
  onTertiaryContainer: Color(0xFF839496), // Base0
  error: Color(0xFFDC322F), // Red
  onError: Color(0xFF002B36), // Base03
  errorContainer: Color(0xFF073642), // Base02
  onErrorContainer: Color(0xFF839496), // Base0
  surface: Color(0xFF002B36), // Base03
  onSurface: Color(0xFF839496), // Base0
  onSurfaceVariant: Color(0xFF586E75), // Base01 (comments)
  surfaceContainerHighest: Color(0xFF073642), // Base02
  outline: Color(0xFF586E75), // Base01
  outlineVariant: Color(0xFF073642), // Base02
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF839496), // Base0
  onInverseSurface: Color(0xFF002B36), // Base03
  inversePrimary: Color(0xFF073642), // Base02
  surfaceTint: Color(0xFF268BD2), // Blue
);
