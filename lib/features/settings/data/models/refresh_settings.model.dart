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
    super.priceAlertsEnabled,
  });

  /// Builds a [RefreshSettingsModel] from a persisted row.
  factory RefreshSettingsModel.fromRow(RefreshSettingsRow row) =>
      RefreshSettingsModel(
        intervalMinutes: row.intervalMinutes,
        browserRefreshEnabled: row.browserRefreshEnabled,
        priceAlertsEnabled: row.priceAlertsEnabled,
      );

  /// Encodes these settings as a drift companion.
  RefreshSettingsTableCompanion toCompanion() => RefreshSettingsTableCompanion(
    id: const Value(1),
    intervalMinutes: Value(intervalMinutes),
    browserRefreshEnabled: Value(browserRefreshEnabled),
    priceAlertsEnabled: Value(priceAlertsEnabled),
  );
}
