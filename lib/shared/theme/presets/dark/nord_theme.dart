// Flutter imports:
import 'package:flutter/material.dart';

/// Nord theme preset — arctic, muted blue-grey palette. See
/// https://www.nordtheme.com/docs/colors-and-palettes for the canonical
/// palette; every [ColorScheme] slot below is hand-mapped from it so no slot
/// falls back to Flutter's stock Material defaults.
const ColorScheme nordColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF88C0D0), // Frost — nord8
  onPrimary: Color(0xFF2E3440), // Polar Night — nord0
  primaryContainer: Color(0xFF3B4252), // Polar Night — nord1
  onPrimaryContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  secondary: Color(0xFFB48EAD), // Aurora — nord15
  onSecondary: Color(0xFF2E3440), // Polar Night — nord0
  secondaryContainer: Color(0xFF3B4252), // Polar Night — nord1
  onSecondaryContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  tertiary: Color(0xFFA3BE8C), // Aurora — nord14
  onTertiary: Color(0xFF2E3440), // Polar Night — nord0
  tertiaryContainer: Color(0xFF3B4252), // Polar Night — nord1
  onTertiaryContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  error: Color(0xFFBF616A), // Aurora — nord11
  onError: Color(0xFF2E3440), // Polar Night — nord0
  errorContainer: Color(0xFF3B4252), // Polar Night — nord1
  onErrorContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  surface: Color(0xFF2E3440), // Polar Night — nord0
  onSurface: Color(0xFFECEFF4), // Snow Storm — nord6
  onSurfaceVariant: Color(0xFF4C566A), // Polar Night — nord3 (comments)
  surfaceContainerHighest: Color(0xFF3B4252), // Polar Night — nord1
  outline: Color(0xFF4C566A), // Polar Night — nord3
  outlineVariant: Color(0xFF3B4252), // Polar Night — nord1
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFECEFF4), // Snow Storm — nord6
  onInverseSurface: Color(0xFF2E3440), // Polar Night — nord0
  inversePrimary: Color(0xFF3B4252), // Polar Night — nord1
  surfaceTint: Color(0xFF88C0D0), // Frost — nord8
);
