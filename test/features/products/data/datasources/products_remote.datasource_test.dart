// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import 'package:worth_loop/shared/utils/product_price_fetch_orchestrator_service.dart';
import '../../fixtures/store_price_model.fixture.dart';
import '../../../../shared/fixtures/price_fetch_result.fixture.dart';
import '../../../../shared/fixtures/product_offer.fixture.dart';

class MockIProductsRemoteDatasource extends Mock
    implements IProductsRemoteDatasource {}

class MockProductPriceFetchOrchestratorService extends Mock
    implements ProductPriceFetchOrchestratorService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('IProductsRemoteDatasource contract', () {
    test('fetchPrices() returns the remote offers', () async {
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/product-1',
        createdAt: DateTime(2026),
      );
      final List<StorePriceModel> remoteOffers = [
        buildStorePriceModel(isAvailable: false),
      ];
      final IProductsRemoteDatasource datasource =
          MockIProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(remoteOffers));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(result, Right(remoteOffers));
      verify(() => datasource.fetchPrices(source)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('fetchPrices() returns the remote failure', () async {
      const NetworkFailure failure = NetworkFailure('failed');
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/product-1',
        createdAt: DateTime(2026),
      );
      final IProductsRemoteDatasource datasource =
          MockIProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(source),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      expect(result, const Left(failure));
      verify(() => datasource.fetchPrices(source)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('Method fetchPrices() returns the correct value', () {
    late MockProductPriceFetchOrchestratorService orchestrator;
    late MockLoggerService loggerService;
    late ProductsRemoteDatasource datasource;
    late ProductSource source;

    setUp(() {
      orchestrator = MockProductPriceFetchOrchestratorService();
      loggerService = MockLoggerService();
      datasource = ProductsRemoteDatasource(orchestrator, loggerService);
      source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/product-1',
        createdAt: DateTime(2026),
      );
    });

    test('returns the decoded offer as a StorePriceModel on success', () async {
      final ProductOffer offer = buildProductOffer();
      when(
        () => orchestrator.fetch(source.url),
      ).thenAnswer((_) async => buildPriceFetchResult(offer: offer));

      final Either<Failure, List<StorePriceModel>> result = await datasource
          .fetchPrices(source);

      final List<StorePriceModel> offers = result.getOrElse((_) => []);
      expect(offers.single, isA<StorePriceModel>());
      expect(offers.single.storeName, isA<String>());
      expect(offers.single.storeName, source.merchantDomain);
      expect(offers.single.productUrl, isA<String>());
      expect(offers.single.productUrl, source.url);
      expect(offers.single.currentPrice.minorUnits, isA<int>());
      expect(offers.single.currentPrice.minorUnits, offer.minorUnits);
      expect(offers.single.currentPrice.currencyCode, isA<String>());
      expect(offers.single.currentPrice.currencyCode, offer.currencyCode);
      expect(offers.single.isAvailable, isA<bool>());
      expect(offers.single.isAvailable, offer.isAvailable);
      expect(offers.single.lastCheckedAt, isA<DateTime>());
      verify(() => orchestrator.fetch(source.url)).called(1);
      verifyNoMoreInteractions(orchestrator);
      verifyNever(() => loggerService.e(any()));
      verifyNoMoreInteractions(loggerService);
    });

    const Map<PriceFetchStatus, Failure> failuresByStatus = {
      PriceFetchStatus.blocked: PriceFetchFailure(
        status: PriceFetchStatus.blocked,
        message: 'Website blocked the price request',
      ),
      PriceFetchStatus.networkError: PriceFetchFailure(
        status: PriceFetchStatus.networkError,
        message: 'Unable to fetch the product price',
      ),
      PriceFetchStatus.invalidData: PriceFetchFailure(
        status: PriceFetchStatus.invalidData,
        message: 'Website returned invalid price data',
      ),
      PriceFetchStatus.unsupported: PriceFetchFailure(
        status: PriceFetchStatus.unsupported,
        message: 'Website does not expose supported price data',
      ),
      PriceFetchStatus.none: NetworkFailure('Price fetch did not run'),
    };

    for (final MapEntry<PriceFetchStatus, Failure> entry
        in failuresByStatus.entries) {
      test(
        'returns and logs a failure when status = PriceFetchStatus.${entry.key.name}',
        () async {
          when(() => orchestrator.fetch(source.url)).thenAnswer(
            (_) async => buildPriceFetchResult(status: entry.key, offer: null),
          );

          final Either<Failure, List<StorePriceModel>> result = await datasource
              .fetchPrices(source);

          expect(result, Left(entry.value));
          verify(() => loggerService.e(entry.value.message)).called(1);
        },
      );
    }

    test(
      'returns a ValidationFailure when status = success but offer == null',
      () async {
        when(() => orchestrator.fetch(source.url)).thenAnswer(
          (_) async => buildPriceFetchResult(
            status: PriceFetchStatus.success,
            offer: null,
          ),
        );

        final Either<Failure, List<StorePriceModel>> result = await datasource
            .fetchPrices(source);

        expect(
          result,
          const Left(ValidationFailure('Price fetch unexpectedly succeeded')),
        );
        verify(
          () => loggerService.e('Price fetch unexpectedly succeeded'),
        ).called(1);
      },
    );
  });
}
