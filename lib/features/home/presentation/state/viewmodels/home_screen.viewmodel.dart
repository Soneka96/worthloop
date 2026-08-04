// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the data required by [HomeScreen].
class HomeScreenViewModel extends Equatable {
  /// Tracked products to display.
  final List<Product> products;

  /// Whether the initial product load is active.
  final bool isLoading;

  /// Whether every product is being refreshed.
  final bool isRefreshingAll;

  /// Dispatches [RefreshAllProductsAction].
  final void Function() onRefreshAll;

  /// Dispatches [GoToSettingsAction].
  final void Function() onOpenSettings;

  /// Dispatches [GoToProductDetailsAction].
  final void Function(String productId) onOpenProduct;

  const HomeScreenViewModel({
    required this.products,
    required this.isLoading,
    required this.isRefreshingAll,
    required this.onRefreshAll,
    required this.onOpenSettings,
    required this.onOpenProduct,
  });

  factory HomeScreenViewModel.fromStore(Store<AppState> store) {
    return HomeScreenViewModel(
      products: ProductsSelectors.productsSelector(store.state),
      isLoading: ProductsSelectors.isLoadingSelector(store.state),
      isRefreshingAll: ProductsSelectors.isRefreshingAllSelector(store.state),
      onRefreshAll: () => store.dispatch(const RefreshAllProductsAction()),
      onOpenSettings: () => store.dispatch(const GoToSettingsAction()),
      onOpenProduct: (String productId) =>
          store.dispatch(GoToProductDetailsAction(productId)),
    );
  }

  @override
  List<Object?> get props => [products, isLoading, isRefreshingAll];
}
