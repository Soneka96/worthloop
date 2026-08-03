// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_font_presets.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_text_theme.dart';
import 'package:worth_loop/shared/window/home_window_size_service.dart';

/// Builds the app's [ThemeData] for [colorScheme], [cornerRadius],
/// [visualDensity], [spacingValues], and [fontId] — the single source of
/// truth for all component theming. Every [ThemeId] preset feeds through
/// here, so changing a property here updates all themes at once.
///
/// All component themes are defined explicitly so no slot falls back to
/// Flutter's stock Material defaults silently. Add new component themes here
/// rather than inline in widgets.
///
/// Buttons are pinned to [VisualDensity.standard] regardless of the app's own
/// density setting — [FilledButton]/[OutlinedButton]/[TextButton] clamp their
/// density-adjusted padding and minimum-size constraint to a hard floor
/// internally, making their rendered size unpredictable for
/// [HomeWindowSizeService]'s calculation to replicate exactly. Only the
/// app's own spacing (via [spacingValues]) responds to density.
ThemeData buildAppThemeData(
  ColorScheme colorScheme,
  double cornerRadius, {
  VisualDensity visualDensity = VisualDensity.standard,
  AppSpacingThemeExtension spacingValues = AppSpacingThemeExtension.comfortable,
  FontId fontId = FontId.systemDefault,
}) {
  final OutlinedBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cornerRadius),
  );

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: applyFontFamily(buildAppTextTheme(colorScheme), fontId),
    visualDensity: visualDensity,
    splashFactory: NoSplash.splashFactory,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    iconTheme: IconThemeData(size: IconSizes.md, color: colorScheme.onSurface),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: DividerSizes.hairline,
      space: DividerSizes.hairline,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      textStyle: TextStyle(color: colorScheme.onInverseSurface, fontSize: 12),
      waitDuration: const Duration(milliseconds: 500),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      contentTextStyle: TextStyle(color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(3),
      thickness: WidgetStateProperty.all(3),
      thumbColor: WidgetStateProperty.all(
        colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: buttonShape,
        padding: EdgeInsets.symmetric(
          horizontal: spacingValues.lg,
          vertical: spacingValues.md,
        ),
        visualDensity: VisualDensity.standard,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: buttonShape,
        padding: EdgeInsets.symmetric(
          horizontal: spacingValues.lg,
          vertical: spacingValues.md,
        ),
        visualDensity: VisualDensity.standard,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: spacingValues.sm,
          vertical: spacingValues.xs,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
        ),
      ),
    ),
    extensions: [
      AppShapeThemeExtension(cornerRadius: cornerRadius),
      spacingValues,
    ],
  );
}
