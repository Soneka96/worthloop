// Project imports:
import 'package:worth_loop/features/settings/data/models/refresh_settings.model.dart';

/// Builds a refresh-settings model with overridable fields.
RefreshSettingsModel buildRefreshSettingsModel({
  int intervalMinutes = 60,
  bool browserRefreshEnabled = false,
  bool priceAlertsEnabled = false,
}) => RefreshSettingsModel(
  intervalMinutes: intervalMinutes,
  browserRefreshEnabled: browserRefreshEnabled,
  priceAlertsEnabled: priceAlertsEnabled,
);
