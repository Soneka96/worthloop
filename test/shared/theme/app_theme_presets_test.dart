// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_theme_presets.dart';

void main() {
  group('themePresets behaves correctly', () {
    test('themePresets has an entry for every ThemeId', () {
      for (final ThemeId themeId in ThemeId.values) {
        expect(
          themePresets.containsKey(themeId),
          isTrue,
          reason: 'missing preset entry for $themeId',
        );
      }
    });
  });
}
