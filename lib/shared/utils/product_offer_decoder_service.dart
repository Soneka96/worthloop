// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// Project imports:
import 'package:worth_loop/shared/constants/price_fetch_constants.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';

/// Extracts a merchant's price offer from an HTML product page. Tries, in
/// order: JSON-LD `Product`/`Offer` markup, Open Graph-style
/// `product:price:*` meta tags, then Microdata `itemprop="price"` meta tags
/// or Amazon's shared offer markup — the first tier that finds a price wins.
class ProductOfferDecoderService {
  static final RegExp _jsonLdPattern = RegExp(
    r'''<script[^>]+type=["']application/ld\+json["'][^>]*>(.*?)</script>''',
    caseSensitive: false,
    dotAll: true,
  );
  static final RegExp _metaTagPattern = RegExp(
    r'<meta\b[^>]*>',
    caseSensitive: false,
  );
  static final RegExp _attrPattern = RegExp(
    r'''([a-zA-Z:-]+)\s*=\s*["']([^"']*)["']''',
  );
  static final RegExp _amazonMainOfferPattern = RegExp(
    r'''<[^>]*id=["'](?:corePrice_feature_div|corePriceDisplay_(?:desktop|mobile)_feature_div)["'][^>]*>(.*?)(?=<[^>]*id=["'](?:corePrice_feature_div|corePriceDisplay_(?:desktop|mobile)_feature_div|aod-ingress-link)["']|$)''',
    caseSensitive: false,
    dotAll: true,
  );
  static final RegExp _amazonSellerOfferPattern = RegExp(
    r'''<[^>]*id=["']aod-ingress-link["'][^>]*>(.*)$''',
    caseSensitive: false,
    dotAll: true,
  );
  static final RegExp _amazonOffscreenPricePattern = RegExp(
    r'''<span[^>]*class=["'][^"']*\ba-offscreen\b[^"']*["'][^>]*>([^<]*)</span>''',
    caseSensitive: false,
  );
  static final RegExp _amazonAccessiblePricePattern = RegExp(
    r'''<span[^>]*class=["'][^"']*\baok-offscreen\b[^"']*["'][^>]*>([^<]*)</span>''',
    caseSensitive: false,
  );
  static final RegExp _amazonVisiblePricePartPattern = RegExp(
    r'''<span[^>]*class=["'][^"']*\b(a-price-symbol|a-price-whole|a-price-decimal|a-price-fraction)\b[^"']*["'][^>]*>(.*?)</span>''',
    caseSensitive: false,
    dotAll: true,
  );
  static final RegExp _amazonPriceContainerPattern = RegExp(
    r'''<span[^>]*class=["'][^"']*\ba-price(?=\s|["'])[^"']*["'][^>]*>''',
    caseSensitive: false,
  );
  static final RegExp _amazonUnavailablePattern = RegExp(
    r'''\b(?:currently\s+unavailable|out\s+of\s+stock|sold\s+out|not\s+available)\b''',
    caseSensitive: false,
  );
  static final RegExp _amazonAmountPattern = RegExp(r'[-+]?\d[\d.,]*');
  static const Set<String> _amazonMarketplaceDomains = {
    'amazon.ae',
    'amazon.be',
    'amazon.ca',
    'amazon.cn',
    'amazon.co.jp',
    'amazon.co.uk',
    'amazon.co.za',
    'amazon.com',
    'amazon.com.au',
    'amazon.com.be',
    'amazon.com.br',
    'amazon.com.mx',
    'amazon.de',
    'amazon.eg',
    'amazon.es',
    'amazon.fr',
    'amazon.ie',
    'amazon.in',
    'amazon.it',
    'amazon.nl',
    'amazon.pl',
    'amazon.sa',
    'amazon.se',
    'amazon.sg',
    'amazon.tr',
  };
  static const Set<String> _amazonShortLinkDomains = {'amzn.eu', 'amzn.to'};
  static const Map<String, String> _amazonCurrencyCodes = {
    '€': 'EUR',
    '£': 'GBP',
    r'$': 'USD',
    r'US$': 'USD',
    r'C$': 'CAD',
    r'CA$': 'CAD',
    r'A$': 'AUD',
    r'AU$': 'AUD',
    '₹': 'INR',
    '¥': 'JPY',
    '￥': 'JPY',
    '₩': 'KRW',
    '₺': 'TRY',
    'zł': 'PLN',
  };

  /// Decodes a price offer from [html], or `null` if none of the supported
  /// markup tiers expose one. Uses [sourceUrl] to prioritize source-specific
  /// markup when the host is Amazon.
  ProductOffer? decode(String html, {String? sourceUrl}) {
    final ProductOffer? amazonOffer = _isAmazonUrl(sourceUrl)
        ? _decodeAmazonOffer(html)
        : null;
    return amazonOffer ??
        _decodeJsonLd(html) ??
        _decodeMetaTags(html) ??
        _decodeMicrodata(html) ??
        _decodeAmazonMainOffer(html) ??
        _decodeAmazonSellerOffer(html);
  }

  /// Decodes [html] on a worker isolate so large responses do not block the
  /// Flutter UI isolate. Bounded by [timeout] — some malformed pages can
  /// send these regexes into catastrophic backtracking, so an unbounded
  /// isolate hop here would leave a source stuck indefinitely; a timeout is
  /// treated the same as "no offer found."
  Future<ProductOffer?> decodeAsync(
    String html, {
    String? sourceUrl,
    Duration timeout = PriceFetchConstants.offerDecodeTimeout,
  }) async {
    final List<Object?> result;
    try {
      result = await Isolate.run(
        () => _decodeForIsolate(html, sourceUrl),
      ).timeout(timeout);
    } on TimeoutException {
      return null;
    }
    if (result.isEmpty) {
      return null;
    }
    return ProductOffer(
      minorUnits: result[0] as int,
      currencyCode: result[1] as String,
      isAvailable: result[2] as bool,
    );
  }

  ProductOffer? _decodeAmazonOffer(String html) =>
      _decodeAmazonMainOffer(html) ?? _decodeAmazonSellerOffer(html);

  bool _isAmazonUrl(String? sourceUrl) {
    if (sourceUrl == null) {
      return false;
    }
    final Uri? uri = Uri.tryParse(sourceUrl);
    final String host = uri?.host.toLowerCase() ?? '';
    return _amazonMarketplaceDomains.any(
          (String domain) => host == domain || host.endsWith('.$domain'),
        ) ||
        _amazonShortLinkDomains.any(
          (String domain) => host == domain || host.endsWith('.$domain'),
        );
  }

  ProductOffer? _decodeAmazonMainOffer(String html) =>
      _decodeAmazonSection(_amazonMainOfferPattern.firstMatch(html)?.group(1));

  ProductOffer? _decodeAmazonSellerOffer(String html) => _decodeAmazonSection(
    _amazonSellerOfferPattern.firstMatch(html)?.group(1),
  );

  ProductOffer? _decodeAmazonSection(String? section) {
    if (section == null) {
      return null;
    }
    final List<RegExp> accessiblePricePatterns = [
      _amazonAccessiblePricePattern,
      _amazonOffscreenPricePattern,
    ];
    for (final RegExp pattern in accessiblePricePatterns) {
      for (final Match priceMatch in pattern.allMatches(section)) {
        final ProductOffer? offer = _decodeAmazonPriceText(
          priceMatch.group(1),
          isAvailable: _isAmazonPriceAvailable(section, priceMatch.start),
        );
        if (offer != null) {
          return offer;
        }
      }
    }

    return _decodeAmazonVisiblePrice(section);
  }

  ProductOffer? _decodeAmazonVisiblePrice(String section) {
    final List<Match> priceContainers = _amazonPriceContainerPattern
        .allMatches(section)
        .toList();
    for (int index = 0; index < priceContainers.length; index++) {
      final Match container = priceContainers[index];
      final int containerEnd = index + 1 < priceContainers.length
          ? priceContainers[index + 1].start
          : section.length;
      final ProductOffer? offer = _decodeAmazonVisiblePriceContainer(
        section.substring(container.start, containerEnd),
        section,
        container.start,
      );
      if (offer != null) {
        return offer;
      }
    }
    return null;
  }

  ProductOffer? _decodeAmazonVisiblePriceContainer(
    String container,
    String section,
    int containerStart,
  ) {
    String? symbol;
    String? whole;
    String? decimal;
    String? fraction;
    int? firstPricePartStart;
    for (final Match match in _amazonVisiblePricePartPattern.allMatches(
      container,
    )) {
      firstPricePartStart ??= match.start;
      final String value = _stripAmazonMarkup(match.group(2) ?? '');
      switch (match.group(1)?.toLowerCase()) {
        case 'a-price-symbol':
          symbol ??= value;
        case 'a-price-whole':
          whole ??= value;
        case 'a-price-decimal':
          decimal ??= value;
        case 'a-price-fraction':
          fraction ??= value;
      }
    }
    if (symbol == null || whole == null) {
      return null;
    }
    final String separator = whole.endsWith('.') || whole.endsWith(',')
        ? ''
        : decimal ?? '';
    final String priceText = '$symbol$whole$separator${fraction ?? ''}';
    return _decodeAmazonPriceText(
      priceText,
      isAvailable: _isAmazonPriceAvailable(
        section,
        containerStart + (firstPricePartStart ?? 0),
      ),
    );
  }

  ProductOffer? _decodeAmazonPriceText(
    String? priceText, {
    required bool isAvailable,
  }) {
    if (priceText == null) {
      return null;
    }
    final String normalizedPriceText = _stripAmazonMarkup(priceText)
        .replaceAll(
          RegExp(r'&(?:euro|#8364|#x20ac);', caseSensitive: false),
          '€',
        )
        .replaceAll(RegExp(r'&(?:pound|#163|#xa3);', caseSensitive: false), '£')
        .replaceAll(RegExp(r'&(?:nbsp|#160|#xa0);', caseSensitive: false), ' ');
    final Match? amountMatch = _amazonAmountPattern.firstMatch(
      normalizedPriceText,
    );
    final num? amount = _parseNumber(amountMatch?.group(0));
    final String currencyText = normalizedPriceText
        .replaceAll(amountMatch?.group(0) ?? '', '')
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
    final String? currencyCode =
        _amazonCurrencyCodes[currencyText] ??
        (RegExp(r'^[A-Z]{3}$').hasMatch(currencyText.toUpperCase())
            ? currencyText.toUpperCase()
            : null);
    if (amount == null || currencyCode == null) {
      return null;
    }
    return ProductOffer(
      minorUnits: (amount.toDouble() * 100).round(),
      currencyCode: currencyCode,
      isAvailable: isAvailable,
    );
  }

  bool _isAmazonPriceAvailable(String section, int priceStart) {
    final int contextStart = priceStart > 600 ? priceStart - 600 : 0;
    final int contextEnd = priceStart + 600 < section.length
        ? priceStart + 600
        : section.length;
    return !_amazonUnavailablePattern.hasMatch(
      section.substring(contextStart, contextEnd),
    );
  }

  String _stripAmazonMarkup(String value) => value
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('\u00a0', ' ')
      .trim();

  ProductOffer? _decodeJsonLd(String html) {
    for (final Match match in _jsonLdPattern.allMatches(html)) {
      final String json = match.group(1)?.trim() ?? '';
      if (json.isEmpty) {
        continue;
      }
      try {
        final dynamic decoded = jsonDecode(json);
        for (final Map<String, dynamic> offer in _findJsonLdOffers(decoded)) {
          final num? amount = _parseNumber(offer['price'] ?? offer['lowPrice']);
          final String? currencyValue = offer['priceCurrency']?.toString();
          if (amount == null ||
              currencyValue == null ||
              currencyValue.trim().isEmpty) {
            continue;
          }
          final String availability =
              offer['availability']?.toString().toLowerCase() ?? '';
          return ProductOffer(
            minorUnits: (amount.toDouble() * 100).round(),
            currencyCode: currencyValue.trim().toUpperCase(),
            isAvailable:
                !availability.contains('outofstock') &&
                !availability.contains('soldout') &&
                !availability.contains('unavailable'),
          );
        }
      } on FormatException {
        continue;
      }
    }
    return null;
  }

  Iterable<Map<String, dynamic>> _findJsonLdOffers(dynamic value) sync* {
    if (value is List) {
      for (final dynamic item in value) {
        yield* _findJsonLdOffers(item);
      }
      return;
    }
    if (value is! Map) {
      return;
    }
    final Map<dynamic, dynamic> map = value;
    if (map['price'] != null || map['lowPrice'] != null) {
      yield Map<String, dynamic>.from(map);
    }
    yield* _findJsonLdOffers(map['offers']);
    yield* _findJsonLdOffers(map['@graph']);
  }

  /// No site tested exposes an availability signal in `product:price:*`
  /// meta tags, so this tier always reports `isAvailable: true`.
  ProductOffer? _decodeMetaTags(String html) {
    final num? amount = _parseNumber(
      _metaContent(html, property: 'product:price:amount'),
    );
    final String? currencyText = _metaContent(
      html,
      property: 'product:price:currency',
    );
    if (amount == null || currencyText == null || currencyText.trim().isEmpty) {
      return null;
    }
    return ProductOffer(
      minorUnits: (amount.toDouble() * 100).round(),
      currencyCode: currencyText.trim().toUpperCase(),
      isAvailable: true,
    );
  }

  /// No site tested exposes an availability signal via `itemprop`, so this
  /// tier always reports `isAvailable: true`.
  ProductOffer? _decodeMicrodata(String html) {
    final num? amount = _parseNumber(_metaItemprop(html, 'price'));
    final String? currencyText = _metaItemprop(html, 'priceCurrency');
    if (amount == null || currencyText == null || currencyText.trim().isEmpty) {
      return null;
    }
    return ProductOffer(
      minorUnits: (amount.toDouble() * 100).round(),
      currencyCode: currencyText.trim().toUpperCase(),
      isAvailable: true,
    );
  }

  /// Open Graph tags are conventionally `property`, but some sites use
  /// `name` instead — both are checked regardless of attribute order.
  String? _metaContent(String html, {required String property}) =>
      _findMetaContent(html, attrName: 'property', attrValue: property) ??
      _findMetaContent(html, attrName: 'name', attrValue: property);

  String? _metaItemprop(String html, String itemprop) =>
      _findMetaContent(html, attrName: 'itemprop', attrValue: itemprop);

  /// Parses each `<meta>` tag's attributes into a map rather than matching
  /// [attrName] and `content` with a fixed regex order, since real markup
  /// puts them in either order.
  String? _findMetaContent(
    String html, {
    required String attrName,
    required String attrValue,
  }) {
    for (final Match tagMatch in _metaTagPattern.allMatches(html)) {
      final Map<String, String> attrs = _parseAttrs(tagMatch.group(0) ?? '');
      if (attrs[attrName]?.toLowerCase() == attrValue.toLowerCase()) {
        final String? content = attrs['content'];
        if (content != null) {
          return content;
        }
      }
    }
    return null;
  }

  Map<String, String> _parseAttrs(String tag) {
    final Map<String, String> attrs = {};
    for (final Match match in _attrPattern.allMatches(tag)) {
      final String? name = match.group(1);
      if (name != null) {
        attrs[name.toLowerCase()] = match.group(2) ?? '';
      }
    }
    return attrs;
  }

  num? _parseNumber(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value == null) {
      return null;
    }
    String normalized = value.toString().trim();
    final int commaIndex = normalized.lastIndexOf(',');
    final int periodIndex = normalized.lastIndexOf('.');
    if (commaIndex >= 0 && periodIndex >= 0) {
      normalized = commaIndex > periodIndex
          ? normalized.replaceAll('.', '').replaceFirst(',', '.')
          : normalized.replaceAll(',', '');
    } else if (commaIndex >= 0) {
      final int fractionalDigits = normalized.length - commaIndex - 1;
      normalized = fractionalDigits == 3
          ? normalized.replaceAll(',', '')
          : normalized.replaceFirst(',', '.');
    }
    return num.tryParse(normalized);
  }
}

List<Object?> _decodeForIsolate(String html, String? sourceUrl) {
  final ProductOffer? offer = ProductOfferDecoderService().decode(
    html,
    sourceUrl: sourceUrl,
  );
  return offer == null
      ? const <Object?>[]
      : <Object?>[offer.minorUnits, offer.currencyCode, offer.isAvailable];
}
