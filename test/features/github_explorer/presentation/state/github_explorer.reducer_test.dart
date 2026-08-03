// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.reducer.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import '../../fixtures/github_profile.fixture.dart';

void main() {
  group('githubExplorerReducer processes SearchProfileAction correctly', () {
    test(
      'githubExplorerReducer updates isSearching from SearchProfileAction',
      () {
        final GithubExplorerState state = GithubExplorerState.initial();
        final GithubExplorerState reducedState = githubExplorerReducer(
          state,
          const SearchProfileAction('octocat'),
        );

        expect(state.isSearching, isFalse, reason: 'previous value');
        expect(reducedState.isSearching, isTrue, reason: 'new value');
      },
    );
  });

  group('githubExplorerReducer processes ProfileFoundAction correctly', () {
    test(
      'githubExplorerReducer updates profile, isSearching, and error from ProfileFoundAction',
      () {
        final GithubProfile profile = buildGithubProfile();
        final GithubExplorerState state = GithubExplorerState.initial()
            .copyWith(isSearching: true);
        final GithubExplorerState reducedState = githubExplorerReducer(
          state,
          ProfileFoundAction(profile),
        );

        expect(state.profile, isNull, reason: 'previous value');
        expect(reducedState.profile, profile, reason: 'new value');
        expect(state.isSearching, isTrue, reason: 'previous value');
        expect(reducedState.isSearching, isFalse, reason: 'new value');
        expect(reducedState.error, isNull, reason: 'new value');
      },
    );
  });

  group('githubExplorerReducer processes SearchFailedAction correctly', () {
    test(
      'githubExplorerReducer updates error and isSearching from SearchFailedAction',
      () {
        final GithubExplorerState state = GithubExplorerState.initial()
            .copyWith(isSearching: true);
        final GithubExplorerState reducedState = githubExplorerReducer(
          state,
          const SearchFailedAction('boom'),
        );

        expect(state.error, isNull, reason: 'previous value');
        expect(reducedState.error, 'boom', reason: 'new value');
        expect(state.isSearching, isTrue, reason: 'previous value');
        expect(reducedState.isSearching, isFalse, reason: 'new value');
      },
    );
  });

  group(
    'githubExplorerReducer processes RecentSearchesLoadedAction correctly',
    () {
      test(
        'githubExplorerReducer updates recentSearches from RecentSearchesLoadedAction',
        () {
          final GithubProfile profile = buildGithubProfile();
          final GithubExplorerState state = GithubExplorerState.initial();
          final GithubExplorerState reducedState = githubExplorerReducer(
            state,
            RecentSearchesLoadedAction([profile]),
          );

          expect(state.recentSearches, isEmpty, reason: 'previous value');
          expect(reducedState.recentSearches, [profile], reason: 'new value');
        },
      );
    },
  );

  group('githubExplorerReducer processes unhandled actions correctly', () {
    test('LoadRecentSearchesAction modifies nothing', () {
      final GithubExplorerState state = GithubExplorerState.initial();
      final GithubExplorerState reducedState = githubExplorerReducer(
        state,
        const LoadRecentSearchesAction(),
      );

      expect(reducedState, state);
    });

    test('ToggleFavoriteAction modifies nothing', () {
      final GithubExplorerState state = GithubExplorerState.initial();
      final GithubExplorerState reducedState = githubExplorerReducer(
        state,
        const ToggleFavoriteAction('octocat'),
      );

      expect(reducedState, state);
    });
  });
}
