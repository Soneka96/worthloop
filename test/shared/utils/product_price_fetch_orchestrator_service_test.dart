// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/price_fetch_constants.dart';
import 'package:worth_loop/shared/utils/dio_product_fetcher_service.dart';
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/price_fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer_decoder_service.dart';
import 'package:worth_loop/shared/utils/product_price_fetch_orchestrator_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';
import 'package:worth_loop/shared/utils/webview_product_fetcher_service.dart';
import '../fixtures/fetch_result.fixture.dart';
import '../fixtures/product_offer.fixture.dart';

class MockProductUrlCleanerService extends Mock
    implements ProductUrlCleanerService {}

class MockDioProductFetcherService extends Mock
    implements DioProductFetcherService {}

class MockWebViewProductFetcherService extends Mock
    implements WebViewProductFetcherService {}

class MockProductOfferDecoderService extends Mock
    implements ProductOfferDecoderService {}

class MockPriceResponseDetector extends Mock implements PriceResponseDetector {}

void main() {
  late MockProductUrlCleanerService urlCleaner;
  late MockDioProductFetcherService dioFetcher;
  late MockWebViewProductFetcherService webViewFetcher;
  late MockProductOfferDecoderService offerDecoder;
  late MockPriceResponseDetector detector;
  late ProductPriceFetchOrchestratorService orchestrator;
  late DateTime now;
  const String url = 'https://example.com/product-1?ref=x';
  const String cleanedUrl = 'https://example.com/product-1';

  setUp(() {
    now = DateTime(2026);
    urlCleaner = MockProductUrlCleanerService();
    dioFetcher = MockDioProductFetcherService();
    webViewFetcher = MockWebViewProductFetcherService();
    offerDecoder = MockProductOfferDecoderService();
    detector = MockPriceResponseDetector();
    orchestrator = ProductPriceFetchOrchestratorService(
      urlCleaner,
      dioFetcher,
      webViewFetcher,
      offerDecoder,
      detector,
      now: () => now,
    );
    when(() => urlCleaner.clean(any())).thenReturn(cleanedUrl);
  });

  group('Method fetch() returns the correct value', () {
    test(
      'returns success from the Dio attempt without calling the WebView fetcher',
      () async {
        final FetchResult dioResult = buildFetchResult();
        final ProductOffer offer = buildProductOffer();
        when(
          () => dioFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => offerDecoder.decode(dioResult.body, sourceUrl: cleanedUrl),
        ).thenReturn(offer);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: true,
          ),
        ).thenReturn(PriceFetchStatus.success);

        final PriceFetchResult result = await orchestrator.fetch(url);

        expect(result, isA<PriceFetchResult>());
        expect(result.status, PriceFetchStatus.success);
        expect(result.offer, offer);
        verify(
          () => offerDecoder.decode(dioResult.body, sourceUrl: cleanedUrl),
        ).called(1);
        verifyNever(() => webViewFetcher.fetch(any()));
      },
    );

    for (final PriceFetchStatus status in [
      PriceFetchStatus.blocked,
      PriceFetchStatus.invalidData,
      PriceFetchStatus.unsupported,
    ]) {
      test(
        'falls back to the WebView fetcher when Dio classifies as ${status.name}',
        () async {
          final FetchResult dioResult = buildFetchResult(statusCode: 403);
          final FetchResult webResult = buildFetchResult(
            statusCode: 200,
            body: '<html>ok</html>',
          );
          final ProductOffer offer = buildProductOffer();
          when(
            () => dioFetcher.fetch(cleanedUrl),
          ).thenAnswer((_) async => dioResult);
          when(
            () => offerDecoder.decode(dioResult.body, sourceUrl: cleanedUrl),
          ).thenReturn(null);
          when(
            () => detector.detect(
              statusCode: dioResult.statusCode,
              responseBody: dioResult.body,
              hasUsablePrice: false,
            ),
          ).thenReturn(status);
          when(
            () => webViewFetcher.fetch(cleanedUrl),
          ).thenAnswer((_) async => webResult);
          when(
            () => offerDecoder.decode(webResult.body, sourceUrl: cleanedUrl),
          ).thenReturn(offer);
          when(
            () => detector.detect(
              statusCode: webResult.statusCode,
              responseBody: webResult.body,
              hasUsablePrice: true,
            ),
          ).thenReturn(PriceFetchStatus.success);

          final PriceFetchResult result = await orchestrator.fetch(url);

          expect(result.status, PriceFetchStatus.success);
          expect(result.offer, offer);
          verify(() => webViewFetcher.fetch(cleanedUrl)).called(1);
          verify(
            () => offerDecoder.decode(webResult.body, sourceUrl: cleanedUrl),
          ).called(1);
        },
      );
    }

    test(
      'discards a decoded offer when the final status is not success',
      () async {
        final FetchResult dioResult = buildFetchResult(statusCode: 403);
        final ProductOffer offer = buildProductOffer();
        when(
          () => dioFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => offerDecoder.decode(dioResult.body, sourceUrl: cleanedUrl),
        ).thenReturn(offer);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: true,
          ),
        ).thenReturn(PriceFetchStatus.blocked);
        when(
          () => webViewFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: true,
          ),
        ).thenReturn(PriceFetchStatus.blocked);

        final PriceFetchResult result = await orchestrator.fetch(url);

        expect(result.status, PriceFetchStatus.blocked);
        expect(result.offer, isNull);
      },
    );

    test(
      'does not call the WebView fetcher when Dio classifies as networkError',
      () async {
        final FetchResult dioResult = buildFetchResult(
          statusCode: null,
          body: '',
        );
        when(
          () => dioFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => offerDecoder.decode(dioResult.body, sourceUrl: cleanedUrl),
        ).thenReturn(null);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: false,
          ),
        ).thenReturn(PriceFetchStatus.networkError);

        final PriceFetchResult result = await orchestrator.fetch(url);

        expect(result.status, PriceFetchStatus.networkError);
        expect(result.offer, isNull);
        verifyNever(() => webViewFetcher.fetch(any()));
      },
    );

    test(
      'returns the WebView attempt status even when it is still a failure',
      () async {
        final FetchResult dioResult = buildFetchResult(statusCode: 403);
        final FetchResult webResult = buildFetchResult(
          statusCode: null,
          body: '',
        );
        when(
          () => dioFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => offerDecoder.decode(dioResult.body, sourceUrl: cleanedUrl),
        ).thenReturn(null);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: false,
          ),
        ).thenReturn(PriceFetchStatus.blocked);
        when(
          () => webViewFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => webResult);
        when(
          () => offerDecoder.decode(webResult.body, sourceUrl: cleanedUrl),
        ).thenReturn(null);
        when(
          () => detector.detect(
            statusCode: webResult.statusCode,
            responseBody: webResult.body,
            hasUsablePrice: false,
          ),
        ).thenReturn(PriceFetchStatus.networkError);

        final PriceFetchResult result = await orchestrator.fetch(url);

        expect(result.status, PriceFetchStatus.networkError);
        expect(result.offer, isNull);
      },
    );

    test('sets the cooldown when the final status is blocked', () async {
      final FetchResult dioResult = buildFetchResult(statusCode: 403);
      final FetchResult webResult = buildFetchResult(statusCode: 403);
      when(
        () => dioFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => dioResult);
      when(
        () => offerDecoder.decode(any(), sourceUrl: any(named: 'sourceUrl')),
      ).thenReturn(null);
      when(
        () => detector.detect(
          statusCode: dioResult.statusCode,
          responseBody: dioResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);
      when(
        () => webViewFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => webResult);
      when(
        () => detector.detect(
          statusCode: webResult.statusCode,
          responseBody: webResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);

      await orchestrator.fetch(url);
      final PriceFetchResult result = await orchestrator.fetch(url);

      expect(result.status, PriceFetchStatus.blocked);
      expect(result.offer, isNull);
      verify(() => dioFetcher.fetch(cleanedUrl)).called(1);
    });

    test(
      'does not set the cooldown when the final status is not blocked',
      () async {
        final FetchResult dioResult = buildFetchResult(statusCode: 404);
        when(
          () => dioFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => offerDecoder.decode(any(), sourceUrl: any(named: 'sourceUrl')),
        ).thenReturn(null);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: false,
          ),
        ).thenReturn(PriceFetchStatus.unsupported);
        when(
          () => webViewFetcher.fetch(cleanedUrl),
        ).thenAnswer((_) async => dioResult);
        when(
          () => detector.detect(
            statusCode: dioResult.statusCode,
            responseBody: dioResult.body,
            hasUsablePrice: false,
          ),
        ).thenReturn(PriceFetchStatus.unsupported);

        await orchestrator.fetch(url);
        await orchestrator.fetch(url);

        verify(() => dioFetcher.fetch(cleanedUrl)).called(2);
      },
    );

    test('does not re-fetch during an active cooldown', () async {
      final FetchResult dioResult = buildFetchResult(statusCode: 403);
      when(
        () => dioFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => dioResult);
      when(
        () => offerDecoder.decode(any(), sourceUrl: any(named: 'sourceUrl')),
      ).thenReturn(null);
      when(
        () => detector.detect(
          statusCode: dioResult.statusCode,
          responseBody: dioResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);
      when(
        () => webViewFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => dioResult);
      when(
        () => detector.detect(
          statusCode: dioResult.statusCode,
          responseBody: dioResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);

      await orchestrator.fetch(url);
      final PriceFetchResult result = await orchestrator.fetch(url);

      expect(result.status, PriceFetchStatus.blocked);
      expect(result.offer, isNull);
      verify(() => dioFetcher.fetch(cleanedUrl)).called(1);
      verify(() => webViewFetcher.fetch(cleanedUrl)).called(1);
      verifyNoMoreInteractions(dioFetcher);
      verifyNoMoreInteractions(webViewFetcher);
      verify(
        () => offerDecoder.decode(any(), sourceUrl: any(named: 'sourceUrl')),
      ).called(2);
      verify(
        () => detector.detect(
          statusCode: any(named: 'statusCode'),
          responseBody: any(named: 'responseBody'),
          hasUsablePrice: any(named: 'hasUsablePrice'),
        ),
      ).called(2);
    });

    test('resumes fetching after the cooldown has expired', () async {
      final FetchResult blockedResult = buildFetchResult(statusCode: 403);
      when(
        () => dioFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => blockedResult);
      when(
        () => offerDecoder.decode(any(), sourceUrl: any(named: 'sourceUrl')),
      ).thenReturn(null);
      when(
        () => detector.detect(
          statusCode: blockedResult.statusCode,
          responseBody: blockedResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);
      when(
        () => webViewFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => blockedResult);

      await orchestrator.fetch(url);
      now = now.add(PriceFetchConstants.blockedRetryAfter * 2);
      await orchestrator.fetch(url);

      verify(() => dioFetcher.fetch(cleanedUrl)).called(2);
    });

    test('tracks cooldowns independently for different cleaned urls', () async {
      const String otherUrl = 'https://example.com/product-2';
      when(() => urlCleaner.clean(url)).thenReturn(cleanedUrl);
      when(() => urlCleaner.clean(otherUrl)).thenReturn(otherUrl);
      final FetchResult blockedResult = buildFetchResult(statusCode: 403);
      final FetchResult okResult = buildFetchResult(
        statusCode: 200,
        body: '<html>ok</html>',
      );
      final ProductOffer offer = buildProductOffer();
      when(
        () => dioFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => blockedResult);
      when(
        () => offerDecoder.decode(blockedResult.body, sourceUrl: cleanedUrl),
      ).thenReturn(null);
      when(
        () => detector.detect(
          statusCode: blockedResult.statusCode,
          responseBody: blockedResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);
      when(
        () => webViewFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => blockedResult);
      when(() => dioFetcher.fetch(otherUrl)).thenAnswer((_) async => okResult);
      when(
        () => offerDecoder.decode(okResult.body, sourceUrl: otherUrl),
      ).thenReturn(offer);
      when(
        () => detector.detect(
          statusCode: okResult.statusCode,
          responseBody: okResult.body,
          hasUsablePrice: true,
        ),
      ).thenReturn(PriceFetchStatus.success);

      await orchestrator.fetch(url);
      final PriceFetchResult result = await orchestrator.fetch(otherUrl);

      expect(result.status, PriceFetchStatus.success);
      expect(result.offer, offer);
      verify(() => dioFetcher.fetch(otherUrl)).called(1);
    });

    test('keys the cooldown off the cleaned url, not the raw url', () async {
      const String rawUrlOne = 'https://example.com/product-1?ref=x';
      const String rawUrlTwo = 'https://example.com/product-1?ref=y';
      when(() => urlCleaner.clean(rawUrlOne)).thenReturn(cleanedUrl);
      when(() => urlCleaner.clean(rawUrlTwo)).thenReturn(cleanedUrl);
      final FetchResult dioResult = buildFetchResult(statusCode: 403);
      when(
        () => dioFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => dioResult);
      when(
        () => offerDecoder.decode(any(), sourceUrl: any(named: 'sourceUrl')),
      ).thenReturn(null);
      when(
        () => detector.detect(
          statusCode: dioResult.statusCode,
          responseBody: dioResult.body,
          hasUsablePrice: false,
        ),
      ).thenReturn(PriceFetchStatus.blocked);
      when(
        () => webViewFetcher.fetch(cleanedUrl),
      ).thenAnswer((_) async => dioResult);

      await orchestrator.fetch(rawUrlOne);
      await orchestrator.fetch(rawUrlTwo);

      verify(() => dioFetcher.fetch(cleanedUrl)).called(1);
    });
  });
}
