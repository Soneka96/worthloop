// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Static selectors over [AppState] for the GitHub Explorer feature.
abstract final class GithubExplorerSelectors {
  /// The selector extracts [GithubExplorerState.profile] from [AppState] and
  /// returns it.
  static GithubProfile? profileSelector(AppState state) =>
      state.githubExplorer.profile;

  /// The selector extracts [GithubExplorerState.recentSearches] from
  /// [AppState] and returns it.
  static List<GithubProfile> recentSearchesSelector(AppState state) =>
      state.githubExplorer.recentSearches;

  /// The selector extracts [GithubExplorerState.isSearching] from [AppState]
  /// and returns it.
  static bool isSearchingSelector(AppState state) =>
      state.githubExplorer.isSearching;

  /// The selector extracts [GithubExplorerState.error] from [AppState] and
  /// returns it.
  static String? errorSelector(AppState state) => state.githubExplorer.error;
}
