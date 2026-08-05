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
}
