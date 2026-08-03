// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the actions available on [GeneralSettingsScreen].
class GeneralSettingsScreenViewModel extends Equatable {
  /// Dispatches [CheckForUpdatesAction].
  final void Function() onCheckForUpdates;

  /// Dispatches [OpenPrivacyPolicyAction].
  final void Function() onOpenPrivacyPolicy;

  const GeneralSettingsScreenViewModel({
    required this.onCheckForUpdates,
    required this.onOpenPrivacyPolicy,
  });

  /// Builds a view model backed by [store].
  factory GeneralSettingsScreenViewModel.fromStore(Store<AppState> store) {
    return GeneralSettingsScreenViewModel(
      onCheckForUpdates: () => store.dispatch(const CheckForUpdatesAction()),
      onOpenPrivacyPolicy: () =>
          store.dispatch(const OpenPrivacyPolicyAction()),
    );
  }

  @override
  List<Object?> get props => [];
}
