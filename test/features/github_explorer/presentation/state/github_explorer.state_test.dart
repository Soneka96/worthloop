// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import '../../fixtures/github_profile.fixture.dart';

void main() {
  group('GithubExplorerState — initial', () {
    test(
      'GithubExplorerState.initial has no profile, no recent searches, isSearching = false, and no error',
      () {
        final GithubExplorerState state = GithubExplorerState.initial();

        expect(state.profile, isNull);
        expect(state.recentSearches, isEmpty);
        expect(state.isSearching, isFalse);
        expect(state.error, isNull);
      },
    );
  });

  group('GithubExplorerState — copyWith', () {
    test('GithubExplorerState copyWith replaces profile when passed', () {
      final GithubExplorerState state = GithubExplorerState.initial();
      final GithubProfile profile = buildGithubProfile();

      final GithubExplorerState next = state.copyWith(profile: profile);

      expect(next.profile, profile);
    });

    test(
      'GithubExplorerState copyWith replaces recentSearches when passed',
      () {
        final GithubExplorerState state = GithubExplorerState.initial();
        final List<GithubProfile> searches = [buildGithubProfile()];

        final GithubExplorerState next = state.copyWith(
          recentSearches: searches,
        );

        expect(next.recentSearches, searches);
      },
    );

    test('GithubExplorerState copyWith replaces isSearching when passed', () {
      final GithubExplorerState state = GithubExplorerState.initial();

      final GithubExplorerState next = state.copyWith(isSearching: true);

      expect(next.isSearching, isTrue);
    });

    test('GithubExplorerState copyWith replaces error when passed Some', () {
      final GithubExplorerState state = GithubExplorerState.initial();

      final GithubExplorerState next = state.copyWith(
        error: const Some('boom'),
      );

      expect(next.error, 'boom');
    });

    test('GithubExplorerState copyWith clears error when passed None', () {
      final GithubExplorerState state = GithubExplorerState.initial().copyWith(
        error: const Some('boom'),
      );

      final GithubExplorerState next = state.copyWith(error: const None());

      expect(next.error, isNull);
    });

    test('GithubExplorerState copyWith preserves profile when omitted', () {
      final GithubExplorerState state = GithubExplorerState.initial().copyWith(
        profile: buildGithubProfile(),
      );

      final GithubExplorerState next = state.copyWith();

      expect(next.profile, state.profile);
    });

    test('GithubExplorerState copyWith preserves error when omitted', () {
      final GithubExplorerState state = GithubExplorerState.initial().copyWith(
        error: const Some('boom'),
      );

      final GithubExplorerState next = state.copyWith();

      expect(next.error, state.error);
    });
  });
}
