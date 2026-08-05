// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  group('PriceResponseDetector.detect', () {
    final PriceResponseDetector detector = PriceResponseDetector();

    test('classifies forbidden responses as blocked', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 403,
        responseBody: 'Access denied',
        hasUsablePrice: false,
      );

      expect(status, PriceFetchStatus.blocked);
    });

    test('classifies challenge pages as blocked', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody:
            '<title>Checking your browser before accessing the site</title>',
        hasUsablePrice: false,
      );

      expect(status, PriceFetchStatus.blocked);
    });

    test('classifies server failures as network errors', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 503,
        responseBody: 'Service unavailable',
        hasUsablePrice: false,
      );

      expect(status, PriceFetchStatus.networkError);
    });

    test('classifies a usable price as success', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '{"price": "19.99"}',
        hasUsablePrice: true,
      );

      expect(status, PriceFetchStatus.success);
    });

    test('classifies a malformed price response as invalid data', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '{"price": "not-a-number"}',
        hasUsablePrice: false,
      );

      expect(status, PriceFetchStatus.invalidData);
    });

    test('classifies a page without price data as unsupported', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody: '<html><title>Product</title></html>',
        hasUsablePrice: false,
      );

      expect(status, PriceFetchStatus.unsupported);
    });

    test('ignores challenge words inside ordinary product content', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: 200,
        responseBody:
            '<div class="product-description">Includes a captcha toy and access denied board game.</div>',
        hasUsablePrice: true,
      );

      expect(status, PriceFetchStatus.success);
    });

    test('classifies missing response status as a network error', () {
      final PriceFetchStatus status = detector.detect(
        statusCode: null,
        responseBody: '',
        hasUsablePrice: false,
      );

      expect(status, PriceFetchStatus.networkError);
    });
  });
}
