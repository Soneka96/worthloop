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
  TypedReducer<ProductsState, ProductsUpdatedFromDatabaseAction>(
    productsUpdatedFromDatabaseReducer,
  ).call,

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

  /// Handles [SourceRefreshStartedAction].
  /// Updates [ProductsState.sourceRefreshStatuses], [ProductsState.refreshTotalCount], [ProductsState.refreshCompletedCount].
  TypedReducer<ProductsState, SourceRefreshStartedAction>(
    sourceRefreshStartedReducer,
  ).call,

  /// Handles [SourceRefreshStatusChangedAction].
  /// Updates [ProductsState.sourceRefreshStatuses], [ProductsState.refreshCompletedCount].
  TypedReducer<ProductsState, SourceRefreshStatusChangedAction>(
    sourceRefreshStatusChangedReducer,
  ).call,

  /// Updates counts from the background refresh engine.
  TypedReducer<ProductsState, BackgroundRefreshProgressUpdatedAction>(
    backgroundRefreshProgressUpdatedReducer,
  ).call,

  /// Handles [SourceRefreshFinishedAction].
  /// Updates [ProductsState.refreshTotalCount], [ProductsState.refreshCompletedCount].
  TypedReducer<ProductsState, SourceRefreshFinishedAction>(
    sourceRefreshFinishedReducer,
  ).call,

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

  /// Handles [AddSourceAction].
  /// Updates [ProductsState.isAddingSource], [ProductsState.addSourceError].
  TypedReducer<ProductsState, AddSourceAction>(addSourceReducer).call,

  /// Handles [SourceAddedAction].
  /// Updates [ProductsState.products], [ProductsState.isAddingSource], [ProductsState.addSourceError].
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
  /// Updates [ProductsState.products], [ProductsState.editingSourceId], [ProductsState.editSourceError].
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
  /// Updates [ProductsState.products], [ProductsState.deletingSourceIds].
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
  sourceRefreshStatuses: {},
  refreshCompletedCount: 0,
  refreshTotalCount: 0,
);

/// Handles [ProductsLoadedAction].
/// Updates [ProductsState.products], [ProductsState.isLoading], [ProductsState.error].
ProductsState productsLoadedReducer(
  ProductsState state,
  ProductsLoadedAction action,
) {
  return state.copyWith(
    products: action.products,
    isLoading: false,
    isRefreshingAll: false,
    refreshingProductIds: {},
    error: const None(),
    refreshStatus: const None(),
    sourceRefreshStatuses: _sourceRefreshStatusesForProducts(action.products),
    productRefreshStatuses: {},
  );
}

/// Handles [ProductsUpdatedFromDatabaseAction].
/// Updates [ProductsState.products], [ProductsState.sourceRefreshStatuses],
/// [ProductsState.isRefreshingAll], [ProductsState.refreshingProductIds].
ProductsState productsUpdatedFromDatabaseReducer(
  ProductsState state,
  ProductsUpdatedFromDatabaseAction action,
) {
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses =
      _sourceRefreshStatusesForProducts(action.products);
  final bool anySourceActive = sourceRefreshStatuses.values.any(
    _isActiveSourceRefreshStatus,
  );
  return state.copyWith(
    products: action.products,
    sourceRefreshStatuses: sourceRefreshStatuses,
    isRefreshingAll: state.isRefreshingAll && anySourceActive,
    refreshingProductIds: anySourceActive
        ? state.refreshingProductIds
        : const {},
  );
}

/// Derives each source's [SourceRefreshStatus] from its persisted DB state:
/// [ProductSource.liveStatus] when a refresh is actively in flight, else a
/// terminal status derived from [ProductSource.lastRefreshStatus]. The DB
/// row is the sole source of truth — nothing here is carried over from the
/// previous Redux state.
Map<String, SourceRefreshStatus> _sourceRefreshStatusesForProducts(
  List<Product> products,
) {
  final Map<String, SourceRefreshStatus> statuses = {};
  for (final Product product in products) {
    for (final ProductSource source in product.sources) {
      final SourceRefreshStatus? status = _sourceRefreshStatusFor(source);
      if (status != null) {
        statuses[source.id] = status;
      }
    }
  }
  return statuses;
}

SourceRefreshStatus? _sourceRefreshStatusFor(ProductSource source) {
  final SourceRefreshStatus? liveStatus = source.liveStatus;
  if (liveStatus != null) {
    return liveStatus;
  }
  final PriceFetchStatus? refreshStatus = source.lastRefreshStatus;
  if (refreshStatus == null || refreshStatus == PriceFetchStatus.none) {
    return null;
  }
  return refreshStatus == PriceFetchStatus.success
      ? source.isAvailable == true
            ? SourceRefreshStatus.success
            : SourceRefreshStatus.unavailable
      : SourceRefreshStatus.error;
}

bool _isActiveSourceRefreshStatus(SourceRefreshStatus status) =>
    status == SourceRefreshStatus.queued ||
    status == SourceRefreshStatus.fetching;

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
  if (state.isRefreshingAll || state.refreshingProductIds.isNotEmpty) {
    return state;
  }
  final Map<String, PriceFetchStatus> productRefreshStatuses = {
    ...state.productRefreshStatuses,
  }..remove(action.productId);
  return state.copyWith(
    refreshingProductIds: {...state.refreshingProductIds, action.productId},
    error: const None(),
    productRefreshStatuses: productRefreshStatuses,
  );
}

/// Handles [SourceRefreshStartedAction].
/// Updates [ProductsState.sourceRefreshStatuses], [ProductsState.refreshTotalCount], [ProductsState.refreshCompletedCount].
ProductsState sourceRefreshStartedReducer(
  ProductsState state,
  SourceRefreshStartedAction action,
) {
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses = {
    if (!action.isGlobal) ...state.sourceRefreshStatuses,
    for (final String sourceId in action.sourceIds)
      sourceId: SourceRefreshStatus.queued,
  };
  return state.copyWith(
    sourceRefreshStatuses: sourceRefreshStatuses,
    refreshCompletedCount: 0,
    refreshTotalCount: action.sourceIds.length,
  );
}

/// Handles [SourceRefreshStatusChangedAction].
/// Updates [ProductsState.sourceRefreshStatuses], [ProductsState.refreshCompletedCount].
ProductsState sourceRefreshStatusChangedReducer(
  ProductsState state,
  SourceRefreshStatusChangedAction action,
) {
  final SourceRefreshStatus? previousStatus =
      state.sourceRefreshStatuses[action.sourceId];
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses = {
    ...state.sourceRefreshStatuses,
    action.sourceId: action.status,
  };
  final bool becameTerminal =
      _isTerminalSourceRefreshStatus(action.status) &&
      !_isTerminalSourceRefreshStatus(previousStatus);
  return state.copyWith(
    sourceRefreshStatuses: sourceRefreshStatuses,
    refreshCompletedCount: becameTerminal
        ? state.refreshCompletedCount + 1
        : state.refreshCompletedCount,
  );
}

/// Updates [ProductsState.refreshTotalCount] and [ProductsState.refreshCompletedCount]
/// from progress written by the background engine.
ProductsState backgroundRefreshProgressUpdatedReducer(
  ProductsState state,
  BackgroundRefreshProgressUpdatedAction action,
) => state.copyWith(
  refreshCompletedCount: action.progress.completedSources,
  refreshTotalCount: action.progress.totalSources,
);

/// Handles [SourceRefreshFinishedAction].
/// Updates [ProductsState.refreshTotalCount], [ProductsState.refreshCompletedCount].
///
/// Per-source terminal statuses intentionally remain available after cleanup so
/// the product details Issues filter can show the latest refresh failures.
ProductsState sourceRefreshFinishedReducer(
  ProductsState state,
  SourceRefreshFinishedAction action,
) => state.copyWith(refreshCompletedCount: 0, refreshTotalCount: 0);

bool _isTerminalSourceRefreshStatus(SourceRefreshStatus? status) =>
    status == SourceRefreshStatus.success ||
    status == SourceRefreshStatus.error ||
    status == SourceRefreshStatus.unavailable;

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
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses =
      _sourceRefreshStatusesForProducts(products);
  return state.copyWith(
    products: products,
    refreshingProductIds: refreshingProductIds,
    error: const None(),
    sourceRefreshStatuses: sourceRefreshStatuses,
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
) {
  if (state.isRefreshingAll || state.refreshingProductIds.isNotEmpty) {
    return state;
  }
  return state.copyWith(
    isRefreshingAll: true,
    error: const None(),
    refreshStatus: const None(),
  );
}

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

/// Handles [AddSourceAction].
/// Updates [ProductsState.isAddingSource], [ProductsState.addSourceError].
ProductsState addSourceReducer(ProductsState state, AddSourceAction action) =>
    state.copyWith(isAddingSource: true, addSourceError: const None());

/// Handles [SourceAddedAction].
/// Updates [ProductsState.products], [ProductsState.isAddingSource], [ProductsState.addSourceError].
ProductsState sourceAddedReducer(
  ProductsState state,
  SourceAddedAction action,
) {
  final List<Product> products = state.products
      .map(
        (Product product) =>
            product.id == action.product.id ? action.product : product,
      )
      .toList(growable: false);
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses =
      _sourceRefreshStatusesForProducts(products);
  return state.copyWith(
    products: products,
    sourceRefreshStatuses: sourceRefreshStatuses,
    isAddingSource: false,
    addSourceError: const None(),
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
/// Updates [ProductsState.products], [ProductsState.editingSourceId], [ProductsState.editSourceError].
ProductsState sourceEditedReducer(
  ProductsState state,
  SourceEditedAction action,
) {
  final List<Product> products = state.products
      .map(
        (Product product) =>
            product.id == action.product.id ? action.product : product,
      )
      .toList(growable: false);
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses =
      _sourceRefreshStatusesForProducts(products);
  return state.copyWith(
    products: products,
    sourceRefreshStatuses: sourceRefreshStatuses,
    editingSourceId: const None(),
    editSourceError: const None(),
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
/// Updates [ProductsState.products], [ProductsState.deletingSourceIds].
ProductsState sourceDeletedReducer(
  ProductsState state,
  SourceDeletedAction action,
) {
  final List<Product> products = state.products
      .map(
        (Product product) =>
            product.id == action.product.id ? action.product : product,
      )
      .toList(growable: false);
  final Set<String> deletingSourceIds = {...state.deletingSourceIds}
    ..remove(action.sourceId);
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses =
      _sourceRefreshStatusesForProducts(products);
  return state.copyWith(
    products: products,
    deletingSourceIds: deletingSourceIds,
    sourceRefreshStatuses: sourceRefreshStatuses,
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
