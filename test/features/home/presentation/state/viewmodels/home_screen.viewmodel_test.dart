// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  late List<dynamic> dispatchedActions;

  Store<AppState> buildStore() {
    return Store<AppState>((AppState appState, dynamic action) {
      dispatchedActions.add(action);
      return appState;
    }, initialState: AppState.initial());
  }

  setUp(() {
    dispatchedActions = [];
  });

  group(
    'HomeScreenViewModel constructor initializes all parameters correctly',
    () {
      test(
        'Method onOpenGithubExplorer dispatches GoToGithubExplorerAction when called',
        () {
          final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
            buildStore(),
          );

          viewmodel.onOpenGithubExplorer();

          expect(dispatchedActions, [const GoToGithubExplorerAction()]);
        },
      );

      test(
        'Method onOpenSettings dispatches GoToSettingsAction when called',
        () {
          final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
            buildStore(),
          );

          viewmodel.onOpenSettings();

          expect(dispatchedActions, [const GoToSettingsAction()]);
        },
      );
    },
  );
}
