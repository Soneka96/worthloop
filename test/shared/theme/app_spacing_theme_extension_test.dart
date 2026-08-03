// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

void main() {
  group('AppSpacingThemeExtension behaves correctly', () {
    test('copyWith overrides only the given fields', () {
      const AppSpacingThemeExtension original = AppSpacingThemeExtension(
        xs: 1,
        sm: 2,
        md: 3,
        lg: 4,
        xl: 5,
      );

      final AppSpacingThemeExtension copy = original.copyWith(md: 30);

      expect(copy.xs, 1);
      expect(copy.sm, 2);
      expect(copy.md, 30);
      expect(copy.lg, 4);
      expect(copy.xl, 5);
    });

    test('lerp interpolates every field halfway between two extensions', () {
      const AppSpacingThemeExtension start = AppSpacingThemeExtension(
        xs: 0,
        sm: 0,
        md: 0,
        lg: 0,
        xl: 0,
      );
      const AppSpacingThemeExtension end = AppSpacingThemeExtension(
        xs: 10,
        sm: 10,
        md: 10,
        lg: 10,
        xl: 10,
      );

      final AppSpacingThemeExtension midpoint = start.lerp(end, 0.5);

      expect(midpoint.xs, 5);
      expect(midpoint.sm, 5);
      expect(midpoint.md, 5);
      expect(midpoint.lg, 5);
      expect(midpoint.xl, 5);
    });

    test(
      'lerp returns this unchanged when other is not an AppSpacingThemeExtension',
      () {
        const AppSpacingThemeExtension original = AppSpacingThemeExtension(
          xs: 1,
          sm: 2,
          md: 3,
          lg: 4,
          xl: 5,
        );

        final AppSpacingThemeExtension result = original.lerp(null, 1);

        expect(result, original);
      },
    );
  });

  group('BuildContext.spacing behaves correctly', () {
    testWidgets('returns the theme extension when one is present', (
      tester,
    ) async {
      const AppSpacingThemeExtension custom = AppSpacingThemeExtension(
        xs: 100,
        sm: 100,
        md: 100,
        lg: 100,
        xl: 100,
      );
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [custom]),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(capturedContext.spacing.md, 100);
    });

    testWidgets(
      'falls back to AppSpacingThemeExtension.comfortable when no theme extension is present',
      (tester) async {
        late BuildContext capturedContext;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(),
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(capturedContext.spacing, AppSpacingThemeExtension.comfortable);
      },
    );
  });
}
