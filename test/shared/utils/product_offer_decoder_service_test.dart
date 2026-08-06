// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer_decoder_service.dart';

void main() {
  group('ProductOfferDecoderService behaves correctly', () {
    late ProductOfferDecoderService service;

    setUp(() {
      service = ProductOfferDecoderService();
    });

    test('extracts a JSON-LD offer with its currency', () {
      final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@type":"Product","offers":{"price":"19.99","priceCurrency":"USD"}}
        </script>
      ''');

      expect(result, isA<ProductOffer>());
      expect(result?.minorUnits, 1999);
      expect(result?.currencyCode, 'USD');
      expect(result?.isAvailable, isTrue);
    });

    test('returns null for a JSON-LD offer without currency metadata', () {
      final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@type":"Product","offers":{"price":"19.99"}}
        </script>
      ''');

      expect(result, isNull);
    });

    test(
      'skips malformed JSON-LD offers and parses formatted aggregate prices',
      () {
        final ProductOffer? result = service.decode('''
          <script type="application/ld+json">
            {"@type":"Product","offers":[
              {"price":"not-a-number","priceCurrency":"EUR"},
              {"@type":"AggregateOffer","lowPrice":"1,234.56","priceCurrency":" EUR "}
            ]}
          </script>
        ''');

        expect(result?.minorUnits, 123456);
        expect(result?.currencyCode, 'EUR');
      },
    );

    test('returns null when html has no supported price markup', () {
      final ProductOffer? result = service.decode(
        '<html><title>Product</title></html>',
      );

      expect(result, isNull);
    });

    test('extracts a price from Open Graph product:price meta tags', () {
      final ProductOffer? result = service.decode('''
        <meta property="product:price:amount" content="199.99">
        <meta property="product:price:currency" content="EUR">
      ''');

      expect(result?.minorUnits, 19999);
      expect(result?.currencyCode, 'EUR');
      expect(result?.isAvailable, isTrue);
    });

    test('extracts a price from microdata itemprop meta tags', () {
      final ProductOffer? result = service.decode('''
        <meta itemprop="price" content="159.99">
        <meta itemprop="priceCurrency" content="EUR">
      ''');

      expect(result?.minorUnits, 15999);
      expect(result?.currencyCode, 'EUR');
      expect(result?.isAvailable, isTrue);
    });

    test('prefers a JSON-LD offer over microdata when both are present', () {
      final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@type":"Product","offers":{"price":"19.99","priceCurrency":"USD"}}
        </script>
        <meta itemprop="price" content="159.99">
        <meta itemprop="priceCurrency" content="EUR">
      ''');

      expect(result?.minorUnits, 1999);
      expect(result?.currencyCode, 'USD');
    });

    test(
      'prefers Open Graph meta tags over microdata when both are present',
      () {
        final ProductOffer? result = service.decode('''
        <meta property="product:price:amount" content="199.99">
        <meta property="product:price:currency" content="EUR">
        <meta itemprop="price" content="159.99">
        <meta itemprop="priceCurrency" content="USD">
      ''');

        expect(result?.minorUnits, 19999);
        expect(result?.currencyCode, 'EUR');
      },
    );

    test('reports isAvailable false for a JSON-LD out-of-stock offer', () {
      final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@type":"Product","offers":{"price":"19.99","priceCurrency":"USD","availability":"https://schema.org/OutOfStock"}}
        </script>
      ''');

      expect(result?.isAvailable, isFalse);
    });

    test(
      'falls through a malformed JSON-LD script tag to a later valid one',
      () {
        final ProductOffer? result = service.decode('''
        <script type="application/ld+json">{not valid json</script>
        <script type="application/ld+json">
          {"@type":"Product","offers":{"price":"19.99","priceCurrency":"USD"}}
        </script>
      ''');

        expect(result?.minorUnits, 1999);
        expect(result?.currencyCode, 'USD');
      },
    );

    test('finds a JSON-LD offer nested under @graph', () {
      final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@graph":[{"@type":"Product","offers":{"price":"19.99","priceCurrency":"USD"}}]}
        </script>
      ''');

      expect(result?.minorUnits, 1999);
      expect(result?.currencyCode, 'USD');
    });

    test(
      'skips a JSON-LD offer with a missing currency and parses the next one',
      () {
        final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@type":"Product","offers":[
            {"price":"19.99"},
            {"price":"29.99","priceCurrency":"USD"}
          ]}
        </script>
      ''');

        expect(result?.minorUnits, 2999);
        expect(result?.currencyCode, 'USD');
      },
    );

    test('returns null when a meta price tag has no matching currency tag', () {
      final ProductOffer? result = service.decode(
        '<meta property="product:price:amount" content="199.99">',
      );

      expect(result, isNull);
    });

    test(
      'returns null when a microdata price tag has no matching currency tag',
      () {
        final ProductOffer? result = service.decode(
          '<meta itemprop="price" content="159.99">',
        );

        expect(result, isNull);
      },
    );

    test('extracts an Open Graph meta tag regardless of attribute order', () {
      final ProductOffer? result = service.decode('''
        <meta content="199.99" property="product:price:amount">
        <meta content="EUR" property="product:price:currency">
      ''');

      expect(result?.minorUnits, 19999);
      expect(result?.currencyCode, 'EUR');
    });

    test('extracts a microdata meta tag regardless of attribute order', () {
      final ProductOffer? result = service.decode('''
        <meta content="159.99" itemprop="price">
        <meta content="EUR" itemprop="priceCurrency">
      ''');

      expect(result?.minorUnits, 15999);
      expect(result?.currencyCode, 'EUR');
    });

    test(
      'extracts an Open Graph meta tag using "name" instead of "property"',
      () {
        final ProductOffer? result = service.decode('''
        <meta name="product:price:amount" content="199.99">
        <meta name="product:price:currency" content="EUR">
      ''');

        expect(result?.minorUnits, 19999);
        expect(result?.currencyCode, 'EUR');
      },
    );

    test('parses a decimal-comma price with no thousands separator', () {
      final ProductOffer? result = service.decode('''
        <script type="application/ld+json">
          {"@type":"Product","offers":{"price":"19,99","priceCurrency":"EUR"}}
        </script>
      ''');

      expect(result?.minorUnits, 1999);
      expect(result?.currencyCode, 'EUR');
    });
  });
}
