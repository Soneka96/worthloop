// Project imports:
import 'package:worth_loop/shared/state/app.state.dart';

/// Static refresh-settings selectors over [AppState].
abstract final class RefreshSettingsSelectors {
  /// Returns the preferred interval in minutes.
  static int intervalMinutesSelector(AppState state) =>
      state.refreshSettings.intervalMinutes;

  /// Returns whether browser-backed background refresh is enabled.
  static bool browserRefreshEnabledSelector(AppState state) =>
      state.refreshSettings.browserRefreshEnabled;

  /// Returns whether product price-drop notifications are enabled.
  static bool priceAlertsEnabledSelector(AppState state) =>
      state.refreshSettings.priceAlertsEnabled;

  /// Returns whether product price-increase notifications are enabled.
  static bool priceIncreaseAlertsEnabledSelector(AppState state) =>
      state.refreshSettings.priceIncreaseAlertsEnabled;

  /// Returns whether a notification is shown for every completed background
  /// refresh.
  static bool refreshCompletedAlertsEnabledSelector(AppState state) =>
      state.refreshSettings.refreshCompletedAlertsEnabled;

  /// Returns whether the background refresh shows a progress bar on its
  /// notification while sources are being fetched.
  static bool showRefreshProgressSelector(AppState state) =>
      state.refreshSettings.showRefreshProgress;

  /// Returns whether refresh settings are loading or saving.
  static bool isBusySelector(AppState state) =>
      state.refreshSettings.isLoading || state.refreshSettings.isSaving;
}
