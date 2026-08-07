// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// ViewModel representing the data required by [HomeScreen].
class HomeScreenViewModel extends Equatable {
  /// Tracked products to display.
  final List<Product> products;

  /// Most recent update time across tracked products, or `null` when empty.
  final DateTime? latestUpdatedAt;

  /// Oldest update time across tracked products, or `null` when empty.
  final DateTime? oldestUpdatedAt;

  /// Whether the initial product load is active.
  final bool isLoading;

  /// Whether every product is being refreshed.
  final bool isRefreshingAll;

  /// Whether any product or source refresh is active.
  final bool isRefreshing;

  /// Number of sources that have reached a terminal state.
  final int refreshCompletedCount;

  /// Number of sources included in the active refresh.
  final int refreshTotalCount;

  /// Preferred foreground refresh interval in minutes.
  final int refreshIntervalMinutes;

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
    required this.latestUpdatedAt,
    required this.oldestUpdatedAt,
    required this.isLoading,
    required this.isRefreshingAll,
    required this.isRefreshing,
    required this.refreshCompletedCount,
    required this.refreshTotalCount,
    required this.refreshIntervalMinutes,
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
      latestUpdatedAt: ProductsSelectors.latestUpdatedAtSelector(store.state),
      oldestUpdatedAt: ProductsSelectors.oldestUpdatedAtSelector(store.state),
      isLoading: ProductsSelectors.isLoadingSelector(store.state),
      isRefreshingAll: ProductsSelectors.isRefreshingAllSelector(store.state),
      isRefreshing: ProductsSelectors.isRefreshingSelector(store.state),
      refreshCompletedCount: ProductsSelectors.refreshCompletedCountSelector(
        store.state,
      ),
      refreshTotalCount: ProductsSelectors.refreshTotalCountSelector(
        store.state,
      ),
      refreshIntervalMinutes: RefreshSettingsSelectors.intervalMinutesSelector(
        store.state,
      ),
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
    latestUpdatedAt,
    oldestUpdatedAt,
    isLoading,
    isRefreshingAll,
    isRefreshing,
    refreshCompletedCount,
    refreshTotalCount,
    refreshIntervalMinutes,
    isCreatingProduct,
    productCreationError,
    refreshStatus,
    createdProductId,
  ];
}
