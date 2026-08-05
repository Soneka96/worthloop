// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/generic_products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockDio extends Mock implements Dio {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockDio dio;
  late MockLoggerService loggerService;
  late GenericProductsRemoteDatasource datasource;
  late ProductSource source;
  final DateTime now = DateTime(2026);

  setUp(() {
    dio = MockDio();
    loggerService = MockLoggerService();
    datasource = GenericProductsRemoteDatasource(
      dio,
      PriceResponseDetector(),
      loggerService,
      now: () => now,
    );
    source = ProductSource.fromUrl(
      id: 'source-1',
      productId: 'product-1',
      url: 'https://example.com/product-1',
      createdAt: DateTime(2026),
    );
    registerFallbackValue(Options());
  });

  group('GenericProductsRemoteDatasource.fetchPrices', () {
    test('extracts a JSON-LD offer with its currency', () async {
      when(
        () => dio.get<String>(source.url, options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: source.url),
          statusCode: 200,
          data: '''
            <script type="application/ld+json">
              {"@type":"Product","offers":{"price":"19.99","priceCurrency":"USD"}}
            </script>
          ''',
        ),
      );

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(result.isRight(), isTrue);
      final List<StorePriceModel> offers = result.getOrElse((_) => []);
      expect(offers.single.storeName, 'example.com');
      expect(offers.single.currentPrice.minorUnits, 1999);
      expect(offers.single.currentPrice.currencyCode, 'USD');
      expect(offers.single.isAvailable, isTrue);
    });

    test('rejects an offer without currency metadata', () async {
      when(
        () => dio.get<String>(source.url, options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: source.url),
          statusCode: 200,
          data: '''
            <script type="application/ld+json">
              {"@type":"Product","offers":{"price":"19.99"}}
            </script>
          ''',
        ),
      );

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(
        result,
        const Left(
          PriceFetchFailure(
            status: PriceFetchStatus.invalidData,
            message: 'Website returned invalid price data',
          ),
        ),
      );
    });

    test(
      'skips malformed offers and parses formatted aggregate prices',
      () async {
        when(
          () => dio.get<String>(source.url, options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<String>(
            requestOptions: RequestOptions(path: source.url),
            statusCode: 200,
            data: '''
            <script type="application/ld+json">
              {"@type":"Product","offers":[
                {"price":"not-a-number","priceCurrency":"EUR"},
                {"@type":"AggregateOffer","lowPrice":"1,234.56","priceCurrency":" EUR "}
              ]}
            </script>
          ''',
          ),
        );

        final Either<Failure, List<StorePriceModel>> result = await datasource
            .fetchPrices(source);
        final List<StorePriceModel> offers = result.getOrElse((_) => []);

        expect(offers.single.currentPrice.minorUnits, 123456);
        expect(offers.single.currentPrice.currencyCode, 'EUR');
      },
    );

    test(
      'returns a network failure when the website blocks the request',
      () async {
        when(
          () => dio.get<String>(source.url, options: any(named: 'options')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: source.url),
            response: Response<String>(
              requestOptions: RequestOptions(path: source.url),
              statusCode: 403,
              data: 'Access denied',
            ),
          ),
        );

        final Either<Failure, List<StorePriceModel>> result = await datasource
            .fetchPrices(source);

        expect(
          result,
          const Left(
            PriceFetchFailure(
              status: PriceFetchStatus.blocked,
              message: 'Website blocked the price request',
            ),
          ),
        );
      },
    );

    test('does not retry a blocked website during its cooldown', () async {
      when(
        () => dio.get<String>(source.url, options: any(named: 'options')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: source.url),
          response: Response<String>(
            requestOptions: RequestOptions(path: source.url),
            statusCode: 403,
            data: 'Access denied',
          ),
        ),
      );

      await datasource.fetchPrices(source);
      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(
        result,
        const Left(
          PriceFetchFailure(
            status: PriceFetchStatus.blocked,
            message: 'Website blocked the price request',
          ),
        ),
      );
      verify(
        () => dio.get<String>(source.url, options: any(named: 'options')),
      ).called(1);
    });

    test(
      'returns a validation failure when no supported price is found',
      () async {
        when(
          () => dio.get<String>(source.url, options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<String>(
            requestOptions: RequestOptions(path: source.url),
            statusCode: 200,
            data: '<html><title>Product</title></html>',
          ),
        );

        final Either<Failure, List<StorePriceModel>> result = await datasource
            .fetchPrices(source);

        expect(
          result,
          const Left(
            PriceFetchFailure(
              status: PriceFetchStatus.unsupported,
              message: 'Website does not expose supported price data',
            ),
          ),
        );
      },
    );
  });
}
