// Flutter imports:
import 'package:flutter/material.dart';

/// Everforest Light theme preset — green, forest-inspired palette (medium
/// contrast). See https://github.com/sainnhe/everforest/blob/master/palette.md
/// for the canonical palette; every [ColorScheme] slot below is hand-mapped
/// from it so no slot falls back to Flutter's stock Material defaults.
const ColorScheme everforestLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF56B1DA), // Brighter blue for controls
  onPrimary: Color(0xFF183C4A), // Accessible dark text
  primaryContainer: Color(0xFFDCEAD9), // Lifted blue-green surface
  onPrimaryContainer: Color(0xFF42554A), // Fg
  secondary: Color(0xFFE878C5), // Brighter purple for controls
  onSecondary: Color(0xFF4D233F), // Accessible dark text
  secondaryContainer: Color(0xFFEADDE5), // Lifted purple surface
  onSecondaryContainer: Color(0xFF5A4050), // Fg
  tertiary: Color(0xFF57C89B), // Brighter aqua for controls
  onTertiary: Color(0xFF164B3A), // Accessible dark text
  tertiaryContainer: Color(0xFFD9EEE2), // Lifted aqua surface
  onTertiaryContainer: Color(0xFF3B5D4A), // Fg
  error: Color(0xFFFF8078), // Brighter red for controls
  onError: Color(0xFF6A201E), // Accessible dark text
  errorContainer: Color(0xFFF5D8D7), // Lifted red surface
  onErrorContainer: Color(0xFF693A39), // Fg
  surface: Color(0xFFFDF6E3), // Bg0
  onSurface: Color(0xFF5C6A72), // Fg
  onSurfaceVariant: Color(0xFF566259), // Accessible muted green-grey
  surfaceContainerHighest: Color(0xFFF4F0D9), // Bg1
  outline: Color(0xFF566259), // Accessible muted green-grey
  outlineVariant: Color(0xFF73806C), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF5C6A72), // Fg
  onInverseSurface: Color(0xFFFDF6E3), // Bg0
  inversePrimary: Color(0xFF377FA0), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF3A94C5), // Blue
);
