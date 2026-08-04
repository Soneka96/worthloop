// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';

/// Root Redux state. Each feature adds its own sub-state here as it is built.
class AppState extends Equatable {
  /// GitHub Explorer feature sub-state.
  final GithubExplorerState githubExplorer;

  /// Tracked-products feature sub-state.
  final ProductsState products;

  /// Refresh-settings feature sub-state.
  final RefreshSettingsState refreshSettings;

  const AppState({
    required this.githubExplorer,
    required this.products,
    required this.refreshSettings,
  });

  /// Returns the initial state used to initialise the Redux store.
  factory AppState.initial() => AppState(
    githubExplorer: GithubExplorerState.initial(),
    products: ProductsState.initial(),
    refreshSettings: RefreshSettingsState.initial(),
  );

  /// Returns a copy with the given fields replaced.
  AppState copyWith({
    GithubExplorerState? githubExplorer,
    ProductsState? products,
    RefreshSettingsState? refreshSettings,
  }) {
    return AppState(
      githubExplorer: githubExplorer ?? this.githubExplorer,
      products: products ?? this.products,
      refreshSettings: refreshSettings ?? this.refreshSettings,
    );
  }

  @override
  List<Object?> get props => [githubExplorer, products, refreshSettings];
}
