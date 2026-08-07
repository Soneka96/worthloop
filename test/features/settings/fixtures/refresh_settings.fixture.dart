// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';

/// Builds refresh settings with overridable fields.
RefreshSettings buildRefreshSettings({
  int intervalMinutes = 60,
  bool browserRefreshEnabled = false,
  bool priceAlertsEnabled = false,
}) => RefreshSettings(
  intervalMinutes: intervalMinutes,
  browserRefreshEnabled: browserRefreshEnabled,
  priceAlertsEnabled: priceAlertsEnabled,
);
