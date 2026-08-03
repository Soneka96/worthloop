// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/viewmodels/github_explorer_screen.viewmodel.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../fixtures/github_profile.fixture.dart';

void main() {
  late List<dynamic> dispatchedActions;

  Store<AppState> buildStore(GithubExplorerState state) {
    return Store<AppState>((AppState appState, dynamic action) {
      dispatchedActions.add(action);
      return appState;
    }, initialState: AppState.initial().copyWith(githubExplorer: state));
  }

  setUp(() {
    dispatchedActions = [];
  });

  group(
    'GithubExplorerScreenViewModel constructor initializes all parameters correctly',
    () {
      test(
        'Method fromStore() constructs GithubExplorerScreenViewModel correctly',
        () {
          final GithubProfile profile = buildGithubProfile();
          final GithubExplorerScreenViewModel viewmodel =
              GithubExplorerScreenViewModel.fromStore(
                buildStore(
                  GithubExplorerState.initial().copyWith(
                    profile: profile,
                    recentSearches: [profile],
                    isSearching: true,
                    error: const Some('boom'),
                  ),
                ),
              );

          expect(viewmodel.profile, profile);
          expect(viewmodel.recentSearches, [profile]);
          expect(viewmodel.isSearching, isTrue);
          expect(viewmodel.error, 'boom');
        },
      );

      test(
        'Method onSearch dispatches SearchProfileAction with the given username when called',
        () {
          final GithubExplorerScreenViewModel viewmodel =
              GithubExplorerScreenViewModel.fromStore(
                buildStore(GithubExplorerState.initial()),
              );

          viewmodel.onSearch('octocat');

          expect(dispatchedActions, [const SearchProfileAction('octocat')]);
        },
      );

      test(
        'Method onToggleFavorite dispatches ToggleFavoriteAction with the given username when called',
        () {
          final GithubExplorerScreenViewModel viewmodel =
              GithubExplorerScreenViewModel.fromStore(
                buildStore(GithubExplorerState.initial()),
              );

          viewmodel.onToggleFavorite('octocat');

          expect(dispatchedActions, [const ToggleFavoriteAction('octocat')]);
        },
      );

      test(
        'Method onOpenSettings dispatches GoToSettingsAction when called',
        () {
          final GithubExplorerScreenViewModel viewmodel =
              GithubExplorerScreenViewModel.fromStore(
                buildStore(GithubExplorerState.initial()),
              );

          viewmodel.onOpenSettings();

          expect(dispatchedActions, [const GoToSettingsAction()]);
        },
      );

      test('Method onGoHome dispatches GoToHomeAction when called', () {
        final GithubExplorerScreenViewModel viewmodel =
            GithubExplorerScreenViewModel.fromStore(
              buildStore(GithubExplorerState.initial()),
            );

        viewmodel.onGoHome();

        expect(dispatchedActions, [const GoToHomeAction()]);
      });
    },
  );
}
