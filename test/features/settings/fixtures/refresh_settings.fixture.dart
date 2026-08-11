// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';

/// Builds refresh settings with overridable fields.
RefreshSettings buildRefreshSettings({
  int intervalMinutes = 60,
  bool browserRefreshEnabled = false,
  bool priceDropAlertsEnabled = false,
  bool priceIncreaseAlertsEnabled = false,
  bool refreshCompletedAlertsEnabled = false,
  bool showRefreshProgress = false,
}) => RefreshSettings(
  intervalMinutes: intervalMinutes,
  browserRefreshEnabled: browserRefreshEnabled,
  priceDropAlertsEnabled: priceDropAlertsEnabled,
  priceIncreaseAlertsEnabled: priceIncreaseAlertsEnabled,
  refreshCompletedAlertsEnabled: refreshCompletedAlertsEnabled,
  showRefreshProgress: showRefreshProgress,
);
