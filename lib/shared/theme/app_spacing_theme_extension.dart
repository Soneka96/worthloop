// Dart imports:
import 'dart:ui' show lerpDouble;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// Exposes density-scaled gap sizes to any widget via [Theme.of] — the
/// density-aware counterpart the app's old fixed spacing constants.
/// Widgets read gaps from here (via [AppSpacingContextX.spacing]) instead of
/// a static constant, so gaps actually shrink under [SpacingDensity.compact].
class AppSpacingThemeExtension
    extends ThemeExtension<AppSpacingThemeExtension> {
  /// What "comfortable" density numerically means — the single canonical
  /// definition, reused by [spacingValuePresets] and as the fallback in
  /// [AppSpacingContextX.spacing]. Never redefine these five numbers
  /// anywhere else.
  static const AppSpacingThemeExtension comfortable = AppSpacingThemeExtension(
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
  );

  /// What "compact" density numerically means — the single canonical
  /// definition, reused by [spacingValuePresets]. A tighter first-pass set,
  /// not yet fine-tuned per tier.
  static const AppSpacingThemeExtension compact = AppSpacingThemeExtension(
    xs: 2,
    sm: 6,
    md: 8,
    lg: 12,
    xl: 16,
  );

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const AppSpacingThemeExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  @override
  AppSpacingThemeExtension copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppSpacingThemeExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppSpacingThemeExtension lerp(
    ThemeExtension<AppSpacingThemeExtension>? other,
    double t,
  ) {
    if (other is! AppSpacingThemeExtension) {
      return this;
    }
    return AppSpacingThemeExtension(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
    );
  }
}

/// The one place every widget should read its gap sizes from, instead of a
/// fixed constant, so gaps actually respond to the density preset.
extension AppSpacingContextX on BuildContext {
  /// The app's current density-scaled gap sizes, falling back to
  /// [AppSpacingThemeExtension.comfortable] if [AppSpacingThemeExtension]
  /// isn't present (e.g. a widget test with a bare [ThemeData] ()).
  AppSpacingThemeExtension get spacing =>
      Theme.of(this).extension<AppSpacingThemeExtension>() ??
      AppSpacingThemeExtension.comfortable;
}
