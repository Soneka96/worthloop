// Flutter imports:
import 'package:flutter/material.dart';

/// Slugger Light theme preset — the app's own signature default, warm
/// coffee-and-cream palette so every role clears WCAG AA contrast without
/// compromise. A paired sibling of [sluggerDarkColorScheme] — the plum
/// secondary ties the two together — not an inverted clone of it.
const ColorScheme sluggerLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6B4226), // Coffee brown
  onPrimary: Color(0xFFF5EDE1), // Cream
  primaryContainer: Color(0xFFE5D7C0), // Lifted coffee surface
  onPrimaryContainer: Color(0xFF2E2117), // Espresso
  secondary: Color(0xFF754A8C), // Plum — ties to dark theme's purple
  onSecondary: Color(0xFFF5EDE1), // Cream
  secondaryContainer: Color(0xFFE7D7EA), // Lifted plum surface
  onSecondaryContainer: Color(0xFF2E2117), // Espresso
  tertiary: Color(0xFF8A6329), // Caramel
  onTertiary: Color(0xFFF5EDE1), // Cream
  tertiaryContainer: Color(0xFFE8E2C8), // Lifted caramel surface
  onTertiaryContainer: Color(0xFF2E2117), // Espresso
  error: Color(0xFFB23A3A), // Brick red
  onError: Color(0xFFF5EDE1), // Cream
  errorContainer: Color(0xFFF2D7D2), // Lifted red surface
  onErrorContainer: Color(0xFF2E2117), // Espresso
  surface: Color(0xFFF5EDE1), // Cream
  onSurface: Color(0xFF2E2117), // Espresso
  onSurfaceVariant: Color(0xFF675647), // Accessible muted coffee-grey
  surfaceContainerHighest: Color(0xFFEBDFCB), // Container
  outline: Color(0xFF675647), // Accessible muted coffee-grey
  outlineVariant: Color(0xFF927A5A), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF2E2117), // Espresso
  onInverseSurface: Color(0xFFF5EDE1), // Cream
  inversePrimary: Color(0xFF5A321D), // Darker coffee for inverse surfaces
  surfaceTint: Color(0xFF6B4226), // Coffee brown
);
