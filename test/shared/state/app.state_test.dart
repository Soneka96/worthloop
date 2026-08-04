// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  group('AppState — initial', () {
    test('AppState.initial includes the default GithubExplorerState', () {
      final AppState state = AppState.initial();

      expect(state.githubExplorer, isA<GithubExplorerState>());
      expect(state.githubExplorer, GithubExplorerState.initial());
      expect(state.products, isA<ProductsState>());
      expect(state.products, ProductsState.initial());
      expect(state.refreshSettings, isA<RefreshSettingsState>());
      expect(state.refreshSettings, RefreshSettingsState.initial());
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

    test('AppState copyWith replaces products when passed', () {
      final AppState state = AppState.initial();
      final ProductsState updatedState = ProductsState.initial().copyWith(
        isLoading: true,
      );

      final AppState next = state.copyWith(products: updatedState);

      expect(next.products, isA<ProductsState>());
      expect(next.products, updatedState);
      final bool isEqual = next == state;
      expect(isEqual, isA<bool>());
      expect(isEqual, isFalse);
    });

    test('AppState copyWith replaces refreshSettings when passed', () {
      final AppState state = AppState.initial();
      final RefreshSettingsState updatedState = RefreshSettingsState.initial()
          .copyWith(intervalMinutes: 180);

      final AppState next = state.copyWith(refreshSettings: updatedState);

      expect(next.refreshSettings, isA<RefreshSettingsState>());
      expect(next.refreshSettings, updatedState);
      final bool isEqual = next == state;
      expect(isEqual, isA<bool>());
      expect(isEqual, isFalse);
    });

    test('AppState copyWith preserves refreshSettings when omitted', () {
      final AppState state = AppState.initial().copyWith(
        refreshSettings: RefreshSettingsState.initial().copyWith(
          intervalMinutes: 180,
        ),
      );

      final AppState next = state.copyWith();

      expect(next.refreshSettings, isA<RefreshSettingsState>());
      expect(next.refreshSettings, state.refreshSettings);
    });
  });
}
