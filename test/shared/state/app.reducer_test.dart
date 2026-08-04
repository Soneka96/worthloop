// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
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
      expect(
        reducedState.products,
        state.products,
        reason: 'product state is preserved',
      );
    });
  });

  group('AppReducer processes LoadProductsAction correctly', () {
    test('appReducer delegates LoadProductsAction to the feature reducer', () {
      final AppState state = AppState.initial();

      final AppState reducedState = appReducer(
        state,
        const LoadProductsAction(),
      );

      expect(state.products.isLoading, isA<bool>());
      expect(state.products.isLoading, isFalse, reason: 'previous value');
      expect(reducedState.products.isLoading, isA<bool>());
      expect(reducedState.products.isLoading, isTrue, reason: 'new value');
      expect(
        reducedState.githubExplorer,
        state.githubExplorer,
        reason: 'GitHub state is preserved',
      );
    });
  });
}
