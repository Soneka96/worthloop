// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the data required by [GeneralSettingsScreen].
class GeneralSettingsScreenViewModel extends Equatable {
  /// The default folder for new projects, or `null` if none has been set.
  final String? defaultSaveLocation;

  /// The folder queued to become the new data root on next launch, or
  /// `null` if no move is pending.
  final String? pendingDataRoot;

  /// Dispatches [PickDefaultSaveLocationAction].
  final void Function(String path) onPickDefaultSaveLocation;

  /// Dispatches [RestartNowAction].
  final void Function() onRestartNow;

  /// Dispatches [CheckForUpdatesAction].
  final void Function() onCheckForUpdates;

  /// Dispatches [OpenPrivacyPolicyAction].
  final void Function() onOpenPrivacyPolicy;

  const GeneralSettingsScreenViewModel({
    required this.defaultSaveLocation,
    required this.pendingDataRoot,
    required this.onPickDefaultSaveLocation,
    required this.onRestartNow,
    required this.onCheckForUpdates,
    required this.onOpenPrivacyPolicy,
  });

  factory GeneralSettingsScreenViewModel.fromStore(Store<AppState> store) {
    return GeneralSettingsScreenViewModel(
      defaultSaveLocation: GeneralSettingsSelectors.defaultSaveLocationSelector(
        store.state,
      ),
      pendingDataRoot: GeneralSettingsSelectors.pendingDataRootSelector(
        store.state,
      ),
      onPickDefaultSaveLocation: (path) =>
          store.dispatch(PickDefaultSaveLocationAction(path)),
      onRestartNow: () => store.dispatch(const RestartNowAction()),
      onCheckForUpdates: () => store.dispatch(const CheckForUpdatesAction()),
      onOpenPrivacyPolicy: () =>
          store.dispatch(const OpenPrivacyPolicyAction()),
    );
  }

  @override
  List<Object?> get props => [
    defaultSaveLocation,
    pendingDataRoot,
  ];
}
