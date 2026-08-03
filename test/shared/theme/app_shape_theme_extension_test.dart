// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';

void main() {
  group('AppShapeThemeExtension behaves correctly', () {
    test('copyWith overrides cornerRadius when given', () {
      const AppShapeThemeExtension original = AppShapeThemeExtension(
        cornerRadius: 4,
      );

      final AppShapeThemeExtension copy = original.copyWith(cornerRadius: 20);

      expect(copy.cornerRadius, 20);
    });

    test('copyWith keeps cornerRadius unchanged when omitted', () {
      const AppShapeThemeExtension original = AppShapeThemeExtension(
        cornerRadius: 4,
      );

      final AppShapeThemeExtension copy = original.copyWith();

      expect(copy.cornerRadius, 4);
    });

    test('lerp interpolates cornerRadius halfway between two extensions', () {
      const AppShapeThemeExtension start = AppShapeThemeExtension(
        cornerRadius: 0,
      );
      const AppShapeThemeExtension end = AppShapeThemeExtension(
        cornerRadius: 10,
      );

      final AppShapeThemeExtension midpoint = start.lerp(end, 0.5);

      expect(midpoint.cornerRadius, 5);
    });

    test(
      'lerp returns this unchanged when other is not an AppShapeThemeExtension',
      () {
        const AppShapeThemeExtension original = AppShapeThemeExtension(
          cornerRadius: 4,
        );

        final AppShapeThemeExtension result = original.lerp(null, 1);

        expect(result, original);
      },
    );
  });

  group('BuildContext.resolvedCornerRadius behaves correctly', () {
    testWidgets('returns the theme extension when one is present', (
      tester,
    ) async {
      const AppShapeThemeExtension custom = AppShapeThemeExtension(
        cornerRadius: 100,
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

      expect(capturedContext.resolvedCornerRadius, 100);
    });

    testWidgets(
      'falls back to cornerRadiusPresets[CornerStyle.rounded] when no theme extension is present',
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

        expect(
          capturedContext.resolvedCornerRadius,
          cornerRadiusPresets[CornerStyle.rounded],
        );
      },
    );
  });
}
