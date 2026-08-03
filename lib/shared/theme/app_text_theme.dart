// Flutter imports:
import 'package:flutter/material.dart';

/// Builds the app's [TextTheme] for [colorScheme] — all 15 Material 3 slots
/// are explicit so no slot falls back to Flutter's stock defaults silently.
///
/// Two deliberate overrides every screen relies on:
/// - [TextTheme.headlineSmall] — bold weight for hero headlines.
/// - [TextTheme.labelSmall] — primary colour, letter-spaced, semi-bold for
///   eyebrow-style section markers (e.g. "PROFILE", "RECENT").
///
/// All other slots follow M3 colour role assignments: [ColorScheme.onSurface]
/// for most text, [ColorScheme.onSurfaceVariant] for de-emphasised small text.
TextTheme buildAppTextTheme(ColorScheme colorScheme) {
  final TextTheme base = ThemeData(colorScheme: colorScheme).textTheme;
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(color: colorScheme.onSurface),
    displayMedium: base.displayMedium?.copyWith(color: colorScheme.onSurface),
    displaySmall: base.displaySmall?.copyWith(color: colorScheme.onSurface),
    headlineLarge: base.headlineLarge?.copyWith(color: colorScheme.onSurface),
    headlineMedium: base.headlineMedium?.copyWith(color: colorScheme.onSurface),
    headlineSmall: base.headlineSmall?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: base.titleLarge?.copyWith(color: colorScheme.onSurface),
    titleMedium: base.titleMedium?.copyWith(color: colorScheme.onSurface),
    titleSmall: base.titleSmall?.copyWith(color: colorScheme.onSurface),
    bodyLarge: base.bodyLarge?.copyWith(color: colorScheme.onSurface),
    bodyMedium: base.bodyMedium?.copyWith(color: colorScheme.onSurface),
    bodySmall: base.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
    labelLarge: base.labelLarge?.copyWith(color: colorScheme.onSurface),
    labelMedium: base.labelMedium?.copyWith(color: colorScheme.onSurface),
    labelSmall: base.labelSmall?.copyWith(
      color: colorScheme.primary,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w600,
    ),
  );
}
