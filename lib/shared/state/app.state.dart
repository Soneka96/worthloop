// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';

/// Root Redux state. Each feature adds its own sub-state here as it is built.
class AppState extends Equatable {
  /// GitHub Explorer feature sub-state.
  final GithubExplorerState githubExplorer;

  /// Tracked-products feature sub-state.
  final ProductsState products;

  const AppState({required this.githubExplorer, required this.products});

  /// Returns the initial state used to initialise the Redux store.
  factory AppState.initial() => AppState(
    githubExplorer: GithubExplorerState.initial(),
    products: ProductsState.initial(),
  );

  /// Returns a copy with the given fields replaced.
  AppState copyWith({
    GithubExplorerState? githubExplorer,
    ProductsState? products,
  }) {
    return AppState(
      githubExplorer: githubExplorer ?? this.githubExplorer,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [githubExplorer, products];
}
