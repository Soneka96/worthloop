// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// Classifies a merchant response before its price data is persisted.
class PriceResponseDetector {
  /// Classifies [statusCode] and [responseBody] using [hasUsablePrice].
  PriceFetchStatus detect({
    required int? statusCode,
    required String responseBody,
    required bool hasUsablePrice,
  }) {
    if (hasUsablePrice) {
      return PriceFetchStatus.success;
    }
    if (statusCode == null || statusCode >= 500) {
      return PriceFetchStatus.networkError;
    }
    if (_containsPriceData(responseBody)) {
      return PriceFetchStatus.invalidData;
    }
    if (_isBlocked(statusCode, responseBody)) {
      return PriceFetchStatus.blocked;
    }
    return PriceFetchStatus.unsupported;
  }

  bool _isBlocked(int? statusCode, String responseBody) {
    if (statusCode != null && _blockedStatusCodes.contains(statusCode)) {
      return true;
    }
    return _blockedBodyMarker.hasMatch(responseBody);
  }

  bool _containsPriceData(String responseBody) =>
      _priceMarker.hasMatch(responseBody);

  static const Set<int> _blockedStatusCodes = {403, 429};
  // ponytail: matches "captcha"/"challenge" as a bare substring in any
  // id/class attribute, so an unrelated widget (e.g. Google reCAPTCHA's
  // own id="grecaptcha-badge") can still misclassify a genuinely
  // unsupported page as blocked. Lower stakes than the priority bug this
  // reordering fixes — hasUsablePrice already wins when there's a real
  // price. Tighten the regex if a real site needs it.
  static final RegExp _blockedBodyMarker = RegExp(
    r'''<(?:title|h1)[^>]*>[^<]*(?:cloudflare challenge|checking your browser|access denied|automated requests)[^<]*</(?:title|h1)>|(?:id|class)=["'][^"']*(?:captcha|cf-chl|challenge)[^"']*["']''',
    caseSensitive: false,
  );
  static final RegExp _priceMarker = RegExp(
    r'''"price"\s*:|itemprop=["']price["']|property=["']product:price''',
    caseSensitive: false,
  );
}
