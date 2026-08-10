// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/notifications_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the actions available on [NotificationsSettingsScreen].
class NotificationsSettingsScreenViewModel extends Equatable {
  /// Whether product price-drop notifications are enabled.
  final bool priceDropAlertsEnabled;

  /// Whether product price-increase notifications are enabled.
  final bool priceIncreaseAlertsEnabled;

  /// Whether a notification is shown for every completed background refresh.
  final bool refreshCompletedAlertsEnabled;

  /// Whether the background refresh shows a progress bar on its
  /// notification while sources are being fetched.
  final bool showRefreshProgress;

  /// Whether refresh settings are loading or saving.
  final bool isBusy;

  /// Dispatches [SavePriceAlertsEnabledAction].
  final void Function(bool enabled) onPriceDropAlertsEnabledChanged;

  /// Dispatches [SavePriceIncreaseAlertsEnabledAction].
  final void Function(bool enabled) onPriceIncreaseAlertsEnabledChanged;

  /// Dispatches [SaveRefreshCompletedAlertsEnabledAction].
  final void Function(bool enabled) onRefreshCompletedAlertsEnabledChanged;

  /// Dispatches [SaveShowRefreshProgressAction].
  final void Function(bool enabled) onShowRefreshProgressChanged;

  const NotificationsSettingsScreenViewModel({
    required this.priceDropAlertsEnabled,
    required this.priceIncreaseAlertsEnabled,
    required this.refreshCompletedAlertsEnabled,
    required this.showRefreshProgress,
    required this.isBusy,
    required this.onPriceDropAlertsEnabledChanged,
    required this.onPriceIncreaseAlertsEnabledChanged,
    required this.onRefreshCompletedAlertsEnabledChanged,
    required this.onShowRefreshProgressChanged,
  });

  /// Builds a view model backed by [store].
  factory NotificationsSettingsScreenViewModel.fromStore(
    Store<AppState> store,
  ) {
    return NotificationsSettingsScreenViewModel(
      priceDropAlertsEnabled:
          RefreshSettingsSelectors.priceAlertsEnabledSelector(store.state),
      priceIncreaseAlertsEnabled:
          RefreshSettingsSelectors.priceIncreaseAlertsEnabledSelector(
            store.state,
          ),
      refreshCompletedAlertsEnabled:
          RefreshSettingsSelectors.refreshCompletedAlertsEnabledSelector(
            store.state,
          ),
      showRefreshProgress: RefreshSettingsSelectors.showRefreshProgressSelector(
        store.state,
      ),
      isBusy: RefreshSettingsSelectors.isBusySelector(store.state),
      onPriceDropAlertsEnabledChanged: (bool enabled) =>
          store.dispatch(SavePriceAlertsEnabledAction(enabled)),
      onPriceIncreaseAlertsEnabledChanged: (bool enabled) =>
          store.dispatch(SavePriceIncreaseAlertsEnabledAction(enabled)),
      onRefreshCompletedAlertsEnabledChanged: (bool enabled) =>
          store.dispatch(SaveRefreshCompletedAlertsEnabledAction(enabled)),
      onShowRefreshProgressChanged: (bool enabled) =>
          store.dispatch(SaveShowRefreshProgressAction(enabled)),
    );
  }

  @override
  List<Object?> get props => [
    priceDropAlertsEnabled,
    priceIncreaseAlertsEnabled,
    refreshCompletedAlertsEnabled,
    showRefreshProgress,
    isBusy,
  ];
}
