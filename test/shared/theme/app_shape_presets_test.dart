// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';

void main() {
  group('cornerRadiusPresets behaves correctly', () {
    test('cornerRadiusPresets has an entry for every CornerStyle', () {
      for (final CornerStyle cornerStyle in CornerStyle.values) {
        expect(
          cornerRadiusPresets.containsKey(cornerStyle),
          isTrue,
          reason: 'missing preset entry for $cornerStyle',
        );
      }
    });
  });
}
