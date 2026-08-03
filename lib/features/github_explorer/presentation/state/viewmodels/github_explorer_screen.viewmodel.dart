// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/screens/github_explorer.screen.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the data required by [GithubExplorerScreen].
class GithubExplorerScreenViewModel extends Equatable {
  /// The most recently found profile, or `null` before any search succeeds.
  final GithubProfile? profile;

  /// Cached profiles, most recently searched first.
  final List<GithubProfile> recentSearches;

  /// Whether a search is currently in flight.
  final bool isSearching;

  /// The most recent search failure's message, or `null`.
  final String? error;

  /// Dispatches [SearchProfileAction] with the given username.
  final void Function(String username) onSearch;

  /// Dispatches [ToggleFavoriteAction] with the given username.
  final void Function(String username) onToggleFavorite;

  /// Dispatches [GoToSettingsAction].
  final void Function() onOpenSettings;

  /// Dispatches [GoToHomeAction].
  final void Function() onGoHome;

  const GithubExplorerScreenViewModel({
    required this.profile,
    required this.recentSearches,
    required this.isSearching,
    required this.error,
    required this.onSearch,
    required this.onToggleFavorite,
    required this.onOpenSettings,
    required this.onGoHome,
  });

  factory GithubExplorerScreenViewModel.fromStore(Store<AppState> store) {
    return GithubExplorerScreenViewModel(
      profile: GithubExplorerSelectors.profileSelector(store.state),
      recentSearches: GithubExplorerSelectors.recentSearchesSelector(
        store.state,
      ),
      isSearching: GithubExplorerSelectors.isSearchingSelector(store.state),
      error: GithubExplorerSelectors.errorSelector(store.state),
      onSearch: (username) => store.dispatch(SearchProfileAction(username)),
      onToggleFavorite: (username) =>
          store.dispatch(ToggleFavoriteAction(username)),
      onOpenSettings: () => store.dispatch(const GoToSettingsAction()),
      onGoHome: () => store.dispatch(const GoToHomeAction()),
    );
  }

  @override
  List<Object?> get props => [profile, recentSearches, isSearching, error];
}
