// Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';

/// Reducer responsible for handling changes to [GithubExplorerState] based on
/// dispatched actions.
///
/// [LoadRecentSearchesAction] and [ToggleFavoriteAction] are middleware-only
/// triggers with no state of their own — neither has a [TypedReducer] here,
/// so `combineReducers` leaves the state unchanged for them.
Reducer<GithubExplorerState> githubExplorerReducer =
    combineReducers<GithubExplorerState>([
      /// Handles a search starting. Updates [GithubExplorerState.isSearching].
      TypedReducer<GithubExplorerState, SearchProfileAction>(
        searchProfileReducer,
      ).call,

      /// Handles a search succeeding.
      /// Updates [GithubExplorerState.profile], [GithubExplorerState.isSearching],
      /// [GithubExplorerState.error].
      TypedReducer<GithubExplorerState, ProfileFoundAction>(
        profileFoundReducer,
      ).call,

      /// Handles a search failing.
      /// Updates [GithubExplorerState.error], [GithubExplorerState.isSearching].
      TypedReducer<GithubExplorerState, SearchFailedAction>(
        searchFailedReducer,
      ).call,

      /// Handles cached profiles being loaded.
      /// Updates [GithubExplorerState.recentSearches].
      TypedReducer<GithubExplorerState, RecentSearchesLoadedAction>(
        recentSearchesLoadedReducer,
      ).call,
    ]);

/// Handles a search starting. Updates [GithubExplorerState.isSearching].
GithubExplorerState searchProfileReducer(
  GithubExplorerState state,
  SearchProfileAction action,
) => state.copyWith(isSearching: true);

/// Handles a search succeeding.
/// Updates [GithubExplorerState.profile], [GithubExplorerState.isSearching],
/// [GithubExplorerState.error].
GithubExplorerState profileFoundReducer(
  GithubExplorerState state,
  ProfileFoundAction action,
) => state.copyWith(
  profile: action.profile,
  isSearching: false,
  error: const None(),
);

/// Handles a search failing.
/// Updates [GithubExplorerState.error], [GithubExplorerState.isSearching].
GithubExplorerState searchFailedReducer(
  GithubExplorerState state,
  SearchFailedAction action,
) => state.copyWith(isSearching: false, error: Some(action.message));

/// Handles cached profiles being loaded.
/// Updates [GithubExplorerState.recentSearches].
GithubExplorerState recentSearchesLoadedReducer(
  GithubExplorerState state,
  RecentSearchesLoadedAction action,
) => state.copyWith(recentSearches: action.profiles);
