// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  group('Method detect() returns the correct value', () {
    final PriceResponseDetector detector = PriceResponseDetector();

    test('classifies a usable price as success', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '{"price": "19.99"}',
        hasUsablePrice: true,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.success);
    });

    test('classifies missing response status as a network error', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: null,
        responseBody: '',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.networkError);
    });

    test('classifies server failures as network errors', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 503,
        responseBody: 'Service unavailable',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.networkError);
    });

    test('classifies a malformed price response as invalid data', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '{"price": "not-a-number"}',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.invalidData);
    });

    test('classifies forbidden responses as blocked', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 403,
        responseBody: 'Access denied',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.blocked);
    });

    test('classifies rate-limited responses as blocked', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 429,
        responseBody: 'Too many requests',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.blocked);
    });

    test('classifies challenge pages as blocked', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody:
            '<title>Checking your browser before accessing the site</title>',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.blocked);
    });

    test(
      'classifies a blocked id/class attribute marker with no price as blocked',
      () {
        final PriceFetchStatus status = detector.detect(
          statusCode: 200,
          responseBody: '<div id="cf-chl-widget"></div>',
          hasUsablePrice: false,
        );

        expect(status, isA<PriceFetchStatus>());
        expect(status, PriceFetchStatus.blocked);
      },
    );

    test('classifies a page without price data as unsupported', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '<html><title>Product</title></html>',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.unsupported);
    });

    test('ignores challenge words inside ordinary product content', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody:
            '<div class="product-description">Includes a captcha toy and access denied board game.</div>',
        hasUsablePrice: true,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.success);
    });

    test('prefers a usable price over a blocked status code', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 403,
        responseBody: '{"price": "19.99"}',
        hasUsablePrice: true,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.success);
    });

    test('prefers a usable price over a blocked id/class attribute marker', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '<div id="grecaptcha-badge"></div>{"price": "19.99"}',
        hasUsablePrice: true,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.success);
    });

    test('prefers a usable price over a server failure status code', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 500,
        responseBody: '{"price": "19.99"}',
        hasUsablePrice: true,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.success);
    });

    test('prefers a network error over price data in the body', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: null,
        responseBody: '{"price": "19.99"}',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.networkError);
    });

    test(
      'prefers a server failure status code over price data in the body',
      () {
        final PriceFetchStatus status = detector.detect(
          statusCode: 503,
          responseBody: '{"price": "19.99"}',
          hasUsablePrice: false,
        );

        expect(status, isA<PriceFetchStatus>());
        expect(status, PriceFetchStatus.networkError);
      },
    );

    test('prefers malformed price data over a blocked status code', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 403,
        responseBody: '{"price": "not-a-number"}',
        hasUsablePrice: false,
      );

      expect(status, isA<PriceFetchStatus>());
      expect(status, PriceFetchStatus.invalidData);
    });

    test(
      'prefers malformed price data over a blocked id/class attribute marker',
      () {
        final PriceFetchStatus status = detector.detect(
          statusCode: 200,
          responseBody:
              '<div id="grecaptcha-badge"></div>{"price": "not-a-number"}',
          hasUsablePrice: false,
        );

        expect(status, isA<PriceFetchStatus>());
        expect(status, PriceFetchStatus.invalidData);
      },
    );
  });
}
