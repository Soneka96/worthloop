// Flutter imports:
import 'package:flutter/material.dart';

/// One Dark Pro theme preset — Atom/VS Code-style dark theme, blue-grey
/// palette. See https://github.com/Binaryify/OneDark-Pro for the canonical
/// palette; every [ColorScheme] slot below is hand-mapped from it so no slot
/// falls back to Flutter's stock Material defaults.
const ColorScheme oneDarkProColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF61AFEF), // Blue
  onPrimary: Color(0xFF282C34), // Background
  primaryContainer: Color(0xFF34415A), // Lifted blue surface
  onPrimaryContainer: Color(0xFFABB2BF), // Foreground
  secondary: Color(0xFFC678DD), // Purple
  onSecondary: Color(0xFF282C34), // Background
  secondaryContainer: Color(0xFF47364D), // Lifted purple surface
  onSecondaryContainer: Color(0xFFABB2BF), // Foreground
  tertiary: Color(0xFF56B6C2), // Cyan
  onTertiary: Color(0xFF282C34), // Background
  tertiaryContainer: Color(0xFF2D494F), // Lifted cyan surface
  onTertiaryContainer: Color(0xFFABB2BF), // Foreground
  error: Color(0xFFED7C84), // Brighter red for controls
  onError: Color(0xFF282C34), // Background
  errorContainer: Color(0xFF512F36), // Lifted red surface
  onErrorContainer: Color(0xFFABB2BF), // Foreground
  surface: Color(0xFF282C34), // Background
  onSurface: Color(0xFFABB2BF), // Foreground
  onSurfaceVariant: Color(0xFFAAB2C0), // Accessible muted blue-grey
  surfaceContainerHighest: Color(0xFF2C323C), // Current Line
  outline: Color(0xFFAAB2C0), // Accessible muted blue-grey
  outlineVariant: Color(0xFF7A88A2), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFABB2BF), // Foreground
  onInverseSurface: Color(0xFF282C34), // Background
  inversePrimary: Color(0xFF4E8EC2), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF61AFEF), // Blue
);
