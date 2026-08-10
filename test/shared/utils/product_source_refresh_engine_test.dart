// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/product_source_refresh_engine.dart';
import '../../features/products/fixtures/product_model.fixture.dart';
import '../../features/products/fixtures/product_source_model.fixture.dart';

class MockProductsLocalDatasource extends Mock
    implements ProductsLocalDatasource {}

class MockIProductsRemoteDatasource extends Mock
    implements IProductsRemoteDatasource {}

void main() {
  late MockProductsLocalDatasource mockDatasource;
  late MockIProductsRemoteDatasource mockRemoteDatasource;
  late ProductSourceRefreshEngine engine;

  setUp(() {
    mockDatasource = MockProductsLocalDatasource();
    mockRemoteDatasource = MockIProductsRemoteDatasource();
    engine = ProductSourceRefreshEngine(mockDatasource, mockRemoteDatasource);
  });

  group('ProductSourceRefreshEngine behaves correctly', () {
    test('returns Right(unit) immediately when sourceIds is empty', () async {
      final Either<Failure, Unit> result = await engine.enqueueSourceRefresh(
        [],
      );

      expect(result, const Right(unit));
      verifyZeroInteractions(mockDatasource);
      verifyZeroInteractions(mockRemoteDatasource);
    });

    test(
      'returns the datasource failure unchanged when loadProductSources() fails',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await engine
            .enqueueSourceRefresh(['source-1']);

        expect(result, const Left(failure));
        verify(() => mockDatasource.loadProductSources()).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('skips a requested id that has no matching source', () async {
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => const Right([]));

      final Either<Failure, Unit> result = await engine.enqueueSourceRefresh([
        'missing-source',
      ]);

      expect(result, const Right(unit));
      verify(() => mockDatasource.loadProductSources()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test(
      'queues a matching source, fetches it, and clears its live status',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel updatedSource = buildProductSourceModel(
          id: 'source-1',
          currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
          isAvailable: true,
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(updatedSource));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, [
            updatedSource,
          ]),
        ).thenAnswer((_) async => Right(buildProductModel()));

        final Either<Failure, Unit> result = await engine
            .enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(result, const Right(unit));
        verify(() => mockDatasource.loadProductSources()).called(1);
        verifyInOrder([
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.queued,
          ),
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.fetching,
          ),
          () => mockRemoteDatasource.fetchPrices(source),
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.success,
          ),
          () => mockDatasource.updateSourcePrices(source.productId, [
            updatedSource,
          ]),
          () => mockDatasource.writeSourceLiveStatus('source-1', null),
        ]);
        verifyNoMoreInteractions(mockDatasource);
        verifyNoMoreInteractions(mockRemoteDatasource);
      },
    );

    test(
      'queues only the matching id when the call mixes matching and missing ids',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'missing-source']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.queued,
          ),
        ).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(source)).called(1);
      },
    );

    test(
      'forwards bypassCooldown = true to every source in the call',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source, bypassCooldown: true),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1'], bypassCooldown: true);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockRemoteDatasource.fetchPrices(source, bypassCooldown: true),
        ).called(1);
        verifyNever(() => mockRemoteDatasource.fetchPrices(source));
      },
    );

    test('defaults bypassCooldown to false when omitted', () async {
      final ProductSourceModel source = buildProductSourceModel(id: 'source-1');
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockDatasource.writeSourceLiveStatus(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(source));
      when(
        () => mockDatasource.updateSourcePrices(source.productId, any()),
      ).thenAnswer((_) async => Right(buildProductModel()));

      await engine.enqueueSourceRefresh(['source-1']);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockRemoteDatasource.fetchPrices(source)).called(1);
      verifyNever(
        () => mockRemoteDatasource.fetchPrices(source, bypassCooldown: true),
      );
    });

    test('persists a failed fetch and still clears the live status', () async {
      final ProductSourceModel source = buildProductSourceModel(id: 'source-1');
      const NetworkFailure failure = NetworkFailure('unreachable');
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockDatasource.writeSourceLiveStatus(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => const Left(failure));
      when(
        () => mockDatasource.updateSourcePrices(source.productId, any()),
      ).thenAnswer((_) async => Right(buildProductModel()));

      await engine.enqueueSourceRefresh(['source-1']);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final List<ProductSourceModel> persisted =
          verify(
                () => mockDatasource.updateSourcePrices(
                  source.productId,
                  captureAny(),
                ),
              ).captured.single
              as List<ProductSourceModel>;
      expect(persisted.single.lastRefreshStatus, isA<PriceFetchStatus>());
      expect(persisted.single.lastRefreshStatus, PriceFetchStatus.networkError);
      verify(
        () => mockDatasource.writeSourceLiveStatus('source-1', null),
      ).called(1);
    });

    test(
      'persists the failure status from a PriceFetchFailure unchanged',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        const PriceFetchFailure failure = PriceFetchFailure(
          status: PriceFetchStatus.blocked,
          message: 'Website blocked the price request',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => const Left(failure));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        final List<ProductSourceModel> persisted =
            verify(
                  () => mockDatasource.updateSourcePrices(
                    source.productId,
                    captureAny(),
                  ),
                ).captured.single
                as List<ProductSourceModel>;
        expect(persisted.single.lastRefreshStatus, isA<PriceFetchStatus>());
        expect(persisted.single.lastRefreshStatus, PriceFetchStatus.blocked);
      },
    );

    test(
      'writes SourceRefreshStatus.unavailable when a fetch succeeds with isAvailable = false',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel updatedSource = buildProductSourceModel(
          id: 'source-1',
          isAvailable: false,
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(updatedSource));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.unavailable,
          ),
        ).called(1);
      },
    );

    test(
      'still clears the live status when updateSourcePrices() fails',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => const Left(failure));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockDatasource.writeSourceLiveStatus('source-1', null),
        ).called(1);
      },
    );

    test(
      'does not re-queue a source that is already queued or in flight',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final Completer<Either<Failure, ProductSourceModel>> fetchCompleter =
            Completer();
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) => fetchCompleter.future);
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        fetchCompleter.complete(Right(source));
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockDatasource.loadProductSources()).called(2);
        verify(
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.queued,
          ),
        ).called(1);
      },
    );

    test('serializes two sources from the same merchant', () async {
      final ProductSourceModel sourceA = buildProductSourceModel(
        id: 'source-1',
      );
      final ProductSourceModel sourceB = buildProductSourceModel(
        id: 'source-2',
        url: 'https://example.com/2',
      );
      final Completer<Either<Failure, ProductSourceModel>> completerA =
          Completer();
      final Completer<Either<Failure, ProductSourceModel>> completerB =
          Completer();
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([sourceA, sourceB]));
      when(
        () => mockDatasource.writeSourceLiveStatus(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockRemoteDatasource.fetchPrices(sourceA),
      ).thenAnswer((_) => completerA.future);
      when(
        () => mockRemoteDatasource.fetchPrices(sourceB),
      ).thenAnswer((_) => completerB.future);
      when(
        () => mockDatasource.updateSourcePrices(sourceA.productId, any()),
      ).thenAnswer((_) async => Right(buildProductModel()));

      await engine.enqueueSourceRefresh(['source-1', 'source-2']);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockRemoteDatasource.fetchPrices(sourceA)).called(1);
      verifyNever(() => mockRemoteDatasource.fetchPrices(sourceB));

      completerA.complete(Right(sourceA));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockRemoteDatasource.fetchPrices(sourceB)).called(1);
    });

    test(
      'processes at most 4 merchants concurrently, queuing the rest',
      () async {
        final List<ProductSourceModel> sources = List.generate(
          5,
          (int index) => buildProductSourceModel(
            id: 'source-$index',
            url: 'https://merchant-$index.example.com/1',
            merchantDomain: 'merchant-$index.example.com',
          ),
        );
        final List<Completer<Either<Failure, ProductSourceModel>>>
        fetchCompleters = List.generate(5, (_) => Completer());
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right(sources));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        for (final (int index, ProductSourceModel source) in sources.indexed) {
          when(
            () => mockRemoteDatasource.fetchPrices(source),
          ).thenAnswer((_) => fetchCompleters[index].future);
        }

        await engine.enqueueSourceRefresh(
          sources.map((ProductSourceModel source) => source.id).toList(),
        );
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRemoteDatasource.fetchPrices(sources[0])).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(sources[1])).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(sources[2])).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(sources[3])).called(1);
        verifyNever(() => mockRemoteDatasource.fetchPrices(sources[4]));
      },
    );

    test(
      "can re-claim a merchant's queue after it previously drained",
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRemoteDatasource.fetchPrices(source)).called(2);
      },
    );
  });
}
