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
import 'package:worth_loop/shared/constants/enums.dart';

/// ViewModel representing the data required by [HomeScreen].
class HomeScreenViewModel extends Equatable {
  /// Tracked products to display.
  final List<Product> products;

  /// Whether the initial product load is active.
  final bool isLoading;

  /// Whether every product is being refreshed.
  final bool isRefreshingAll;

  /// Whether a product is being created.
  final bool isCreatingProduct;

  /// The latest product-creation failure, or `null`.
  final String? productCreationError;

  /// Classified reason for the latest refresh failure, or `null`.
  final PriceFetchStatus? refreshStatus;

  /// Identifier of the latest created product, or `null`.
  final String? createdProductId;

  /// Dispatches [RefreshAllProductsAction].
  final void Function() onRefreshAll;

  /// Dispatches [GoToSettingsAction].
  final void Function() onOpenSettings;

  /// Dispatches [GoToProductDetailsAction].
  final void Function(String productId) onOpenProduct;

  /// Dispatches [CreateProductAction].
  final void Function(String name) onCreateProduct;

  const HomeScreenViewModel({
    required this.products,
    required this.isLoading,
    required this.isRefreshingAll,
    required this.isCreatingProduct,
    required this.productCreationError,
    this.refreshStatus,
    required this.createdProductId,
    required this.onRefreshAll,
    required this.onOpenSettings,
    required this.onOpenProduct,
    required this.onCreateProduct,
  });

  factory HomeScreenViewModel.fromStore(Store<AppState> store) {
    return HomeScreenViewModel(
      products: ProductsSelectors.productsSelector(store.state),
      isLoading: ProductsSelectors.isLoadingSelector(store.state),
      isRefreshingAll: ProductsSelectors.isRefreshingAllSelector(store.state),
      isCreatingProduct: ProductsSelectors.isCreatingProductSelector(
        store.state,
      ),
      productCreationError: ProductsSelectors.productCreationErrorSelector(
        store.state,
      ),
      refreshStatus: ProductsSelectors.refreshStatusSelector(store.state),
      createdProductId: ProductsSelectors.createdProductIdSelector(store.state),
      onRefreshAll: () => store.dispatch(const RefreshAllProductsAction()),
      onOpenSettings: () => store.dispatch(const GoToSettingsAction()),
      onOpenProduct: (String productId) =>
          store.dispatch(GoToProductDetailsAction(productId)),
      onCreateProduct: (String name) =>
          store.dispatch(CreateProductAction(name: name)),
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoading,
    isRefreshingAll,
    isCreatingProduct,
    productCreationError,
    refreshStatus,
    createdProductId,
  ];
}
