// Project imports:
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/price_fetch_constants.dart';
import 'package:worth_loop/shared/utils/dio_product_fetcher_service.dart';
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/price_fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer_decoder_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';
import 'package:worth_loop/shared/utils/webview_product_fetcher_service.dart';

/// Fetches and classifies a product's price, trying Dio first and falling
/// back to a headless WebView when Dio is blocked, returns invalid data, or
/// exposes no supported price markup. App-wide plumbing with no business
/// rule behind it — registered via DI, called from `ProductsRemoteDatasource`
/// only.
class ProductPriceFetchOrchestratorService {
  final ProductUrlCleanerService _urlCleaner;
  final DioProductFetcherService _dioFetcher;
  final WebViewProductFetcherService _webViewFetcher;
  final ProductOfferDecoderService _offerDecoder;
  final PriceResponseDetector _detector;
  final DateTime Function() _now;

  /// Creates an orchestrator backed by [_urlCleaner], [_dioFetcher],
  /// [_webViewFetcher], [_offerDecoder] and [_detector].
  ProductPriceFetchOrchestratorService(
    this._urlCleaner,
    this._dioFetcher,
    this._webViewFetcher,
    this._offerDecoder,
    this._detector, {
    DateTime Function() now = DateTime.now,
  }) : _now = now;

  static const Set<PriceFetchStatus> _fallbackTriggers = {
    PriceFetchStatus.blocked,
    PriceFetchStatus.invalidData,
    PriceFetchStatus.unsupported,
  };

  final Map<String, DateTime> _blockedUntilByUrl = {};

  /// Fetches and classifies a price offer for [url] — Dio first, falling
  /// back to a headless WebView on [_fallbackTriggers]. Tracks a per-URL
  /// cooldown so a blocked source isn't retried immediately.
  Future<PriceFetchResult> fetch(String url) async {
    final String cleanedUrl = _urlCleaner.clean(url);
    final DateTime? blockedUntil = _blockedUntilByUrl[cleanedUrl];
    if (blockedUntil != null && _now().isBefore(blockedUntil)) {
      return const PriceFetchResult(
        status: PriceFetchStatus.blocked,
        offer: null,
      );
    }

    PriceFetchResult result = _classify(await _dioFetcher.fetch(cleanedUrl));
    if (_fallbackTriggers.contains(result.status)) {
      result = _classify(await _webViewFetcher.fetch(cleanedUrl));
    }
    if (result.status == PriceFetchStatus.blocked) {
      _blockedUntilByUrl[cleanedUrl] = _now().add(
        PriceFetchConstants.blockedRetryAfter,
      );
    }
    return result;
  }

  PriceFetchResult _classify(FetchResult fetchResult) {
    final ProductOffer? offer = _offerDecoder.decode(fetchResult.body);
    final PriceFetchStatus status = _detector.detect(
      statusCode: fetchResult.statusCode,
      responseBody: fetchResult.body,
      hasUsablePrice: offer != null,
    );
    return PriceFetchResult(
      status: status,
      offer: status == PriceFetchStatus.success ? offer : null,
    );
  }
}
