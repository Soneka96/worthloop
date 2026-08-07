// Flutter imports:
import 'package:flutter/material.dart';

/// GitHub Light theme preset — GitHub's Primer design system default light
/// palette. See https://primer.style/foundations/color for the canonical
/// palette; every [ColorScheme] slot below is hand-mapped from it so no slot
/// falls back to Flutter's stock Material defaults.
const ColorScheme githubLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0969DA), // Accent.fg
  onPrimary: Color(0xFFFFFFFF), // Canvas.default
  primaryContainer: Color(0xFFEDF4FF), // Lifted blue surface
  onPrimaryContainer: Color(0xFF1F2328), // Fg.default
  secondary: Color(0xFF8250DF), // Done.fg
  onSecondary: Color(0xFFFFFFFF), // Canvas.default
  secondaryContainer: Color(0xFFF4EEFF), // Lifted purple surface
  onSecondaryContainer: Color(0xFF1F2328), // Fg.default
  tertiary: Color(0xFF1A7F37), // Success.fg
  onTertiary: Color(0xFFFFFFFF), // Canvas.default
  tertiaryContainer: Color(0xFFE8F5EA), // Lifted green surface
  onTertiaryContainer: Color(0xFF1F2328), // Fg.default
  error: Color(0xFFD1242F), // Danger.fg
  onError: Color(0xFFFFFFFF), // Canvas.default
  errorContainer: Color(0xFFFFEBEE), // Lifted red surface
  onErrorContainer: Color(0xFF1F2328), // Fg.default
  surface: Color(0xFFFFFFFF), // Canvas.default
  onSurface: Color(0xFF1F2328), // Fg.default
  onSurfaceVariant: Color(0xFF656D76), // Fg.muted
  surfaceContainerHighest: Color(0xFFF6F8FA), // Canvas.subtle
  outline: Color(0xFF656D76), // Fg.muted
  outlineVariant: Color(0xFF7A838C), // Visible lifted border
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF1F2328), // Fg.default
  onInverseSurface: Color(0xFFFFFFFF), // Canvas.default
  inversePrimary: Color(0xFF0550AE), // Darker blue for inverse surfaces
  surfaceTint: Color(0xFF0969DA), // Accent.fg
);
