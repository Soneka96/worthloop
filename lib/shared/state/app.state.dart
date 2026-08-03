// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';

/// Root Redux state. Each feature adds its own sub-state here as it is built.
class AppState extends Equatable {
  /// GitHub Explorer feature sub-state.
  final GithubExplorerState githubExplorer;

  const AppState({required this.githubExplorer});

  /// Returns the initial state used to initialise the Redux store.
  factory AppState.initial() =>
      AppState(githubExplorer: GithubExplorerState.initial());

  /// Returns a copy with the given fields replaced.
  AppState copyWith({GithubExplorerState? githubExplorer}) {
    return AppState(githubExplorer: githubExplorer ?? this.githubExplorer);
  }

  @override
  List<Object?> get props => [githubExplorer];
}
