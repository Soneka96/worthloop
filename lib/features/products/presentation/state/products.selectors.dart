// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Static product selectors over [AppState].
abstract final class ProductsSelectors {
  /// Returns every tracked product.
  static List<Product> productsSelector(AppState state) =>
      state.products.products;

  /// Returns the product identified by [productId], or `null`.
  static Product? productSelector(AppState state, String productId) {
    for (final Product product in state.products.products) {
      if (product.id == productId) {
        return product;
      }
    }
    return null;
  }

  /// Returns whether products are being loaded.
  static bool isLoadingSelector(AppState state) => state.products.isLoading;

  /// Returns whether every product is being refreshed.
  static bool isRefreshingAllSelector(AppState state) =>
      state.products.isRefreshingAll;

  /// Returns whether [productId] is being refreshed.
  static bool isRefreshingProductSelector(AppState state, String productId) =>
      state.products.refreshingProductIds.contains(productId);

  /// Returns the refresh state for [sourceId].
  static SourceRefreshStatus sourceRefreshStatusSelector(
    AppState state,
    String sourceId,
  ) =>
      state.products.sourceRefreshStatuses[sourceId] ??
      SourceRefreshStatus.idle;

  /// Returns the current refresh state for every source.
  static Map<String, SourceRefreshStatus> sourceRefreshStatusesSelector(
    AppState state,
  ) => state.products.sourceRefreshStatuses;

  /// Returns the number of sources that have reached a terminal state.
  static int refreshCompletedCountSelector(AppState state) =>
      state.products.refreshCompletedCount;

  /// Returns the number of sources in the active refresh.
  static int refreshTotalCountSelector(AppState state) =>
      state.products.refreshTotalCount;

  /// Returns the latest product-operation failure, or `null`.
  static String? errorSelector(AppState state) => state.products.error;

  /// Returns the classified refresh-all failure, or `null`.
  static PriceFetchStatus? refreshStatusSelector(AppState state) =>
      state.products.refreshStatus;

  /// Returns the classified refresh failure for [productId], or `null`.
  static PriceFetchStatus? refreshStatusForProductSelector(
    AppState state,
    String productId,
  ) => state.products.productRefreshStatuses[productId];

  /// Returns whether a product is being created.
  static bool isCreatingProductSelector(AppState state) =>
      state.products.isCreatingProduct;

  /// Returns the latest product-creation failure, or `null`.
  static String? productCreationErrorSelector(AppState state) =>
      state.products.creationError;

  /// Returns the identifier of the latest created product, or `null`.
  static String? createdProductIdSelector(AppState state) =>
      state.products.createdProductId;

  /// Returns whether a source is being added.
  static bool isAddingSourceSelector(AppState state) =>
      state.products.isAddingSource;

  /// Returns the latest source-add failure, or `null`.
  static String? addSourceErrorSelector(AppState state) =>
      state.products.addSourceError;

  /// Returns the identifier of the source currently being edited, or `null`.
  static String? editingSourceIdSelector(AppState state) =>
      state.products.editingSourceId;

  /// Returns the latest source-edit failure, or `null`.
  static String? editSourceErrorSelector(AppState state) =>
      state.products.editSourceError;

  /// Returns the source identifiers currently being deleted.
  static Set<String> deletingSourceIdsSelector(AppState state) =>
      state.products.deletingSourceIds;

  /// Returns the latest source-delete failure, or `null`.
  static String? deleteSourceErrorSelector(AppState state) =>
      state.products.deleteSourceError;

  /// Returns whether a product is being renamed.
  static bool isRenamingProductSelector(AppState state) =>
      state.products.isRenamingProduct;

  /// Returns the latest product-rename failure, or `null`.
  static String? renameProductErrorSelector(AppState state) =>
      state.products.renameProductError;

  /// Returns whether [productId] is being deleted.
  static bool isDeletingProductSelector(AppState state, String productId) =>
      state.products.deletingProductIds.contains(productId);

  /// Returns the latest product-delete failure, or `null`.
  static String? deleteProductErrorSelector(AppState state) =>
      state.products.deleteProductError;
}
