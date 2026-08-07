// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
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

  /// Whether this product's sources are being refreshed.
  final bool isProductRefreshing;

  /// Whether sources belonging to other products are being refreshed.
  final bool areOtherSourcesRefreshing;

  /// Why pulling to refresh cannot start another refresh, if applicable.
  final ProductRefreshBlockReason refreshBlockReason;

  /// Number of this product's sources in a terminal refresh state.
  final int productRefreshCompletedCount;

  /// Number of sources belonging to this product.
  final int productRefreshTotalCount;

  /// Classified reason for the latest refresh failure, or `null`.
  final PriceFetchStatus? refreshStatus;

  /// Current refresh state for each source.
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses;

  /// Number of sources that have finished refreshing.
  final int refreshCompletedCount;

  /// Number of sources in the current refresh.
  final int refreshTotalCount;

  /// Whether a source is being added.
  final bool isAddingSource;

  /// The most recent source-add failure, or `null`.
  final String? addSourceError;

  /// Identifier of the source currently being edited, or `null`.
  final String? editingSourceId;

  /// The most recent source-edit failure, or `null`.
  final String? editSourceError;

  /// Source identifiers currently being deleted.
  final Set<String> deletingSourceIds;

  /// The most recent source-delete failure, or `null`.
  final String? deleteSourceError;

  /// Whether this product is being renamed.
  final bool isRenamingProduct;

  /// The most recent product-rename failure, or `null`.
  final String? renameProductError;

  /// Whether this product is being deleted.
  final bool isDeletingProduct;

  /// The most recent product-delete failure, or `null`.
  final String? deleteProductError;

  /// Dispatches [RefreshProductAction].
  final void Function() onRefresh;

  /// Dispatches [RefreshSourceAction] for one source.
  final void Function(String sourceId) onRefreshSource;

  /// Dispatches [GoBackFromProductDetailsAction].
  final void Function() onGoBack;

  /// Dispatches [AddSourceAction] for this product.
  final void Function(String url) onAddSource;

  /// Dispatches [EditSourceAction].
  final void Function(String sourceId, String url) onEditSource;

  /// Dispatches [DeleteSourceAction] for this product.
  final void Function(String sourceId) onDeleteSource;

  /// Dispatches [OpenOfferUrlAction] for a merchant offer's product page.
  final void Function(String url) onOpenOffer;

  /// Dispatches [RenameProductAction] for this product.
  final void Function(String name) onRenameProduct;

  /// Dispatches [DeleteProductAction] for this product.
  final void Function() onDeleteProduct;

  const ProductDetailsViewModel({
    required this.product,
    required this.isRefreshing,
    required this.isProductRefreshing,
    required this.areOtherSourcesRefreshing,
    required this.refreshBlockReason,
    required this.productRefreshCompletedCount,
    required this.productRefreshTotalCount,
    this.refreshStatus,
    this.sourceRefreshStatuses = const {},
    this.refreshCompletedCount = 0,
    this.refreshTotalCount = 0,
    required this.isAddingSource,
    required this.addSourceError,
    required this.editingSourceId,
    required this.editSourceError,
    required this.deletingSourceIds,
    required this.deleteSourceError,
    required this.isRenamingProduct,
    required this.renameProductError,
    required this.isDeletingProduct,
    required this.deleteProductError,
    required this.onRefresh,
    required this.onRefreshSource,
    required this.onGoBack,
    required this.onAddSource,
    required this.onEditSource,
    required this.onDeleteSource,
    required this.onOpenOffer,
    required this.onRenameProduct,
    required this.onDeleteProduct,
  });

  /// Creates the details state for [productId].
  factory ProductDetailsViewModel.fromStore(
    Store<AppState> store,
    String productId,
  ) => ProductDetailsViewModel(
    product: ProductsSelectors.productSelector(store.state, productId),
    isRefreshing: ProductsSelectors.isRefreshingSelector(store.state),
    isProductRefreshing: ProductsSelectors.isProductSourceRefreshingSelector(
      store.state,
      productId,
    ),
    areOtherSourcesRefreshing:
        ProductsSelectors.areOtherSourcesRefreshingSelector(
          store.state,
          productId,
        ),
    refreshBlockReason: ProductsSelectors.productRefreshBlockReasonSelector(
      store.state,
      productId,
    ),
    productRefreshCompletedCount:
        ProductsSelectors.productRefreshCompletedCountSelector(
          store.state,
          productId,
        ),
    productRefreshTotalCount:
        ProductsSelectors.productSelector(
          store.state,
          productId,
        )?.sources.length ??
        0,
    refreshStatus: ProductsSelectors.refreshStatusForProductSelector(
      store.state,
      productId,
    ),
    sourceRefreshStatuses: store.state.products.sourceRefreshStatuses,
    refreshCompletedCount: ProductsSelectors.refreshCompletedCountSelector(
      store.state,
    ),
    refreshTotalCount: ProductsSelectors.refreshTotalCountSelector(store.state),
    isAddingSource: ProductsSelectors.isAddingSourceSelector(store.state),
    addSourceError: ProductsSelectors.addSourceErrorSelector(store.state),
    editingSourceId: ProductsSelectors.editingSourceIdSelector(store.state),
    editSourceError: ProductsSelectors.editSourceErrorSelector(store.state),
    deletingSourceIds: ProductsSelectors.deletingSourceIdsSelector(store.state),
    deleteSourceError: ProductsSelectors.deleteSourceErrorSelector(store.state),
    isRenamingProduct: ProductsSelectors.isRenamingProductSelector(store.state),
    renameProductError: ProductsSelectors.renameProductErrorSelector(
      store.state,
    ),
    isDeletingProduct: ProductsSelectors.isDeletingProductSelector(
      store.state,
      productId,
    ),
    deleteProductError: ProductsSelectors.deleteProductErrorSelector(
      store.state,
    ),
    onRefresh: () => store.dispatch(RefreshProductAction(productId)),
    onRefreshSource: (String sourceId) =>
        store.dispatch(RefreshSourceAction(sourceId)),
    onGoBack: () => store.dispatch(const GoBackFromProductDetailsAction()),
    onAddSource: (String url) =>
        store.dispatch(AddSourceAction(productId: productId, url: url)),
    onEditSource: (String sourceId, String url) =>
        store.dispatch(EditSourceAction(sourceId: sourceId, url: url)),
    onDeleteSource: (String sourceId) => store.dispatch(
      DeleteSourceAction(productId: productId, sourceId: sourceId),
    ),
    onOpenOffer: (String url) => store.dispatch(OpenOfferUrlAction(url)),
    onRenameProduct: (String name) =>
        store.dispatch(RenameProductAction(productId: productId, name: name)),
    onDeleteProduct: () => store.dispatch(DeleteProductAction(productId)),
  );

  @override
  List<Object?> get props => [
    product,
    isRefreshing,
    isProductRefreshing,
    areOtherSourcesRefreshing,
    refreshBlockReason,
    productRefreshCompletedCount,
    productRefreshTotalCount,
    refreshStatus,
    sourceRefreshStatuses,
    refreshCompletedCount,
    refreshTotalCount,
    isAddingSource,
    addSourceError,
    editingSourceId,
    editSourceError,
    deletingSourceIds,
    deleteSourceError,
    isRenamingProduct,
    renameProductError,
    isDeletingProduct,
    deleteProductError,
  ];
}
