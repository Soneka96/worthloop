// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing_presets.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

void main() {
  group('spacingDensityPresets behaves correctly', () {
    test('spacingDensityPresets has an entry for every SpacingDensity', () {
      for (final SpacingDensity density in SpacingDensity.values) {
        expect(
          spacingDensityPresets.containsKey(density),
          isTrue,
          reason: 'missing preset entry for $density',
        );
      }
    });
  });

  group('spacingValuePresets behaves correctly', () {
    test('spacingValuePresets has an entry for every SpacingDensity', () {
      for (final SpacingDensity density in SpacingDensity.values) {
        expect(
          spacingValuePresets.containsKey(density),
          isTrue,
          reason: 'missing preset entry for $density',
        );
      }
    });

    test('compact is tighter than comfortable across every gap size', () {
      final AppSpacingThemeExtension comfortable =
          spacingValuePresets[SpacingDensity.comfortable] ??
          AppSpacingThemeExtension.comfortable;
      final AppSpacingThemeExtension compact =
          spacingValuePresets[SpacingDensity.compact] ??
          AppSpacingThemeExtension.compact;

      expect(compact.xs, lessThanOrEqualTo(comfortable.xs));
      expect(compact.sm, lessThan(comfortable.sm));
      expect(compact.md, lessThan(comfortable.md));
      expect(compact.lg, lessThan(comfortable.lg));
      expect(compact.xl, lessThan(comfortable.xl));
    });
  });
}
