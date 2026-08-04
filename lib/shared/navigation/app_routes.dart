/// Central registry of all route paths.
///
/// Use these constants everywhere — never write route strings inline.
abstract final class AppRoutes {
  /// The app's initial screen.
  static const String home = '/';

  /// App-wide settings — appearance, etc.
  static const String appSettings = '/settings';

  /// A tracked product's current merchant offers.
  static const String productDetails = '/products/:productId';

  /// Builds the route path for the product identified by [productId].
  static String productDetailsPath(String productId) => '/products/$productId';
}
