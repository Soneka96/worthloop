// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import '../../fixtures/refresh_settings.fixture.dart';

void main() {
  group('RefreshSettings equality', () {
    test('includes intervalMinutes and browserRefreshEnabled', () {
      final RefreshSettings refreshSettings = buildRefreshSettings(
        intervalMinutes: 180,
        browserRefreshEnabled: true,
      );

      expect(refreshSettings.props, [180, true]);
      expect(
        refreshSettings,
        buildRefreshSettings(intervalMinutes: 180, browserRefreshEnabled: true),
      );
      expect(
        refreshSettings,
        isNot(
          buildRefreshSettings(
            intervalMinutes: 180,
            browserRefreshEnabled: false,
          ),
        ),
      );
    });
  });
}
