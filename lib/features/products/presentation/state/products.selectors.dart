// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
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
}
