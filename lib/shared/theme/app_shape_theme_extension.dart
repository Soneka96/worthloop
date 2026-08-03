// Dart imports:
import 'dart:ui' show lerpDouble;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';

/// Exposes [cornerRadius] to any widget via [Theme.of] — for non-button
/// widgets (e.g. a [Container]'s [BoxDecoration], a [DropdownButton]'s menu
/// shape) that need the app's corner-radius preset but have no dedicated
/// [ThemeData] slot the way buttons do via [ThemeData.filledButtonTheme]/
/// [ThemeData.outlinedButtonTheme].
class AppShapeThemeExtension extends ThemeExtension<AppShapeThemeExtension> {
  final double cornerRadius;

  const AppShapeThemeExtension({required this.cornerRadius});

  @override
  AppShapeThemeExtension copyWith({double? cornerRadius}) {
    return AppShapeThemeExtension(
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
  }

  @override
  AppShapeThemeExtension lerp(
    ThemeExtension<AppShapeThemeExtension>? other,
    double t,
  ) {
    if (other is! AppShapeThemeExtension) {
      return this;
    }
    return AppShapeThemeExtension(
      cornerRadius:
          lerpDouble(cornerRadius, other.cornerRadius, t) ?? cornerRadius,
    );
  }
}

/// Resolves the active corner radius from [BuildContext.resolvedCornerRadius]
/// — the one place every non-button widget should read it from, instead of
/// repeating the extension-lookup-with-fallback chain per widget.
extension AppShapeContextX on BuildContext {
  /// The app's current corner radius, falling back to
  /// [CornerStyle.rounded]'s preset if [AppShapeThemeExtension] isn't present
  /// (e.g. a widget test with a bare [ThemeData] ()).
  double get resolvedCornerRadius =>
      Theme.of(this).extension<AppShapeThemeExtension>()?.cornerRadius ??
      cornerRadiusPresets[CornerStyle.rounded] ??
      20.0;
}
