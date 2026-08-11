/// Cross-cutting constants for merchant price-fetch requests.
abstract final class PriceFetchConstants {
  /// Time allowed to establish the connection before failing.
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Time allowed to receive the response body before failing.
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Time allowed to send the request before failing.
  static const Duration sendTimeout = Duration(seconds: 15);

  /// A blocked source is skipped for this long before it's retried.
  static const Duration blockedRetryAfter = Duration(hours: 1);

  /// Delay allowed for JavaScript-rendered page content.
  static const Duration webViewJsRenderDelay = Duration(seconds: 2);

  /// Poll interval while waiting for rendered WebView HTML.
  static const Duration webViewPollInterval = Duration(milliseconds: 200);

  /// Maximum time allowed for a headless WebView fetch.
  static const Duration webViewTotalTimeout = Duration(seconds: 30);

  /// Maximum time allowed to decode a price offer out of fetched HTML.
  static const Duration offerDecodeTimeout = Duration(seconds: 10);

  /// Maximum time allowed to dispose a headless WebView, so a wedged native
  /// teardown can't hang the fetch that already timed out on it.
  static const Duration webViewDisposeTimeout = Duration(seconds: 5);

  /// Bounds one source's whole fetch (Dio, WebView fallback, and decoding
  /// combined) inside [ProductSourceRefreshEngine] — comfortably above every
  /// timeout above added together, so it only fires when something hangs
  /// outside all of them.
  static const Duration sourceFetchTimeout = Duration(seconds: 120);
}
