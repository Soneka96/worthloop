// Dart imports:
import 'dart:convert';

// Project imports:
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
    r'''<span[^>]*class=["'][^"']*\ba-offscreen\b[^"']*["'][^>]*>([^<]+)</span>''',
    caseSensitive: false,
  );
  static final RegExp _amazonAmountPattern = RegExp(r'[-+]?\d[\d.,]*');
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
  /// markup tiers expose one.
  ProductOffer? decode(String html) {
    return _decodeJsonLd(html) ??
        _decodeMetaTags(html) ??
        _decodeMicrodata(html) ??
        _decodeAmazonMainOffer(html) ??
        _decodeAmazonSellerOffer(html);
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
    final Match? priceMatch = _amazonOffscreenPricePattern.firstMatch(section);
    final String? priceText = priceMatch?.group(1);
    if (priceText == null) {
      return null;
    }
    final Match? amountMatch = _amazonAmountPattern.firstMatch(priceText);
    final num? amount = _parseNumber(amountMatch?.group(0));
    final String currencyText = priceText
        .replaceAll(amountMatch?.group(0) ?? '', '')
        .replaceAll('&nbsp;', '')
        .replaceAll('\u00a0', '')
        .trim();
    final String? currencyCode =
        _amazonCurrencyCodes[currencyText] ??
        (RegExp(r'^[A-Z]{3}$').hasMatch(currencyText) ? currencyText : null);
    if (amount == null || currencyCode == null) {
      return null;
    }
    return ProductOffer(
      minorUnits: (amount.toDouble() * 100).round(),
      currencyCode: currencyCode,
      isAvailable: true,
    );
  }

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
