// Project imports:
import 'package:worth_loop/shared/state/app.state.dart';

/// Static refresh-settings selectors over [AppState].
abstract final class RefreshSettingsSelectors {
  /// Returns the preferred interval in minutes.
  static int intervalMinutesSelector(AppState state) =>
      state.refreshSettings.intervalMinutes;

  /// Returns whether refresh settings are loading or saving.
  static bool isBusySelector(AppState state) =>
      state.refreshSettings.isLoading || state.refreshSettings.isSaving;
}
