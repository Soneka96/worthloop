// Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
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

  /// Handles [LoadProductSourcesAction].
  /// Updates [ProductsState.loadingSourcesProductIds].
  TypedReducer<ProductsState, LoadProductSourcesAction>(
    loadProductSourcesReducer,
  ).call,

  /// Handles [ProductSourcesLoadedAction].
  /// Updates [ProductsState.sourcesByProduct], [ProductsState.loadingSourcesProductIds].
  TypedReducer<ProductsState, ProductSourcesLoadedAction>(
    productSourcesLoadedReducer,
  ).call,

  /// Handles [ProductSourcesLoadFailedAction].
  /// Updates [ProductsState.loadingSourcesProductIds], [ProductsState.error].
  TypedReducer<ProductsState, ProductSourcesLoadFailedAction>(
    productSourcesLoadFailedReducer,
  ).call,

  /// Handles [AddSourceAction].
  /// Updates [ProductsState.isAddingSource], [ProductsState.addSourceError].
  TypedReducer<ProductsState, AddSourceAction>(addSourceReducer).call,

  /// Handles [SourceAddedAction].
  /// Updates [ProductsState.sourcesByProduct], [ProductsState.isAddingSource], [ProductsState.addSourceError].
  TypedReducer<ProductsState, SourceAddedAction>(sourceAddedReducer).call,

  /// Handles [SourceAddFailedAction].
  /// Updates [ProductsState.isAddingSource], [ProductsState.addSourceError].
  TypedReducer<ProductsState, SourceAddFailedAction>(
    sourceAddFailedReducer,
  ).call,

  /// Handles [EditSourceAction].
  /// Updates [ProductsState.editingSourceId], [ProductsState.editSourceError].
  TypedReducer<ProductsState, EditSourceAction>(editSourceReducer).call,

  /// Handles [SourceEditedAction].
  /// Updates [ProductsState.sourcesByProduct], [ProductsState.editingSourceId], [ProductsState.editSourceError].
  TypedReducer<ProductsState, SourceEditedAction>(sourceEditedReducer).call,

  /// Handles [SourceEditFailedAction].
  /// Updates [ProductsState.editingSourceId], [ProductsState.editSourceError].
  TypedReducer<ProductsState, SourceEditFailedAction>(
    sourceEditFailedReducer,
  ).call,

  /// Handles [DeleteSourceAction].
  /// Updates [ProductsState.deletingSourceIds], [ProductsState.deleteSourceError].
  TypedReducer<ProductsState, DeleteSourceAction>(deleteSourceReducer).call,

  /// Handles [SourceDeletedAction].
  /// Updates [ProductsState.sourcesByProduct], [ProductsState.deletingSourceIds].
  TypedReducer<ProductsState, SourceDeletedAction>(sourceDeletedReducer).call,

  /// Handles [SourceDeleteFailedAction].
  /// Updates [ProductsState.deletingSourceIds], [ProductsState.deleteSourceError].
  TypedReducer<ProductsState, SourceDeleteFailedAction>(
    sourceDeleteFailedReducer,
  ).call,

  /// Handles [RenameProductAction].
  /// Updates [ProductsState.isRenamingProduct], [ProductsState.renameProductError].
  TypedReducer<ProductsState, RenameProductAction>(renameProductReducer).call,

  /// Handles [ProductRenamedAction].
  /// Updates [ProductsState.products], [ProductsState.isRenamingProduct], [ProductsState.renameProductError].
  TypedReducer<ProductsState, ProductRenamedAction>(productRenamedReducer).call,

  /// Handles [ProductRenameFailedAction].
  /// Updates [ProductsState.isRenamingProduct], [ProductsState.renameProductError].
  TypedReducer<ProductsState, ProductRenameFailedAction>(
    productRenameFailedReducer,
  ).call,

  /// Handles [DeleteProductAction].
  /// Updates [ProductsState.deletingProductIds], [ProductsState.deleteProductError].
  TypedReducer<ProductsState, DeleteProductAction>(deleteProductReducer).call,

  /// Handles [ProductDeletedAction].
  /// Updates [ProductsState.products], [ProductsState.deletingProductIds].
  TypedReducer<ProductsState, ProductDeletedAction>(productDeletedReducer).call,

  /// Handles [ProductDeleteFailedAction].
  /// Updates [ProductsState.deletingProductIds], [ProductsState.deleteProductError].
  TypedReducer<ProductsState, ProductDeleteFailedAction>(
    productDeleteFailedReducer,
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
  productRefreshStatuses: {},
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
) {
  final Map<String, PriceFetchStatus> productRefreshStatuses = {
    ...state.productRefreshStatuses,
  }..remove(action.productId);
  return state.copyWith(
    refreshingProductIds: {...state.refreshingProductIds, action.productId},
    error: const None(),
    productRefreshStatuses: productRefreshStatuses,
  );
}

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
  final Map<String, PriceFetchStatus> productRefreshStatuses = {
    ...state.productRefreshStatuses,
  }..remove(action.product.id);
  return state.copyWith(
    products: products,
    refreshingProductIds: refreshingProductIds,
    error: const None(),
    productRefreshStatuses: productRefreshStatuses,
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
  final Map<String, PriceFetchStatus> productRefreshStatuses = {
    ...state.productRefreshStatuses,
  };
  if (action.status == null) {
    productRefreshStatuses.remove(action.productId);
  } else {
    productRefreshStatuses[action.productId] =
        action.status ?? PriceFetchStatus.none;
  }
  return state.copyWith(
    refreshingProductIds: refreshingProductIds,
    error: Some(action.message),
    productRefreshStatuses: productRefreshStatuses,
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

/// Handles [LoadProductSourcesAction].
/// Updates [ProductsState.loadingSourcesProductIds].
ProductsState loadProductSourcesReducer(
  ProductsState state,
  LoadProductSourcesAction action,
) => state.copyWith(
  loadingSourcesProductIds: {
    ...state.loadingSourcesProductIds,
    action.productId,
  },
);

/// Handles [ProductSourcesLoadedAction].
/// Updates [ProductsState.sourcesByProduct], [ProductsState.loadingSourcesProductIds].
ProductsState productSourcesLoadedReducer(
  ProductsState state,
  ProductSourcesLoadedAction action,
) {
  final Map<String, List<ProductSource>> sourcesByProduct = {
    ...state.sourcesByProduct,
  }..[action.productId] = action.sources;
  final Set<String> loadingSourcesProductIds = {
    ...state.loadingSourcesProductIds,
  }..remove(action.productId);
  return state.copyWith(
    sourcesByProduct: sourcesByProduct,
    loadingSourcesProductIds: loadingSourcesProductIds,
  );
}

/// Handles [ProductSourcesLoadFailedAction].
/// Updates [ProductsState.loadingSourcesProductIds], [ProductsState.error].
ProductsState productSourcesLoadFailedReducer(
  ProductsState state,
  ProductSourcesLoadFailedAction action,
) {
  final Set<String> loadingSourcesProductIds = {
    ...state.loadingSourcesProductIds,
  }..remove(action.productId);
  return state.copyWith(
    loadingSourcesProductIds: loadingSourcesProductIds,
    error: Some(action.message),
  );
}

/// Handles [AddSourceAction].
/// Updates [ProductsState.isAddingSource], [ProductsState.addSourceError].
ProductsState addSourceReducer(ProductsState state, AddSourceAction action) =>
    state.copyWith(isAddingSource: true, addSourceError: const None());

/// Handles [SourceAddedAction].
/// Updates [ProductsState.sourcesByProduct], [ProductsState.isAddingSource], [ProductsState.addSourceError].
ProductsState sourceAddedReducer(
  ProductsState state,
  SourceAddedAction action,
) {
  final List<ProductSource> existing =
      state.sourcesByProduct[action.source.productId] ?? const [];
  final Map<String, List<ProductSource>> sourcesByProduct = {
    ...state.sourcesByProduct,
  }..[action.source.productId] = [...existing, action.source];
  return state.copyWith(
    isAddingSource: false,
    addSourceError: const None(),
    sourcesByProduct: sourcesByProduct,
  );
}

/// Handles [SourceAddFailedAction].
/// Updates [ProductsState.isAddingSource], [ProductsState.addSourceError].
ProductsState sourceAddFailedReducer(
  ProductsState state,
  SourceAddFailedAction action,
) =>
    state.copyWith(isAddingSource: false, addSourceError: Some(action.message));

/// Handles [EditSourceAction].
/// Updates [ProductsState.editingSourceId], [ProductsState.editSourceError].
ProductsState editSourceReducer(ProductsState state, EditSourceAction action) =>
    state.copyWith(
      editingSourceId: Some(action.sourceId),
      editSourceError: const None(),
    );

/// Handles [SourceEditedAction].
/// Updates [ProductsState.sourcesByProduct], [ProductsState.editingSourceId], [ProductsState.editSourceError].
ProductsState sourceEditedReducer(
  ProductsState state,
  SourceEditedAction action,
) {
  final List<ProductSource> existing =
      state.sourcesByProduct[action.source.productId] ?? const [];
  final List<ProductSource> updated = existing
      .map(
        (ProductSource source) =>
            source.id == action.source.id ? action.source : source,
      )
      .toList(growable: false);
  final Map<String, List<ProductSource>> sourcesByProduct = {
    ...state.sourcesByProduct,
  }..[action.source.productId] = updated;
  return state.copyWith(
    editingSourceId: const None(),
    editSourceError: const None(),
    sourcesByProduct: sourcesByProduct,
  );
}

/// Handles [SourceEditFailedAction].
/// Updates [ProductsState.editingSourceId], [ProductsState.editSourceError].
ProductsState sourceEditFailedReducer(
  ProductsState state,
  SourceEditFailedAction action,
) => state.copyWith(
  editingSourceId: const None(),
  editSourceError: Some(action.message),
);

/// Handles [DeleteSourceAction].
/// Updates [ProductsState.deletingSourceIds], [ProductsState.deleteSourceError].
ProductsState deleteSourceReducer(
  ProductsState state,
  DeleteSourceAction action,
) => state.copyWith(
  deletingSourceIds: {...state.deletingSourceIds, action.sourceId},
  deleteSourceError: const None(),
);

/// Handles [SourceDeletedAction].
/// Updates [ProductsState.sourcesByProduct], [ProductsState.deletingSourceIds].
ProductsState sourceDeletedReducer(
  ProductsState state,
  SourceDeletedAction action,
) {
  final List<ProductSource> existing =
      state.sourcesByProduct[action.productId] ?? const [];
  final List<ProductSource> remaining = existing
      .where((ProductSource source) => source.id != action.sourceId)
      .toList(growable: false);
  final Map<String, List<ProductSource>> sourcesByProduct = {
    ...state.sourcesByProduct,
  }..[action.productId] = remaining;
  final Set<String> deletingSourceIds = {...state.deletingSourceIds}
    ..remove(action.sourceId);
  return state.copyWith(
    sourcesByProduct: sourcesByProduct,
    deletingSourceIds: deletingSourceIds,
  );
}

/// Handles [SourceDeleteFailedAction].
/// Updates [ProductsState.deletingSourceIds], [ProductsState.deleteSourceError].
ProductsState sourceDeleteFailedReducer(
  ProductsState state,
  SourceDeleteFailedAction action,
) {
  final Set<String> deletingSourceIds = {...state.deletingSourceIds}
    ..remove(action.sourceId);
  return state.copyWith(
    deletingSourceIds: deletingSourceIds,
    deleteSourceError: Some(action.message),
  );
}

/// Handles [RenameProductAction].
/// Updates [ProductsState.isRenamingProduct], [ProductsState.renameProductError].
ProductsState renameProductReducer(
  ProductsState state,
  RenameProductAction action,
) => state.copyWith(isRenamingProduct: true, renameProductError: const None());

/// Handles [ProductRenamedAction].
/// Updates [ProductsState.products], [ProductsState.isRenamingProduct], [ProductsState.renameProductError].
ProductsState productRenamedReducer(
  ProductsState state,
  ProductRenamedAction action,
) {
  final List<Product> products = state.products
      .map(
        (Product product) =>
            product.id == action.product.id ? action.product : product,
      )
      .toList(growable: false);
  return state.copyWith(
    products: products,
    isRenamingProduct: false,
    renameProductError: const None(),
  );
}

/// Handles [ProductRenameFailedAction].
/// Updates [ProductsState.isRenamingProduct], [ProductsState.renameProductError].
ProductsState productRenameFailedReducer(
  ProductsState state,
  ProductRenameFailedAction action,
) => state.copyWith(
  isRenamingProduct: false,
  renameProductError: Some(action.message),
);

/// Handles [DeleteProductAction].
/// Updates [ProductsState.deletingProductIds], [ProductsState.deleteProductError].
ProductsState deleteProductReducer(
  ProductsState state,
  DeleteProductAction action,
) => state.copyWith(
  deletingProductIds: {...state.deletingProductIds, action.productId},
  deleteProductError: const None(),
);

/// Handles [ProductDeletedAction].
/// Updates [ProductsState.products], [ProductsState.deletingProductIds].
ProductsState productDeletedReducer(
  ProductsState state,
  ProductDeletedAction action,
) {
  final List<Product> products = state.products
      .where((Product product) => product.id != action.productId)
      .toList(growable: false);
  final Set<String> deletingProductIds = {...state.deletingProductIds}
    ..remove(action.productId);
  return state.copyWith(
    products: products,
    deletingProductIds: deletingProductIds,
  );
}

/// Handles [ProductDeleteFailedAction].
/// Updates [ProductsState.deletingProductIds], [ProductsState.deleteProductError].
ProductsState productDeleteFailedReducer(
  ProductsState state,
  ProductDeleteFailedAction action,
) {
  final Set<String> deletingProductIds = {...state.deletingProductIds}
    ..remove(action.productId);
  return state.copyWith(
    deletingProductIds: deletingProductIds,
    deleteProductError: Some(action.message),
  );
}
