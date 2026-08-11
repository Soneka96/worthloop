// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';

void main() {
  group('ProductUrlCleanerService behaves correctly', () {
    late ProductUrlCleanerService service;

    setUp(() {
      service = ProductUrlCleanerService();
    });

    test('trims leading and trailing whitespace', () {
      final String result = service.clean('  https://example.com/product-1  ');

      expect(result, isA<String>());
      expect(result, 'https://example.com/product-1');
    });

    test('leaves an already-clean URL unchanged', () {
      final String result = service.clean('https://example.com/product-1');

      expect(result, isA<String>());
      expect(result, 'https://example.com/product-1');
    });

    test('returns an empty string when url is empty', () {
      final String result = service.clean('');

      expect(result, isA<String>());
      expect(result, '');
    });

    test('returns an empty string when url is whitespace-only', () {
      final String result = service.clean('   ');

      expect(result, isA<String>());
      expect(result, '');
    });

    test('strips ref, feed and parentCategoryId tracking params', () {
      final String result = service.clean(
        'https://www.elcorteingles.pt/tecnologia/A200847441-base-moza-direct-drive-r12-v2/'
        '?parentCategoryId=5007.18708617024&ref=001028645002941&feed=true',
      );

      expect(result, isA<String>());
      expect(
        result,
        'https://www.elcorteingles.pt/tecnologia/A200847441-base-moza-direct-drive-r12-v2/',
      );
    });

    test('strips an oref tracking param', () {
      final String result = service.clean(
        'https://www.fnac.pt/mp25869813/product-name?oref=c8502958-6892',
      );

      expect(result, isA<String>());
      expect(result, 'https://www.fnac.pt/mp25869813/product-name');
    });

    test('strips utm_source, fbclid and gclid tracking params', () {
      final String result = service.clean(
        'https://example.com/product-1?utm_source=newsletter&fbclid=abc&gclid=xyz',
      );

      expect(result, isA<String>());
      expect(result, 'https://example.com/product-1');
    });

    test('strips PcComponentes affiliate params', () {
      const String firstUrl =
          'https://www.pccomponentes.pt/moza-racing-r12-v2-base-para-volante-direct-drive-12nm-aluminio-preto?'
          'utm_source=176013&utm_medium=afi&utm_campaign=pt.redbrain.shop&sv1=affiliate&sv_campaign_id=176013&awc=20983_1786099189_f5da4f824a3c928150facd2305d679c3&utm_term=deeplink&utm_content=pt.redbrain.shop';
      const String secondUrl =
          'https://www.pccomponentes.pt/moza-racing-r12-v2-base-para-volante-direct-drive-12nm-aluminio-preto?'
          'sv1=affiliate&sv_campaign_id=369493&awc=20983_1786038606_0fb8628229063e19c574bbcc1aaf4dd5';

      final String firstResult = service.clean(firstUrl);
      final String secondResult = service.clean(secondUrl);

      expect(firstResult, isA<String>());
      expect(
        firstResult,
        'https://www.pccomponentes.pt/moza-racing-r12-v2-base-para-volante-direct-drive-12nm-aluminio-preto',
      );
      expect(secondResult, isA<String>());
      expect(secondResult, firstResult);
    });

    test('keeps a non-tracking query param such as a Shopify variant id', () {
      final String result = service.clean(
        'https://simufy.com/products/pedales-moza-srp2?variant=53591391338829',
      );

      expect(result, isA<String>());
      expect(
        result,
        'https://simufy.com/products/pedales-moza-srp2?variant=53591391338829',
      );
    });

    test(
      'strips only the tracking params when mixed with a non-tracking param',
      () {
        final String result = service.clean(
          'https://example.com/product-1?variant=123&utm_source=newsletter',
        );

        expect(result, isA<String>());
        expect(result, 'https://example.com/product-1?variant=123');
      },
    );

    test('strips tracking params regardless of key casing', () {
      final String result = service.clean(
        'https://example.com/product-1?UTM_SOURCE=x&REF=y',
      );

      expect(result, isA<String>());
      expect(result, 'https://example.com/product-1');
    });

    test('strips a tracking param that has an empty value', () {
      final String result = service.clean('https://example.com/product-1?ref=');

      expect(result, isA<String>());
      expect(result, 'https://example.com/product-1');
    });

    test('leaves a bare trailing "?" with no query params unchanged', () {
      final String result = service.clean('https://example.com/product-1?');

      expect(result, isA<String>());
      expect(result, 'https://example.com/product-1?');
    });

    test('keeps params that only partially match a tracking key name', () {
      final String result = service.clean(
        'https://example.com/product-1?my_utm_source=x&utm_sources=y',
      );

      expect(result, isA<String>());
      expect(
        result,
        'https://example.com/product-1?my_utm_source=x&utm_sources=y',
      );
    });

    test('returns the trimmed original when the url fails to parse', () {
      final String result = service.clean('http://[invalid');

      expect(result, isA<String>());
      expect(result, 'http://[invalid');
    });
  });
}
