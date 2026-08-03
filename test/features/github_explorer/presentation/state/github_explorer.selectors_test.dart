// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.selectors.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/github_profile.fixture.dart';

void main() {
  group(
    'Method profileSelector() returns a GithubProfile instance',
    () {
      test('profileSelector() returns the githubExplorer profile', () {
        final GithubProfile profile = buildGithubProfile();
        final AppState state = AppState.initial().copyWith(
          githubExplorer: GithubExplorerState.initial().copyWith(
            profile: profile,
          ),
        );

        expect(GithubExplorerSelectors.profileSelector(state), profile);
      });
    },
  );

  group(
    'Method recentSearchesSelector() returns a List<GithubProfile> instance',
    () {
      test('recentSearchesSelector() returns the githubExplorer recentSearches', () {
        final AppState state = AppState.initial().copyWith(
          githubExplorer: GithubExplorerState.initial().copyWith(
            recentSearches: [buildGithubProfile()],
          ),
        );

        expect(GithubExplorerSelectors.recentSearchesSelector(state), hasLength(1));
      });
    },
  );

  group('Method isSearchingSelector() returns a bool instance', () {
    test('isSearchingSelector() returns the githubExplorer isSearching', () {
      final AppState state = AppState.initial().copyWith(
        githubExplorer: GithubExplorerState.initial().copyWith(
          isSearching: true,
        ),
      );

      expect(GithubExplorerSelectors.isSearchingSelector(state), isTrue);
    });
  });

  group('Method errorSelector() returns a String instance', () {
    test('errorSelector() returns the githubExplorer error', () {
      final AppState state = AppState.initial().copyWith(
        githubExplorer: GithubExplorerState.initial().copyWith(
          error: const Some('boom'),
        ),
      );

      expect(GithubExplorerSelectors.errorSelector(state), 'boom');
    });
  });
}
