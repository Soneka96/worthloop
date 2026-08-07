// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the actions available on [GeneralSettingsScreen].
class GeneralSettingsScreenViewModel extends Equatable {
  /// Preferred refresh interval in minutes.
  final int refreshIntervalMinutes;

  /// Whether browser-backed background refresh is enabled.
  final bool browserRefreshEnabled;

  /// Whether refresh settings are loading or saving.
  final bool isRefreshIntervalBusy;

  /// Dispatches [CheckForUpdatesAction].
  final void Function() onCheckForUpdates;

  /// Dispatches [OpenPrivacyPolicyAction].
  final void Function() onOpenPrivacyPolicy;

  /// Dispatches [SaveRefreshIntervalAction].
  final void Function(int intervalMinutes) onRefreshIntervalSelected;

  /// Dispatches [SaveBrowserRefreshEnabledAction].
  final void Function(bool enabled) onBrowserRefreshEnabledChanged;

  /// Dispatches [OpenBackgroundRestrictionsAction].
  final void Function() onOpenBackgroundRestrictions;

  const GeneralSettingsScreenViewModel({
    required this.refreshIntervalMinutes,
    required this.browserRefreshEnabled,
    required this.isRefreshIntervalBusy,
    required this.onCheckForUpdates,
    required this.onOpenPrivacyPolicy,
    required this.onRefreshIntervalSelected,
    required this.onBrowserRefreshEnabledChanged,
    required this.onOpenBackgroundRestrictions,
  });

  /// Builds a view model backed by [store].
  factory GeneralSettingsScreenViewModel.fromStore(Store<AppState> store) {
    return GeneralSettingsScreenViewModel(
      refreshIntervalMinutes: RefreshSettingsSelectors.intervalMinutesSelector(
        store.state,
      ),
      browserRefreshEnabled:
          RefreshSettingsSelectors.browserRefreshEnabledSelector(store.state),
      isRefreshIntervalBusy: RefreshSettingsSelectors.isBusySelector(
        store.state,
      ),
      onCheckForUpdates: () => store.dispatch(const CheckForUpdatesAction()),
      onOpenPrivacyPolicy: () =>
          store.dispatch(const OpenPrivacyPolicyAction()),
      onRefreshIntervalSelected: (int intervalMinutes) =>
          store.dispatch(SaveRefreshIntervalAction(intervalMinutes)),
      onBrowserRefreshEnabledChanged: (bool enabled) =>
          store.dispatch(SaveBrowserRefreshEnabledAction(enabled)),
      onOpenBackgroundRestrictions: () =>
          store.dispatch(const OpenBackgroundRestrictionsAction()),
    );
  }

  @override
  List<Object?> get props => [
    refreshIntervalMinutes,
    browserRefreshEnabled,
    isRefreshIntervalBusy,
  ];
}
