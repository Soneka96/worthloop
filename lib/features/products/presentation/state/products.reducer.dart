// Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Reduces actions into [ProductsState].
Reducer<ProductsState> productsReducer = combineReducers<ProductsState>([
  /// Handles [LoadProductsAction].
  /// Updates [ProductsState.isLoading], [ProductsState.error].
  TypedReducer<ProductsState, LoadProductsAction>(loadProductsReducer).call,

  /// Handles [ProductsLoadedAction].
  /// Updates [ProductsState.products], [ProductsState.isLoading], [ProductsState.error].
  TypedReducer<ProductsState, ProductsLoadedAction>(productsLoadedReducer).call,

  /// Handles [ProductsLoadFailedAction].
  /// Updates [ProductsState.isLoading], [ProductsState.error].
  TypedReducer<ProductsState, ProductsLoadFailedAction>(
    productsLoadFailedReducer,
  ).call,

  /// Handles [CreateProductAction].
  /// Updates [ProductsState.isCreatingProduct], [ProductsState.creationError].
  TypedReducer<ProductsState, CreateProductAction>(createProductReducer).call,

  /// Handles [ProductCreatedAction].
  /// Updates [ProductsState.products], [ProductsState.isCreatingProduct], [ProductsState.createdProductId].
  TypedReducer<ProductsState, ProductCreatedAction>(productCreatedReducer).call,

  /// Handles [ProductCreationFailedAction].
  /// Updates [ProductsState.isCreatingProduct], [ProductsState.creationError].
  TypedReducer<ProductsState, ProductCreationFailedAction>(
    productCreationFailedReducer,
  ).call,

  /// Handles [RefreshProductAction].
  /// Updates [ProductsState.refreshingProductIds], [ProductsState.error].
  TypedReducer<ProductsState, RefreshProductAction>(refreshProductReducer).call,

  /// Handles [ProductRefreshedAction].
  /// Updates [ProductsState.products], [ProductsState.refreshingProductIds], [ProductsState.error].
  TypedReducer<ProductsState, ProductRefreshedAction>(
    productRefreshedReducer,
  ).call,

  /// Handles [ProductRefreshFailedAction].
  /// Updates [ProductsState.refreshingProductIds], [ProductsState.error].
  TypedReducer<ProductsState, ProductRefreshFailedAction>(
    productRefreshFailedReducer,
  ).call,

  /// Handles [RefreshAllProductsAction].
  /// Updates [ProductsState.isRefreshingAll], [ProductsState.error].
  TypedReducer<ProductsState, RefreshAllProductsAction>(
    refreshAllProductsReducer,
  ).call,

  /// Handles [RefreshAllProductsFailedAction].
  /// Updates [ProductsState.isRefreshingAll], [ProductsState.error].
  TypedReducer<ProductsState, RefreshAllProductsFailedAction>(
    refreshAllProductsFailedReducer,
  ).call,
]);

/// Handles [LoadProductsAction].
/// Updates [ProductsState.isLoading], [ProductsState.error].
ProductsState loadProductsReducer(
  ProductsState state,
  LoadProductsAction action,
) => state.copyWith(
  isLoading: true,
  error: const None(),
  refreshStatus: const None(),
);

/// Handles [ProductsLoadedAction].
/// Updates [ProductsState.products], [ProductsState.isLoading], [ProductsState.error].
ProductsState productsLoadedReducer(
  ProductsState state,
  ProductsLoadedAction action,
) => state.copyWith(
  products: action.products,
  isLoading: false,
  isRefreshingAll: false,
  refreshingProductIds: {},
  error: const None(),
  refreshStatus: const None(),
);

/// Handles [ProductsLoadFailedAction].
/// Updates [ProductsState.isLoading], [ProductsState.error].
ProductsState productsLoadFailedReducer(
  ProductsState state,
  ProductsLoadFailedAction action,
) => state.copyWith(isLoading: false, error: Some(action.message));

/// Handles [CreateProductAction].
/// Updates [ProductsState.isCreatingProduct], [ProductsState.creationError].
ProductsState createProductReducer(
  ProductsState state,
  CreateProductAction action,
) => state.copyWith(
  isCreatingProduct: true,
  creationError: const None(),
  createdProductId: const None(),
);

/// Handles [ProductCreatedAction].
/// Updates [ProductsState.products], [ProductsState.isCreatingProduct], [ProductsState.createdProductId].
ProductsState productCreatedReducer(
  ProductsState state,
  ProductCreatedAction action,
) => state.copyWith(
  products: [...state.products, action.product],
  isCreatingProduct: false,
  creationError: const None(),
  createdProductId: Some(action.product.id),
);

/// Handles [ProductCreationFailedAction].
/// Updates [ProductsState.isCreatingProduct], [ProductsState.creationError].
ProductsState productCreationFailedReducer(
  ProductsState state,
  ProductCreationFailedAction action,
) => state.copyWith(
  isCreatingProduct: false,
  creationError: Some(action.message),
);

/// Handles [RefreshProductAction].
/// Updates [ProductsState.refreshingProductIds], [ProductsState.error].
ProductsState refreshProductReducer(
  ProductsState state,
  RefreshProductAction action,
) => state.copyWith(
  refreshingProductIds: {...state.refreshingProductIds, action.productId},
  error: const None(),
  refreshStatus: const None(),
);

/// Handles [ProductRefreshedAction].
/// Updates [ProductsState.products], [ProductsState.refreshingProductIds], [ProductsState.error].
ProductsState productRefreshedReducer(
  ProductsState state,
  ProductRefreshedAction action,
) {
  final List<Product> products = state.products
      .map(
        (Product product) =>
            product.id == action.product.id ? action.product : product,
      )
      .toList(growable: false);
  final Set<String> refreshingProductIds = {...state.refreshingProductIds}
    ..remove(action.product.id);
  return state.copyWith(
    products: products,
    refreshingProductIds: refreshingProductIds,
    error: const None(),
    refreshStatus: const None(),
  );
}

/// Handles [ProductRefreshFailedAction].
/// Updates [ProductsState.refreshingProductIds], [ProductsState.error].
ProductsState productRefreshFailedReducer(
  ProductsState state,
  ProductRefreshFailedAction action,
) {
  final Set<String> refreshingProductIds = {...state.refreshingProductIds}
    ..remove(action.productId);
  return state.copyWith(
    refreshingProductIds: refreshingProductIds,
    error: Some(action.message),
    refreshStatus: action.status == null
        ? const None()
        : Some(action.status ?? PriceFetchStatus.none),
  );
}

/// Handles [RefreshAllProductsAction].
/// Updates [ProductsState.isRefreshingAll], [ProductsState.error].
ProductsState refreshAllProductsReducer(
  ProductsState state,
  RefreshAllProductsAction action,
) => state.copyWith(
  isRefreshingAll: true,
  error: const None(),
  refreshStatus: const None(),
);

/// Handles [RefreshAllProductsFailedAction].
/// Updates [ProductsState.isRefreshingAll], [ProductsState.error].
ProductsState refreshAllProductsFailedReducer(
  ProductsState state,
  RefreshAllProductsFailedAction action,
) => state.copyWith(
  isRefreshingAll: false,
  error: Some(action.message),
  refreshStatus: action.status == null
      ? const None()
      : Some(action.status ?? PriceFetchStatus.none),
);
