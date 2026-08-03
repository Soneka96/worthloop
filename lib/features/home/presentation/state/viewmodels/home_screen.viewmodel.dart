// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the data required by [HomeScreen].
class HomeScreenViewModel extends Equatable {
  /// Dispatches [GoToGithubExplorerAction].
  final void Function() onOpenGithubExplorer;

  /// Dispatches [GoToSettingsAction].
  final void Function() onOpenSettings;

  const HomeScreenViewModel({
    required this.onOpenGithubExplorer,
    required this.onOpenSettings,
  });

  factory HomeScreenViewModel.fromStore(Store<AppState> store) {
    return HomeScreenViewModel(
      onOpenGithubExplorer: () =>
          store.dispatch(const GoToGithubExplorerAction()),
      onOpenSettings: () => store.dispatch(const GoToSettingsAction()),
    );
  }

  @override
  List<Object?> get props => [];
}
