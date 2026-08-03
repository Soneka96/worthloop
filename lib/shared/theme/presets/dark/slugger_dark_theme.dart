// Flutter imports:
import 'package:flutter/material.dart';

/// Slugger Dark theme preset — the app's own signature default, mapped
/// directly from the app icon's own palette (deep-space navy background,
/// periwinkle-purple moon face, blush-pink cheeks) so every role clears
/// WCAG AA contrast without compromise.
const ColorScheme sluggerDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF8478E3), // Icon face purple
  onPrimary: Color(0xFF0D0C16), // Icon outer ring
  primaryContainer: Color(0xFF221F3D), // Icon middle ring
  onPrimaryContainer: Color(0xFFF1ECEA), // Text
  secondary: Color(0xFFD19FC7), // Icon blush cheeks
  onSecondary: Color(0xFF0D0C16), // Icon outer ring
  secondaryContainer: Color(0xFF221F3D), // Icon middle ring
  onSecondaryContainer: Color(0xFFF1ECEA), // Text
  tertiary: Color(0xFFD9A15C), // Warm gold — starlight accent
  onTertiary: Color(0xFF0D0C16), // Icon outer ring
  tertiaryContainer: Color(0xFF221F3D), // Icon middle ring
  onTertiaryContainer: Color(0xFFF1ECEA), // Text
  error: Color(0xFFE06C6C), // Warm red
  onError: Color(0xFF0D0C16), // Icon outer ring
  errorContainer: Color(0xFF221F3D), // Icon middle ring
  onErrorContainer: Color(0xFFF1ECEA), // Text
  surface: Color(0xFF0D0C16), // Icon outer ring
  onSurface: Color(0xFFF1ECEA), // Text
  onSurfaceVariant: Color(0xFF8B84A8), // Muted lavender-grey
  surfaceContainerHighest: Color(0xFF221F3D), // Icon middle ring
  outline: Color(0xFF8B84A8), // Muted lavender-grey
  outlineVariant: Color(0xFF221F3D), // Icon middle ring
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFF1ECEA), // Text
  onInverseSurface: Color(0xFF0D0C16), // Icon outer ring
  inversePrimary: Color(0xFF221F3D), // Icon middle ring
  surfaceTint: Color(0xFF8478E3), // Icon face purple
);
