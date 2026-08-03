// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/load_recent_searches.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/search_profile.params.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/toggle_favorite.params.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/search_profile.usecase.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/toggle_favorite.usecase.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';

/// Handles GitHub Explorer actions. Added to [CreateStore]'s middleware
/// list — see `lib/shared/state/create_store.dart`.
class GithubExplorerMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case SearchProfileAction _:
        _searchProfile(store, action);
      case LoadRecentSearchesAction _:
        _loadRecentSearches(store);
      case ToggleFavoriteAction _:
        _toggleFavorite(store, action);
      case GoToSettingsAction _:
        _goToSettings();
      case GoToHomeAction _:
        _goToHome();
    }
  }

  /// Handles [SearchProfileAction]. Dispatches [ProfileFoundAction] on
  /// success, or [SearchFailedAction] on failure — then re-dispatches
  /// [LoadRecentSearchesAction] either way, since a successful search caches
  /// a new/updated row and a fail-open fallback still touches the cache's
  /// `fetchedAt` ordering.
  Future<void> _searchProfile(
    Store<AppState> store,
    SearchProfileAction action,
  ) async {
    await (await sl<SearchProfileUseCase>()(
      SearchProfileParams(username: action.username),
    )).fold(
      (failure) async {
        store.dispatch(SearchFailedAction(failure.message));
      },
      (GithubProfile profile) async {
        store.dispatch(ProfileFoundAction(profile));
      },
    );
    store.dispatch(const LoadRecentSearchesAction());
  }

  /// Handles [LoadRecentSearchesAction]. Loads every cached profile, then
  /// dispatches [RecentSearchesLoadedAction] — silently keeps the previous
  /// list on failure, since this is a background refresh, not a
  /// user-initiated action with its own error surface.
  Future<void> _loadRecentSearches(Store<AppState> store) async {
    await (await sl<LoadRecentSearchesUseCase>()(NoParams())).fold(
      (_) async {},
      (List<GithubProfile> profiles) async {
        store.dispatch(RecentSearchesLoadedAction(profiles));
      },
    );
  }

  /// Handles [ToggleFavoriteAction]. Flips the cached favorite flag, then
  /// re-dispatches [LoadRecentSearchesAction] to refresh the list with the
  /// new state.
  Future<void> _toggleFavorite(
    Store<AppState> store,
    ToggleFavoriteAction action,
  ) async {
    await sl<ToggleFavoriteUseCase>()(
      ToggleFavoriteParams(username: action.username),
    );
    store.dispatch(const LoadRecentSearchesAction());
  }

  /// Handles [GoToSettingsAction]. Navigates to the app settings screen.
  void _goToSettings() {
    sl<NavigatorService>().push(AppRoutes.appSettings);
  }

  /// Handles [GoToHomeAction]. Pops back to Home — this screen is only ever
  /// reached by pushing from Home, so Home is always underneath.
  void _goToHome() {
    sl<NavigatorService>().pop();
  }
}
