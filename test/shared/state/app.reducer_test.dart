// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/shared/state/app.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  group('AppReducer processes SearchProfileAction correctly', () {
    test('appReducer delegates SearchProfileAction to the feature reducer', () {
      final AppState state = AppState.initial();

      final AppState reducedState = appReducer(
        state,
        const SearchProfileAction('octocat'),
      );

      expect(
        state.githubExplorer.isSearching,
        isFalse,
        reason: 'previous value',
      );
      expect(
        reducedState.githubExplorer.isSearching,
        isTrue,
        reason: 'new value',
      );
    });
  });
}
