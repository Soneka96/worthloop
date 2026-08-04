// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/screens/product_details.screen.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// ViewModel representing the data required by [ProductDetailsScreen].
class ProductDetailsViewModel extends Equatable {
  /// Product currently displayed, or `null` when it is missing.
  final Product? product;

  /// Whether this product is being refreshed.
  final bool isRefreshing;

  /// Dispatches [RefreshProductAction].
  final void Function() onRefresh;

  /// Dispatches [GoBackFromProductDetailsAction].
  final void Function() onGoBack;

  const ProductDetailsViewModel({
    required this.product,
    required this.isRefreshing,
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
    onRefresh: () => store.dispatch(RefreshProductAction(productId)),
    onGoBack: () => store.dispatch(const GoBackFromProductDetailsAction()),
  );

  @override
  List<Object?> get props => [product, isRefreshing];
}
