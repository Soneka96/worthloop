// Flutter imports:
import 'package:flutter/material.dart';

/// Catppuccin Mocha theme preset — dark, soothing pastel palette. See
/// https://catppuccin.com/palette for the canonical palette; every
/// [ColorScheme] slot below is hand-mapped from it so no slot falls back to
/// Flutter's stock Material defaults.
const ColorScheme catppuccinMochaColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF89B4FA), // Blue
  onPrimary: Color(0xFF1E1E2E), // Base
  primaryContainer: Color(0xFF2E3450), // Lifted blue surface
  onPrimaryContainer: Color(0xFFCDD6F4), // Text
  secondary: Color(0xFFCBA6F7), // Mauve
  onSecondary: Color(0xFF1E1E2E), // Base
  secondaryContainer: Color(0xFF3D3150), // Lifted mauve surface
  onSecondaryContainer: Color(0xFFCDD6F4), // Text
  tertiary: Color(0xFF94E2D5), // Teal
  onTertiary: Color(0xFF1E1E2E), // Base
  tertiaryContainer: Color(0xFF284443), // Lifted teal surface
  onTertiaryContainer: Color(0xFFCDD6F4), // Text
  error: Color(0xFFF38BA8), // Red
  onError: Color(0xFF1E1E2E), // Base
  errorContainer: Color(0xFF4A2D3A), // Lifted red surface
  onErrorContainer: Color(0xFFCDD6F4), // Text
  surface: Color(0xFF1E1E2E), // Base
  onSurface: Color(0xFFCDD6F4), // Text
  onSurfaceVariant: Color(0xFFA6ADC8), // Subtext0
  surfaceContainerHighest: Color(0xFF313244), // Surface0
  outline: Color(0xFFA6ADC8), // Subtext0
  outlineVariant: Color(0xFF6672A2), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFCDD6F4), // Text
  onInverseSurface: Color(0xFF1E1E2E), // Base
  inversePrimary: Color(0xFF6675C5), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF89B4FA), // Blue
);
