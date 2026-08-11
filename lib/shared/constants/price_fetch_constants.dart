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
}
