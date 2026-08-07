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
        priceAlertsEnabled: true,
      );

      final RefreshSettingsModel model = RefreshSettingsModel.fromRow(row);

      expect(model, isA<RefreshSettingsModel>());
      expect(model.intervalMinutes, isA<int>());
      expect(model.intervalMinutes, 180);
      expect(model.browserRefreshEnabled, isA<bool>());
      expect(model.browserRefreshEnabled, isTrue);
      expect(model.priceAlertsEnabled, isTrue);
    });

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
      expect(companion.priceAlertsEnabled.value, isFalse);
    });
  });
}
