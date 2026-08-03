// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  group('AppState — initial', () {
    test('AppState.initial includes the default GithubExplorerState', () {
      final AppState state = AppState.initial();

      expect(state.githubExplorer, isA<GithubExplorerState>());
      expect(state.githubExplorer, GithubExplorerState.initial());
    });
  });

  group('AppState — copyWith', () {
    test('AppState copyWith replaces githubExplorer when passed', () {
      final AppState state = AppState.initial();
      final GithubExplorerState updatedState = GithubExplorerState.initial()
          .copyWith(isSearching: true);

      final AppState next = state.copyWith(githubExplorer: updatedState);

      expect(next.githubExplorer, isA<GithubExplorerState>());
      expect(next.githubExplorer, updatedState);
    });

    test('AppState copyWith preserves githubExplorer when omitted', () {
      final AppState state = AppState.initial();

      final AppState next = state.copyWith();

      expect(next.githubExplorer, isA<GithubExplorerState>());
      expect(next.githubExplorer, state.githubExplorer);
    });
  });
}
