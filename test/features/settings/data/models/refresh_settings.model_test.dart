// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/models/refresh_settings.model.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import '../../fixtures/refresh_settings_model.fixture.dart';

void main() {
  group(
    'RefreshSettingsModel extends the appropriate RefreshSettings parent',
    () {
      test('RefreshSettingsModel is a subclass of RefreshSettings', () {
        expect(buildRefreshSettingsModel(), isA<RefreshSettings>());
      });
    },
  );

  group("RefreshSettingsModel's methods return the correct value", () {
    test('Method fromRow() should return a RefreshSettingsModel', () {
      const RefreshSettingsRow row = RefreshSettingsRow(
        id: 1,
        intervalMinutes: 180,
        browserRefreshEnabled: true,
        priceDropAlertsEnabled: true,
        priceIncreaseAlertsEnabled: true,
        refreshCompletedAlertsEnabled: true,
        showRefreshProgress: true,
      );

      final RefreshSettingsModel model = RefreshSettingsModel.fromRow(row);

      expect(model, isA<RefreshSettingsModel>());
      expect(model.intervalMinutes, isA<int>());
      expect(model.intervalMinutes, 180);
      expect(model.browserRefreshEnabled, isA<bool>());
      expect(model.browserRefreshEnabled, isTrue);
      expect(model.priceDropAlertsEnabled, isA<bool>());
      expect(model.priceDropAlertsEnabled, isTrue);
      expect(model.priceIncreaseAlertsEnabled, isA<bool>());
      expect(model.priceIncreaseAlertsEnabled, isTrue);
      expect(model.refreshCompletedAlertsEnabled, isA<bool>());
      expect(model.refreshCompletedAlertsEnabled, isTrue);
      expect(model.showRefreshProgress, isA<bool>());
      expect(model.showRefreshProgress, isTrue);
    });

    test(
      'Method fromRow() maps each boolean field independently, not by position',
      () {
        const RefreshSettingsRow row = RefreshSettingsRow(
          id: 1,
          intervalMinutes: 60,
          browserRefreshEnabled: true,
          priceDropAlertsEnabled: false,
          priceIncreaseAlertsEnabled: true,
          refreshCompletedAlertsEnabled: false,
          showRefreshProgress: true,
        );

        final RefreshSettingsModel model = RefreshSettingsModel.fromRow(row);

        expect(model.browserRefreshEnabled, isTrue);
        expect(model.priceDropAlertsEnabled, isFalse);
        expect(model.priceIncreaseAlertsEnabled, isTrue);
        expect(model.refreshCompletedAlertsEnabled, isFalse);
        expect(model.showRefreshProgress, isTrue);
      },
    );

    test('Method toCompanion() should return persisted values', () {
      final RefreshSettingsTableCompanion companion = buildRefreshSettingsModel(
        intervalMinutes: 360,
      ).toCompanion();

      expect(companion.id.value, isA<int>());
      expect(companion.id.value, 1);
      expect(companion.intervalMinutes.value, isA<int>());
      expect(companion.intervalMinutes.value, 360);
      expect(companion.browserRefreshEnabled.value, isA<bool>());
      expect(companion.browserRefreshEnabled.value, isFalse);
      expect(companion.priceDropAlertsEnabled.value, isA<bool>());
      expect(companion.priceDropAlertsEnabled.value, isFalse);
      expect(companion.priceIncreaseAlertsEnabled.value, isA<bool>());
      expect(companion.priceIncreaseAlertsEnabled.value, isFalse);
      expect(companion.refreshCompletedAlertsEnabled.value, isA<bool>());
      expect(companion.refreshCompletedAlertsEnabled.value, isFalse);
      expect(companion.showRefreshProgress.value, isA<bool>());
      expect(companion.showRefreshProgress.value, isFalse);
    });

    test(
      'Method toCompanion() maps each boolean field independently, not by position',
      () {
        final RefreshSettingsTableCompanion companion = buildRefreshSettingsModel(
          browserRefreshEnabled: true,
          priceDropAlertsEnabled: false,
          priceIncreaseAlertsEnabled: true,
          refreshCompletedAlertsEnabled: false,
          showRefreshProgress: true,
        ).toCompanion();

        expect(companion.browserRefreshEnabled.value, isTrue);
        expect(companion.priceDropAlertsEnabled.value, isFalse);
        expect(companion.priceIncreaseAlertsEnabled.value, isTrue);
        expect(companion.refreshCompletedAlertsEnabled.value, isFalse);
        expect(companion.showRefreshProgress.value, isTrue);
      },
    );
  });
}
