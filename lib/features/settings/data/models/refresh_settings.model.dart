// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// Drift-backed model for the domain [RefreshSettings] entity.
class RefreshSettingsModel extends RefreshSettings {
  /// Creates a persisted refresh-settings representation.
  const RefreshSettingsModel({
    required super.intervalMinutes,
    super.browserRefreshEnabled,
    super.priceDropAlertsEnabled,
    super.priceIncreaseAlertsEnabled,
    super.refreshCompletedAlertsEnabled,
    super.showRefreshProgress,
  });

  /// Builds a [RefreshSettingsModel] from a persisted row.
  factory RefreshSettingsModel.fromRow(RefreshSettingsRow row) =>
      RefreshSettingsModel(
        intervalMinutes: row.intervalMinutes,
        browserRefreshEnabled: row.browserRefreshEnabled,
        priceDropAlertsEnabled: row.priceDropAlertsEnabled,
        priceIncreaseAlertsEnabled: row.priceIncreaseAlertsEnabled,
        refreshCompletedAlertsEnabled: row.refreshCompletedAlertsEnabled,
        showRefreshProgress: row.showRefreshProgress,
      );

  /// Encodes these settings as a drift companion.
  RefreshSettingsTableCompanion toCompanion() => RefreshSettingsTableCompanion(
    id: const Value(1),
    intervalMinutes: Value(intervalMinutes),
    browserRefreshEnabled: Value(browserRefreshEnabled),
    priceDropAlertsEnabled: Value(priceDropAlertsEnabled),
    priceIncreaseAlertsEnabled: Value(priceIncreaseAlertsEnabled),
    refreshCompletedAlertsEnabled: Value(refreshCompletedAlertsEnabled),
    showRefreshProgress: Value(showRefreshProgress),
  );
}
