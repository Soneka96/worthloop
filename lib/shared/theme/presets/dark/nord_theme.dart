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
  primaryContainer: Color(0xFF3A4052), // Lifted frost surface
  onPrimaryContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  secondary: Color(0xFFC49BBF), // Brighter aurora for controls
  onSecondary: Color(0xFF2E3440), // Polar Night — nord0
  secondaryContainer: Color(0xFF493C50), // Lifted aurora surface
  onSecondaryContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  tertiary: Color(0xFFA3BE8C), // Aurora — nord14
  onTertiary: Color(0xFF2E3440), // Polar Night — nord0
  tertiaryContainer: Color(0xFF354A4B), // Lifted green surface
  onTertiaryContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  error: Color(0xFFE08E96), // Brighter aurora red for controls
  onError: Color(0xFF2E3440), // Polar Night — nord0
  errorContainer: Color(0xFF563439), // Lifted red surface
  onErrorContainer: Color(0xFFECEFF4), // Snow Storm — nord6
  surface: Color(0xFF2E3440), // Polar Night — nord0
  onSurface: Color(0xFFECEFF4), // Snow Storm — nord6
  onSurfaceVariant: Color(0xFFAAB7CC), // Accessible muted blue-grey
  surfaceContainerHighest: Color(0xFF3B4252), // Polar Night — nord1
  outline: Color(0xFFAAB7CC), // Accessible muted blue-grey
  outlineVariant: Color(0xFF8F9EBD), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFECEFF4), // Snow Storm — nord6
  onInverseSurface: Color(0xFF2E3440), // Polar Night — nord0
  inversePrimary: Color(0xFF5D87A7), // Darker frost for inverse surfaces
  surfaceTint: Color(0xFF88C0D0), // Frost — nord8
);
