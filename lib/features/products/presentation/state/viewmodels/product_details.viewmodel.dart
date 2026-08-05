// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/screens/product_details.screen.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// ViewModel representing the data required by [ProductDetailsScreen].
class ProductDetailsViewModel extends Equatable {
  /// Product currently displayed, or `null` when it is missing.
  final Product? product;

  /// Whether this product is being refreshed.
  final bool isRefreshing;

  /// Classified reason for the latest refresh failure, or `null`.
  final PriceFetchStatus? refreshStatus;

  // TODO: sources and isLoadingSources are not yet read by
  // ProductDetailsScreen — the Sources section UI that consumes them lands
  // in a later phase-3 step.
  /// Saved website sources for this product.
  final List<ProductSource> sources;

  /// Whether this product's sources are being loaded.
  final bool isLoadingSources;

  /// Dispatches [RefreshProductAction].
  final void Function() onRefresh;

  /// Dispatches [GoBackFromProductDetailsAction].
  final void Function() onGoBack;

  const ProductDetailsViewModel({
    required this.product,
    required this.isRefreshing,
    this.refreshStatus,
    required this.sources,
    required this.isLoadingSources,
    required this.onRefresh,
    required this.onGoBack,
  });

  /// Creates the details state for [productId].
  factory ProductDetailsViewModel.fromStore(
    Store<AppState> store,
    String productId,
  ) => ProductDetailsViewModel(
    product: ProductsSelectors.productSelector(store.state, productId),
    isRefreshing: ProductsSelectors.isRefreshingProductSelector(
      store.state,
      productId,
    ),
    refreshStatus: ProductsSelectors.refreshStatusForProductSelector(
      store.state,
      productId,
    ),
    sources: ProductsSelectors.sourcesForProductSelector(
      store.state,
      productId,
    ),
    isLoadingSources: ProductsSelectors.isLoadingSourcesSelector(
      store.state,
      productId,
    ),
    onRefresh: () => store.dispatch(RefreshProductAction(productId)),
    onGoBack: () => store.dispatch(const GoBackFromProductDetailsAction()),
  );

  @override
  List<Object?> get props => [
    product,
    isRefreshing,
    refreshStatus,
    sources,
    isLoadingSources,
  ];
}
