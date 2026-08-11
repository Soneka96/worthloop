// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import 'package:worth_loop/shared/utils/product_price_fetch_orchestrator_service.dart';
import '../../fixtures/product_source.fixture.dart';
import '../../fixtures/product_source_model.fixture.dart';
import '../../../../shared/fixtures/price_fetch_result.fixture.dart';
import '../../../../shared/fixtures/product_offer.fixture.dart';

class MockIProductsRemoteDatasource extends Mock
    implements IProductsRemoteDatasource {}

class MockProductPriceFetchOrchestratorService extends Mock
    implements ProductPriceFetchOrchestratorService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('IProductsRemoteDatasource contract', () {
    test('fetchPrices() returns the priced source', () async {
      final ProductSource source = buildProductSource();
      final ProductSourceModel pricedSource = buildProductSourceModel();
      final IProductsRemoteDatasource datasource =
          MockIProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(pricedSource));

      final Either<Failure, ProductSourceModel> result = await datasource
          .fetchPrices(source);

      expect(result, Right(pricedSource));
      verify(() => datasource.fetchPrices(source)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('fetchPrices() returns the remote failure', () async {
      const NetworkFailure failure = NetworkFailure('failed');
      final ProductSource source = buildProductSource();
      final IProductsRemoteDatasource datasource =
          MockIProductsRemoteDatasource();
      when(
        () => datasource.fetchPrices(source),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, ProductSourceModel> result = await datasource
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
      source = buildProductSource();
    });

    test(
      'returns the decoded offer applied to the same source on success',
      () async {
        final ProductOffer offer = buildProductOffer();
        when(
          () => orchestrator.fetch(source.url),
        ).thenAnswer((_) async => buildPriceFetchResult(offer: offer));

        final Either<Failure, ProductSourceModel> result = await datasource
            .fetchPrices(source);

        final ProductSourceModel? pricedSource = result.getRight().toNullable();
        expect(pricedSource, isA<ProductSourceModel>());
        expect(pricedSource?.id, isA<String>());
        expect(pricedSource?.id, source.id);
        expect(pricedSource?.productId, isA<String>());
        expect(pricedSource?.productId, source.productId);
        expect(pricedSource?.url, isA<String>());
        expect(pricedSource?.url, source.url);
        expect(pricedSource?.merchantDomain, isA<String>());
        expect(pricedSource?.merchantDomain, source.merchantDomain);
        expect(pricedSource?.createdAt, isA<DateTime>());
        expect(pricedSource?.createdAt, source.createdAt);
        expect(pricedSource?.currentPrice, isA<Money>());
        expect(pricedSource?.currentPrice?.minorUnits, isA<int>());
        expect(pricedSource?.currentPrice?.minorUnits, offer.minorUnits);
        expect(pricedSource?.currentPrice?.currencyCode, isA<String>());
        expect(pricedSource?.currentPrice?.currencyCode, offer.currencyCode);
        expect(pricedSource?.isAvailable, isA<bool>());
        expect(pricedSource?.isAvailable, offer.isAvailable);
        expect(pricedSource?.lastCheckedAt, isA<DateTime>());
        verify(() => orchestrator.fetch(source.url)).called(1);
        verifyNoMoreInteractions(orchestrator);
        verifyNever(() => loggerService.e(any()));
        verifyNoMoreInteractions(loggerService);
      },
    );

    test(
      'forwards an overridden cooldown bypass to the orchestrator',
      () async {
        final ProductOffer offer = buildProductOffer();
        when(
          () => orchestrator.fetch(source.url, bypassCooldown: true),
        ).thenAnswer((_) async => buildPriceFetchResult(offer: offer));

        final Either<Failure, ProductSourceModel> result = await datasource
            .fetchPrices(source, bypassCooldown: true);

        expect(result.isRight(), isTrue);
        verify(
          () => orchestrator.fetch(source.url, bypassCooldown: true),
        ).called(1);
        verifyNoMoreInteractions(orchestrator);
      },
    );

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

          final Either<Failure, ProductSourceModel> result = await datasource
              .fetchPrices(source);

          expect(result, Left(entry.value));
          verify(() => orchestrator.fetch(source.url)).called(1);
          verifyNoMoreInteractions(orchestrator);
          verify(() => loggerService.e(entry.value.message)).called(1);
          verifyNoMoreInteractions(loggerService);
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

        final Either<Failure, ProductSourceModel> result = await datasource
            .fetchPrices(source);

        expect(
          result,
          const Left(ValidationFailure('Price fetch unexpectedly succeeded')),
        );
        verify(() => orchestrator.fetch(source.url)).called(1);
        verifyNoMoreInteractions(orchestrator);
        verify(
          () => loggerService.e('Price fetch unexpectedly succeeded'),
        ).called(1);
        verifyNoMoreInteractions(loggerService);
      },
    );
  });
}
