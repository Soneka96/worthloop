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

  /// Saved website sources for this product.
  final List<ProductSource> sources;

  /// Whether this product's sources are being loaded.
  final bool isLoadingSources;

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

  /// Dispatches [GoBackFromProductDetailsAction].
  final void Function() onGoBack;

  /// Dispatches [AddSourceAction] for this product.
  final void Function(String url) onAddSource;

  /// Dispatches [EditSourceAction].
  final void Function(String sourceId, String url) onEditSource;

  /// Dispatches [DeleteSourceAction] for this product.
  final void Function(String sourceId) onDeleteSource;

  /// Dispatches [RenameProductAction] for this product.
  final void Function(String name) onRenameProduct;

  /// Dispatches [DeleteProductAction] for this product.
  final void Function() onDeleteProduct;

  const ProductDetailsViewModel({
    required this.product,
    required this.isRefreshing,
    this.refreshStatus,
    required this.sources,
    required this.isLoadingSources,
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
    required this.onGoBack,
    required this.onAddSource,
    required this.onEditSource,
    required this.onDeleteSource,
    required this.onRenameProduct,
    required this.onDeleteProduct,
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
    onGoBack: () => store.dispatch(const GoBackFromProductDetailsAction()),
    onAddSource: (String url) =>
        store.dispatch(AddSourceAction(productId: productId, url: url)),
    onEditSource: (String sourceId, String url) =>
        store.dispatch(EditSourceAction(sourceId: sourceId, url: url)),
    onDeleteSource: (String sourceId) => store.dispatch(
      DeleteSourceAction(productId: productId, sourceId: sourceId),
    ),
    onRenameProduct: (String name) =>
        store.dispatch(RenameProductAction(productId: productId, name: name)),
    onDeleteProduct: () => store.dispatch(DeleteProductAction(productId)),
  );

  @override
  List<Object?> get props => [
    product,
    isRefreshing,
    refreshStatus,
    sources,
    isLoadingSources,
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
