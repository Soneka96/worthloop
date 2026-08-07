/// Normalizes a product URL before it's fetched. App-wide plumbing with no
/// business rule behind it — registered via DI, called from
/// `ProductPriceFetchOrchestratorService` only.
class ProductUrlCleanerService {
  static const Set<String> _trackingParamKeys = {
    'ref',
    'oref',
    'feed',
    'parentcategoryid',
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
    'fbclid',
    'gclid',
    'msclkid',
    'sv1',
    'sv_campaign_id',
    'awc',
  };

  /// Trims [url] and strips known tracking/affiliate query params
  /// (`ref`, `oref`, `feed`, `parentCategoryId`, `utm_*`, `fbclid`, `gclid`,
  /// `msclkid`) — some bot-management systems (Akamai, DataDome) treat these
  /// as a signal that the request is automated feed/affiliate traffic rather
  /// than a browsing human, and block on their presence alone. Any other
  /// query param (e.g. a Shopify `variant` id) is left untouched, since it
  /// may be load-bearing for which product/price the page renders.
  String clean(String url) {
    final String trimmed = url.trim();
    final Uri? parsed = Uri.tryParse(trimmed);
    if (parsed == null) {
      return trimmed;
    }
    try {
      if (parsed.queryParameters.isEmpty) {
        return trimmed;
      }
      final Map<String, String> keptParams = Map.of(parsed.queryParameters)
        ..removeWhere(
          (String key, _) => _trackingParamKeys.contains(key.toLowerCase()),
        );
      return _withoutBareTrailingQuestionMark(
        parsed.replace(queryParameters: keptParams).toString(),
      );
    } on FormatException {
      return trimmed;
    }
  }

  /// Strips a trailing `?` left by [Uri.replace] when every query param was
  /// removed — [Uri.replace] can't be told to clear the query outright,
  /// since passing `queryParameters: null` means "leave unchanged" there.
  String _withoutBareTrailingQuestionMark(String url) =>
      url.replaceFirst(RegExp(r'\?$'), '');
}
