// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
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

  /// Returns the saved sources for [productId].
  static List<ProductSource> sourcesForProductSelector(
    AppState state,
    String productId,
  ) => state.products.sourcesByProduct[productId] ?? const [];

  /// Returns whether sources for [productId] are being loaded.
  static bool isLoadingSourcesSelector(AppState state, String productId) =>
      state.products.loadingSourcesProductIds.contains(productId);
}
