// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import '../../fixtures/refresh_settings.fixture.dart';

void main() {
  group('RefreshSettings equality', () {
    test('includes all refresh preferences', () {
      final RefreshSettings refreshSettings = buildRefreshSettings(
        intervalMinutes: 180,
        browserRefreshEnabled: true,
        priceDropAlertsEnabled: true,
        priceIncreaseAlertsEnabled: true,
        refreshCompletedAlertsEnabled: true,
        showRefreshProgress: true,
      );

      expect(refreshSettings.props, [180, true, true, true, true, true]);
      expect(
        refreshSettings,
        buildRefreshSettings(
          intervalMinutes: 180,
          browserRefreshEnabled: true,
          priceDropAlertsEnabled: true,
          priceIncreaseAlertsEnabled: true,
          refreshCompletedAlertsEnabled: true,
          showRefreshProgress: true,
        ),
      );
      expect(
        refreshSettings,
        isNot(
          buildRefreshSettings(
            intervalMinutes: 180,
            browserRefreshEnabled: false,
            priceDropAlertsEnabled: true,
            priceIncreaseAlertsEnabled: true,
            refreshCompletedAlertsEnabled: true,
            showRefreshProgress: true,
          ),
        ),
      );
      expect(
        refreshSettings,
        isNot(
          buildRefreshSettings(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
            priceDropAlertsEnabled: false,
            priceIncreaseAlertsEnabled: true,
            refreshCompletedAlertsEnabled: true,
            showRefreshProgress: true,
          ),
        ),
      );
      expect(
        refreshSettings,
        isNot(
          buildRefreshSettings(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
            priceDropAlertsEnabled: true,
            priceIncreaseAlertsEnabled: false,
            refreshCompletedAlertsEnabled: true,
            showRefreshProgress: true,
          ),
        ),
      );
      expect(
        refreshSettings,
        isNot(
          buildRefreshSettings(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
            priceDropAlertsEnabled: true,
            priceIncreaseAlertsEnabled: true,
            refreshCompletedAlertsEnabled: false,
            showRefreshProgress: true,
          ),
        ),
      );
      expect(
        refreshSettings,
        isNot(
          buildRefreshSettings(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
            priceDropAlertsEnabled: true,
            priceIncreaseAlertsEnabled: true,
            refreshCompletedAlertsEnabled: true,
            showRefreshProgress: false,
          ),
        ),
      );
    });
  });
}
