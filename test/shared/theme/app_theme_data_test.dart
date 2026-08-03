// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_text_theme.dart';
import 'package:worth_loop/shared/theme/app_theme_data.dart';
import 'package:worth_loop/shared/theme/presets/dark/dracula_theme.dart';

void main() {
  group('buildAppThemeData builds the correct ThemeData', () {
    late ThemeData result;

    setUp(() {
      result = buildAppThemeData(draculaColorScheme, 20.0);
    });

    test(
      'buildAppThemeData returns a ThemeData with the given colorScheme',
      () {
        expect(result.colorScheme, isA<ColorScheme>());
        expect(result.colorScheme, draculaColorScheme);
      },
    );

    test(
      'buildAppThemeData returns a FilledButtonTheme with RoundedRectangleBorder when cornerRadius = 20.0',
      () {
        final ButtonStyle? style = result.filledButtonTheme.style;
        expect(style, isNotNull);
        final OutlinedBorder? shape = style?.shape?.resolve(<WidgetState>{});
        expect(shape, isA<RoundedRectangleBorder>());
        final BorderRadius borderRadius =
            (shape as RoundedRectangleBorder).borderRadius as BorderRadius;
        expect(
          borderRadius.topLeft.x,
          20.0,
          reason: 'cornerRadius should match the argument',
        );
      },
    );

    test(
      'buildAppThemeData returns a FilledButtonTheme with correct padding',
      () {
        final EdgeInsetsGeometry? padding = result
            .filledButtonTheme
            .style
            ?.padding
            ?.resolve(<WidgetState>{});
        expect(
          padding,
          EdgeInsets.symmetric(
            horizontal: AppSpacingThemeExtension.comfortable.lg,
            vertical: AppSpacingThemeExtension.comfortable.md,
          ),
          reason:
              'padding should match the default (comfortable) spacingValues',
        );
      },
    );

    test(
      'buildAppThemeData returns an OutlinedButtonTheme with correct padding',
      () {
        final EdgeInsetsGeometry? padding = result
            .outlinedButtonTheme
            .style
            ?.padding
            ?.resolve(<WidgetState>{});
        expect(
          padding,
          EdgeInsets.symmetric(
            horizontal: AppSpacingThemeExtension.comfortable.lg,
            vertical: AppSpacingThemeExtension.comfortable.md,
          ),
          reason:
              'padding should match the default (comfortable) spacingValues',
        );
      },
    );

    test(
      'buildAppThemeData returns materialTapTargetSize = MaterialTapTargetSize.shrinkWrap',
      () {
        expect(result.materialTapTargetSize, isA<MaterialTapTargetSize>());
        expect(result.materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);
      },
    );

    test(
      'buildAppThemeData returns visualDensity = VisualDensity.standard by default',
      () {
        expect(result.visualDensity, VisualDensity.standard);
      },
    );

    test(
      'buildAppThemeData returns the given visualDensity when passed explicitly',
      () {
        final ThemeData compact = buildAppThemeData(
          draculaColorScheme,
          20.0,
          visualDensity: VisualDensity.compact,
        );

        expect(compact.visualDensity, VisualDensity.compact);
      },
    );

    test(
      'buildAppThemeData uses the given spacingValues for button padding, not the fixed Spacing constants',
      () {
        const AppSpacingThemeExtension compact = AppSpacingThemeExtension(
          xs: 1,
          sm: 2,
          md: 3,
          lg: 4,
          xl: 5,
        );
        final ThemeData themeData = buildAppThemeData(
          draculaColorScheme,
          20.0,
          spacingValues: compact,
        );

        final EdgeInsetsGeometry? padding = themeData
            .filledButtonTheme
            .style
            ?.padding
            ?.resolve(<WidgetState>{});
        expect(padding, const EdgeInsets.symmetric(horizontal: 4, vertical: 3));
      },
    );

    test('buildAppThemeData adds the given spacingValues to extensions', () {
      const AppSpacingThemeExtension compact = AppSpacingThemeExtension(
        xs: 1,
        sm: 2,
        md: 3,
        lg: 4,
        xl: 5,
      );
      final ThemeData themeData = buildAppThemeData(
        draculaColorScheme,
        20.0,
        spacingValues: compact,
      );

      expect(themeData.extension<AppSpacingThemeExtension>(), compact);
    });

    test('buildAppThemeData returns a SnackBarThemeData using the normal card '
        'surface (not inverseSurface), floating behavior, and the given '
        'cornerRadius', () {
      final SnackBarThemeData snackBarTheme = result.snackBarTheme;
      expect(
        snackBarTheme.backgroundColor,
        draculaColorScheme.surfaceContainerHighest,
      );
      expect(
        snackBarTheme.contentTextStyle?.color,
        draculaColorScheme.onSurface,
      );
      expect(snackBarTheme.behavior, SnackBarBehavior.floating);
      final RoundedRectangleBorder shape =
          snackBarTheme.shape as RoundedRectangleBorder;
      final BorderRadius borderRadius = shape.borderRadius as BorderRadius;
      expect(
        borderRadius.topLeft.x,
        20.0,
        reason: 'cornerRadius should match the argument',
      );
      expect(shape.side.color, draculaColorScheme.outlineVariant);
      expect(
        snackBarTheme.width,
        isNull,
        reason:
            'width is a fixed size in Flutter, not a max — capping while '
            'still hugging short content is done per-call in '
            'PopupService.show() instead',
      );
    });

    test(
      'buildAppThemeData does not override the textTheme font family by default (FontId.systemDefault)',
      () {
        final TextTheme base = buildAppTextTheme(draculaColorScheme);

        expect(
          result.textTheme.bodyMedium?.fontFamily,
          base.bodyMedium?.fontFamily,
        );
      },
    );

    test(
      'buildAppThemeData applies the given fontId to every textTheme slot',
      () {
        final ThemeData themeData = buildAppThemeData(
          draculaColorScheme,
          20.0,
          fontId: FontId.inter,
        );

        expect(themeData.textTheme.bodyMedium?.fontFamily, 'Inter');
        expect(themeData.textTheme.headlineSmall?.fontFamily, 'Inter');
      },
    );

    test(
      'buildAppThemeData returns an IconThemeData using IconSizes.md and colorScheme.onSurface',
      () {
        expect(result.iconTheme.size, IconSizes.md);
        expect(result.iconTheme.color, draculaColorScheme.onSurface);
      },
    );

    test(
      'buildAppThemeData returns a DividerThemeData using DividerSizes.hairline and colorScheme.outlineVariant',
      () {
        expect(result.dividerTheme.color, draculaColorScheme.outlineVariant);
        expect(result.dividerTheme.thickness, DividerSizes.hairline);
        expect(result.dividerTheme.space, DividerSizes.hairline);
      },
    );

    test(
      'buildAppThemeData returns a TooltipThemeData using colorScheme.inverseSurface and the given cornerRadius',
      () {
        final BoxDecoration decoration =
            result.tooltipTheme.decoration as BoxDecoration;
        expect(decoration.color, draculaColorScheme.inverseSurface);
        final BorderRadius borderRadius =
            decoration.borderRadius as BorderRadius;
        expect(
          borderRadius.topLeft.x,
          20.0,
          reason: 'cornerRadius should match the argument',
        );
        expect(
          result.tooltipTheme.textStyle?.color,
          draculaColorScheme.onInverseSurface,
        );
      },
    );

    test(
      'buildAppThemeData returns a ScrollbarThemeData with radius = 3 and thickness = 3',
      () {
        final Radius? radius = result.scrollbarTheme.radius;
        expect(radius, const Radius.circular(3));
        expect(result.scrollbarTheme.thickness?.resolve(<WidgetState>{}), 3.0);
      },
    );

    test(
      'buildAppThemeData returns a TextButtonTheme with correct padding',
      () {
        final EdgeInsetsGeometry? padding = result
            .textButtonTheme
            .style
            ?.padding
            ?.resolve(<WidgetState>{});
        expect(
          padding,
          EdgeInsets.symmetric(
            horizontal: AppSpacingThemeExtension.comfortable.sm,
            vertical: AppSpacingThemeExtension.comfortable.xs,
          ),
          reason:
              'padding should match the default (comfortable) spacingValues',
        );
      },
    );

    test(
      'buildAppThemeData returns a DropdownMenuThemeData with RoundedRectangleBorder using the given cornerRadius',
      () {
        final OutlinedBorder? shape = result.dropdownMenuTheme.menuStyle?.shape
            ?.resolve(<WidgetState>{});
        expect(shape, isA<RoundedRectangleBorder>());
        final BorderRadius borderRadius =
            (shape as RoundedRectangleBorder).borderRadius as BorderRadius;
        expect(
          borderRadius.topLeft.x,
          20.0,
          reason: 'cornerRadius should match the argument',
        );
      },
    );

    test(
      'buildAppThemeData adds an AppShapeThemeExtension using the given cornerRadius',
      () {
        expect(result.extension<AppShapeThemeExtension>()?.cornerRadius, 20.0);
      },
    );
  });
}
