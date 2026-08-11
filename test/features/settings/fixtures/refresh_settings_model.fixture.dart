// Project imports:
import 'package:worth_loop/features/settings/data/models/refresh_settings.model.dart';

/// Builds a refresh-settings model with overridable fields.
RefreshSettingsModel buildRefreshSettingsModel({
  int intervalMinutes = 60,
  bool browserRefreshEnabled = false,
  bool priceDropAlertsEnabled = false,
  bool priceIncreaseAlertsEnabled = false,
  bool refreshCompletedAlertsEnabled = false,
  bool showRefreshProgress = false,
}) => RefreshSettingsModel(
  intervalMinutes: intervalMinutes,
  browserRefreshEnabled: browserRefreshEnabled,
  priceDropAlertsEnabled: priceDropAlertsEnabled,
  priceIncreaseAlertsEnabled: priceIncreaseAlertsEnabled,
  refreshCompletedAlertsEnabled: refreshCompletedAlertsEnabled,
  showRefreshProgress: showRefreshProgress,
);
