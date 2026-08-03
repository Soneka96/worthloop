// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Static selectors over [AppState] for the General settings category.
abstract final class GeneralSettingsSelectors {
  /// The selector extracts [GeneralSettingsState.defaultSaveLocation] from
  /// [AppState] and returns it.
  static String? defaultSaveLocationSelector(AppState state) =>
      state.generalSettings.defaultSaveLocation;

  /// The selector extracts [GeneralSettingsState.pendingDataRoot] from
  /// [AppState] and returns it.
  static String? pendingDataRootSelector(AppState state) =>
      state.generalSettings.pendingDataRoot;
}
