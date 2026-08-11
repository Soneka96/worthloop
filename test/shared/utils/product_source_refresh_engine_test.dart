// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_change.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/product_price_alert_notification_coordinator.dart';
import 'package:worth_loop/shared/utils/product_source_refresh_engine.dart';
import '../../features/products/fixtures/product_model.fixture.dart';
import '../../features/products/fixtures/product_source.fixture.dart';
import '../../features/products/fixtures/product_source_model.fixture.dart';

class MockProductsLocalDatasource extends Mock
    implements ProductsLocalDatasource {}

class MockIProductsRemoteDatasource extends Mock
    implements IProductsRemoteDatasource {}

class MockProductPriceAlertNotificationCoordinator extends Mock
    implements ProductPriceAlertNotificationCoordinator {}

void main() {
  late MockProductsLocalDatasource mockDatasource;
  late MockIProductsRemoteDatasource mockRemoteDatasource;
  late MockProductPriceAlertNotificationCoordinator mockPriceAlertCoordinator;
  late ProductSourceRefreshEngine engine;

  setUpAll(() {
    registerFallbackValue(
      ProductPriceChange(
        product: buildProductModel(),
        previousBestPrice: const Money(minorUnits: 0, currencyCode: 'EUR'),
        currentBestPrice: const Money(minorUnits: 0, currencyCode: 'EUR'),
        direction: PriceChangeDirection.none,
      ),
    );
    registerFallbackValue(buildProductSource());
  });

  setUp(() {
    mockDatasource = MockProductsLocalDatasource();
    mockRemoteDatasource = MockIProductsRemoteDatasource();
    mockPriceAlertCoordinator = MockProductPriceAlertNotificationCoordinator();
    engine = ProductSourceRefreshEngine(
      mockDatasource,
      mockRemoteDatasource,
      mockPriceAlertCoordinator,
    );
    when(
      () => mockDatasource.loadProduct(any()),
    ).thenAnswer((_) async => const Left(DatabaseFailure('not stubbed')));
    when(
      () => mockPriceAlertCoordinator.notify(any()),
    ).thenAnswer((_) async {});
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

        final Either<Failure, Unit> result = await engine.enqueueSourceRefresh([
          'source-1',
        ]);

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

        final Either<Failure, Unit> result = await engine.enqueueSourceRefresh([
          'source-1',
        ]);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(result, const Right(unit));
        verify(() => mockDatasource.loadProductSources()).called(1);
        verifyInOrder([
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.queued,
          ),
          () => mockDatasource.loadProduct(source.productId),
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
        verifyZeroInteractions(mockPriceAlertCoordinator);
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

    test(
      'waitUntilIdle() resolves immediately when nothing is queued or in flight',
      () async {
        await expectLater(engine.waitUntilIdle(), completes);
      },
    );

    test('waitUntilIdle() resolves only after the run drains', () async {
      final ProductSourceModel source = buildProductSourceModel(id: 'source-1');
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

      bool idleResolved = false;
      unawaited(engine.waitUntilIdle().then((_) => idleResolved = true));
      await Future<void>.delayed(Duration.zero);
      expect(idleResolved, false);

      fetchCompleter.complete(Right(source));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(idleResolved, true);
    });

    test(
      'waitUntilIdle() waits for the final onProgress() call to finish before resolving',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final Completer<void> progressNotified = Completer();
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
        engine.onProgress = (int completed, int total) async {
          if (completed == total) {
            await progressNotified.future;
          }
        };

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);

        bool idleResolved = false;
        unawaited(engine.waitUntilIdle().then((_) => idleResolved = true));
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        expect(idleResolved, false);

        progressNotified.complete();
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(idleResolved, true);
      },
    );

    test(
      'does not re-queue a source already handled in the current run when bypassCooldown = false',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        final Completer<Either<Failure, ProductSourceModel>> completerB =
            Completer();
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) async => Right(sourceA));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceB),
        ).thenAnswer((_) => completerB.future);
        when(
          () => mockDatasource.updateSourcePrices(sourceA.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRemoteDatasource.fetchPrices(sourceA)).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(sourceB)).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
        verify(
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.queued,
          ),
        ).called(1);
        expect(progressCalls.map((call) => call.$2), everyElement(2));
      },
    );

    test(
      're-queues a source already handled in the current run when bypassCooldown = true',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        final Completer<Either<Failure, ProductSourceModel>> completerB =
            Completer();
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) async => Right(sourceA));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA, bypassCooldown: true),
        ).thenAnswer((_) async => Right(sourceA));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceB),
        ).thenAnswer((_) => completerB.future);
        when(
          () => mockDatasource.updateSourcePrices(sourceA.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        await engine.enqueueSourceRefresh(['source-1'], bypassCooldown: true);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRemoteDatasource.fetchPrices(sourceA)).called(1);
        verify(
          () => mockRemoteDatasource.fetchPrices(sourceA, bypassCooldown: true),
        ).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(sourceB)).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
        verify(
          () => mockDatasource.writeSourceLiveStatus(
            'source-1',
            SourceRefreshStatus.queued,
          ),
        ).called(2);
        expect(progressCalls.last.$2, 3);
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

    test('notifies a price drop when the best price becomes lower', () async {
      final ProductSourceModel source = buildProductSourceModel(id: 'source-1');
      final ProductSourceModel updatedSource = buildProductSourceModel(
        id: 'source-1',
        currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
        isAvailable: true,
      );
      final ProductModel previousProduct = buildProductModel(
        sources: [
          buildProductSource(
            currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );
      final ProductModel refreshedProduct = buildProductModel(
        sources: [
          buildProductSource(
            currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockDatasource.writeSourceLiveStatus(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockDatasource.loadProduct(source.productId),
      ).thenAnswer((_) async => Right(previousProduct));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(updatedSource));
      when(
        () => mockDatasource.updateSourcePrices(source.productId, [
          updatedSource,
        ]),
      ).thenAnswer((_) async => Right(refreshedProduct));

      await engine.enqueueSourceRefresh(['source-1']);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final ProductPriceChange change =
          verify(
                () => mockPriceAlertCoordinator.notify(captureAny()),
              ).captured.single
              as ProductPriceChange;
      expect(change.direction, isA<PriceChangeDirection>());
      expect(change.direction, PriceChangeDirection.drop);
      expect(change.previousBestPrice.minorUnits, 2999);
      expect(change.currentBestPrice.minorUnits, 1999);
      expect(change.product, refreshedProduct);
    });

    test(
      'notifies a price increase when the best price becomes higher',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel updatedSource = buildProductSourceModel(
          id: 'source-1',
          currentPrice: const Money(minorUnits: 3999, currencyCode: 'EUR'),
          isAvailable: true,
        );
        final ProductModel previousProduct = buildProductModel(
          sources: [
            buildProductSource(
              currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
              isAvailable: true,
            ),
          ],
        );
        final ProductModel refreshedProduct = buildProductModel(
          sources: [
            buildProductSource(
              currentPrice: const Money(minorUnits: 3999, currencyCode: 'EUR'),
              isAvailable: true,
            ),
          ],
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.loadProduct(source.productId),
        ).thenAnswer((_) async => Right(previousProduct));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(updatedSource));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, [
            updatedSource,
          ]),
        ).thenAnswer((_) async => Right(refreshedProduct));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        final ProductPriceChange change =
            verify(
                  () => mockPriceAlertCoordinator.notify(captureAny()),
                ).captured.single
                as ProductPriceChange;
        expect(change.direction, PriceChangeDirection.increase);
        expect(change.previousBestPrice.minorUnits, 2999);
        expect(change.currentBestPrice.minorUnits, 3999);
      },
    );

    test('does not notify when the best price is unchanged', () async {
      final ProductSourceModel source = buildProductSourceModel(id: 'source-1');
      final ProductModel previousProduct = buildProductModel(
        sources: [
          buildProductSource(
            currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );
      final ProductModel refreshedProduct = buildProductModel(
        sources: [
          buildProductSource(
            currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockDatasource.writeSourceLiveStatus(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockDatasource.loadProduct(source.productId),
      ).thenAnswer((_) async => Right(previousProduct));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(source));
      when(
        () => mockDatasource.updateSourcePrices(source.productId, any()),
      ).thenAnswer((_) async => Right(refreshedProduct));

      await engine.enqueueSourceRefresh(['source-1']);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verifyZeroInteractions(mockPriceAlertCoordinator);
    });

    test('does not notify when the currency changed', () async {
      final ProductSourceModel source = buildProductSourceModel(id: 'source-1');
      final ProductModel previousProduct = buildProductModel(
        sources: [
          buildProductSource(
            currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );
      final ProductModel refreshedProduct = buildProductModel(
        sources: [
          buildProductSource(
            currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
            isAvailable: true,
          ),
        ],
      );
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockDatasource.writeSourceLiveStatus(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => mockDatasource.loadProduct(source.productId),
      ).thenAnswer((_) async => Right(previousProduct));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(source));
      when(
        () => mockDatasource.updateSourcePrices(source.productId, any()),
      ).thenAnswer((_) async => Right(refreshedProduct));

      await engine.enqueueSourceRefresh(['source-1']);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verifyZeroInteractions(mockPriceAlertCoordinator);
    });

    test(
      'does not notify when the previous product had no available price',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductModel previousProduct = buildProductModel(sources: []);
        final ProductModel refreshedProduct = buildProductModel(
          sources: [
            buildProductSource(
              currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
              isAvailable: true,
            ),
          ],
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.loadProduct(source.productId),
        ).thenAnswer((_) async => Right(previousProduct));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(refreshedProduct));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verifyZeroInteractions(mockPriceAlertCoordinator);
      },
    );

    test(
      'does not notify when loadProduct() fails to find a previous product',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductModel refreshedProduct = buildProductModel(
          sources: [
            buildProductSource(
              currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
              isAvailable: true,
            ),
          ],
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.loadProduct(source.productId),
        ).thenAnswer((_) async => const Left(DatabaseFailure('not found')));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(refreshedProduct));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verifyZeroInteractions(mockPriceAlertCoordinator);
      },
    );

    test(
      'does not notify when updateSourcePrices() fails to persist the refreshed product',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductModel previousProduct = buildProductModel(
          sources: [
            buildProductSource(
              currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
              isAvailable: true,
            ),
          ],
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.loadProduct(source.productId),
        ).thenAnswer((_) async => Right(previousProduct));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure('database failed')),
        );

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verifyZeroInteractions(mockPriceAlertCoordinator);
      },
    );

    test(
      'calls onProgress with the initial count when sources are newly queued',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://example.com/2',
        );
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(() => mockRemoteDatasource.fetchPrices(any())).thenAnswer(
          (_) => Completer<Either<Failure, ProductSourceModel>>().future,
        );

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);

        expect(progressCalls, [(0, 2)]);
      },
    );

    test('does not call onProgress when no source is newly queued', () async {
      final List<(int, int)> progressCalls = [];
      engine.onProgress = (int completed, int total) async =>
          progressCalls.add((completed, total));
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => const Right([]));

      await engine.enqueueSourceRefresh(['missing-source']);

      expect(progressCalls, isEmpty);
    });

    test(
      'accumulates the total across a second enqueueSourceRefresh() call issued before the first batch drains',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://example.com/2',
        );
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(() => mockRemoteDatasource.fetchPrices(any())).thenAnswer(
          (_) => Completer<Either<Failure, ProductSourceModel>>().future,
        );

        await engine.enqueueSourceRefresh(['source-1']);
        await engine.enqueueSourceRefresh(['source-2']);

        expect(progressCalls, [(0, 1), (0, 2)]);
      },
    );

    test(
      'calls onProgress with an incrementing completed count as each source finishes',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
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

        expect(progressCalls, [(0, 1), (1, 1)]);
      },
    );

    test(
      'resets progress once the queue fully drains, so a later enqueue starts a fresh count',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://example.com/2',
        );
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(any()),
        ).thenAnswer((_) async => Right(sourceA));
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        progressCalls.clear();

        await engine.enqueueSourceRefresh(['source-2']);

        expect(progressCalls, [(0, 1)]);
      },
    );

    test(
      'does not reset progress while another merchant is still in flight',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        final List<(int, int)> progressCalls = [];
        engine.onProgress = (int completed, int total) async =>
            progressCalls.add((completed, total));
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) async => Right(sourceA));
        when(() => mockRemoteDatasource.fetchPrices(sourceB)).thenAnswer(
          (_) => Completer<Either<Failure, ProductSourceModel>>().future,
        );
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(progressCalls.last, (1, 2));
      },
    );

    test(
      'does not clear a finished source\'s live status while another merchant is still in flight',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) async => Right(sourceA));
        when(() => mockRemoteDatasource.fetchPrices(sourceB)).thenAnswer(
          (_) => Completer<Either<Failure, ProductSourceModel>>().future,
        );
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verifyNever(
          () => mockDatasource.writeSourceLiveStatus('source-1', null),
        );
      },
    );

    test(
      'sweep-clears every source\'s live status once the whole run drains',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(() => mockRemoteDatasource.fetchPrices(any())).thenAnswer((
          invocation,
        ) async {
          final ProductSourceModel source =
              invocation.positionalArguments.first as ProductSourceModel;
          return Right(source);
        });
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockDatasource.writeSourceLiveStatus('source-1', null),
        ).called(1);
        verify(
          () => mockDatasource.writeSourceLiveStatus('source-2', null),
        ).called(1);
      },
    );

    test(
      'sweeps every remaining source even when clearing one fails',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.writeSourceLiveStatus('source-1', null),
        ).thenAnswer(
          (_) async => const Left(DatabaseFailure('database failed')),
        );
        when(() => mockRemoteDatasource.fetchPrices(any())).thenAnswer((
          invocation,
        ) async {
          final ProductSourceModel source =
              invocation.positionalArguments.first as ProductSourceModel;
          return Right(source);
        });
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockDatasource.writeSourceLiveStatus('source-2', null),
        ).called(1);
      },
    );

    test(
      'calls onRunComplete(true) when every source in the run fetches successfully',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        bool? reportedSucceeded;
        engine.onRunComplete = (bool succeeded) async {
          reportedSucceeded = succeeded;
        };
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

        expect(reportedSucceeded, isA<bool>());
        expect(reportedSucceeded, isTrue);
      },
    );

    test(
      'calls onRunComplete(false) when at least one source fails to fetch',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        bool? reportedSucceeded;
        engine.onRunComplete = (bool succeeded) async {
          reportedSucceeded = succeeded;
        };
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) async => Right(sourceA));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceB),
        ).thenAnswer((_) async => const Left(NetworkFailure('unreachable')));
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(reportedSucceeded, isFalse);
      },
    );

    test('does not call onRunComplete when nothing was queued', () async {
      bool onRunCompleteCalled = false;
      engine.onRunComplete = (bool succeeded) async {
        onRunCompleteCalled = true;
      };
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => const Right([]));

      await engine.enqueueSourceRefresh(['missing-source']);
      await Future<void>.delayed(Duration.zero);

      expect(onRunCompleteCalled, isFalse);
    });

    test(
      'resets the failure flag so a later run reports succeeded = true after an earlier run had a failure',
      () async {
        final ProductSourceModel source = buildProductSourceModel(
          id: 'source-1',
        );
        final List<bool> reportedOutcomes = [];
        engine.onRunComplete = (bool succeeded) async {
          reportedOutcomes.add(succeeded);
        };
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.updateSourcePrices(source.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => const Left(NetworkFailure('unreachable')));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(source));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(reportedOutcomes, [false, true]);
      },
    );

    test(
      'calls onRunComplete(true) when a failed source succeeds on a bypassCooldown retry within the same still-open run',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        final Completer<Either<Failure, ProductSourceModel>> completerB =
            Completer();
        bool? reportedSucceeded;
        engine.onRunComplete = (bool succeeded) async {
          reportedSucceeded = succeeded;
        };
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.updateSourcePrices(sourceA.productId, any()),
        ).thenAnswer((_) async => Right(buildProductModel()));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) async => const Left(NetworkFailure('unreachable')));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceB),
        ).thenAnswer((_) => completerB.future);

        await engine.enqueueSourceRefresh(['source-1', 'source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        when(
          () => mockRemoteDatasource.fetchPrices(sourceA, bypassCooldown: true),
        ).thenAnswer((_) async => Right(sourceA));

        await engine.enqueueSourceRefresh(['source-1'], bypassCooldown: true);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        completerB.complete(Right(sourceB));
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(reportedSucceeded, isTrue);
      },
    );

    test(
      'merges an overlapping enqueueSourceRefresh() call into the same onRunComplete report',
      () async {
        final ProductSourceModel sourceA = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel sourceB = buildProductSourceModel(
          id: 'source-2',
          url: 'https://merchant-2.example.com/1',
          merchantDomain: 'merchant-2.example.com',
        );
        final Completer<Either<Failure, ProductSourceModel>> completerA =
            Completer();
        final List<bool> reportedOutcomes = [];
        engine.onRunComplete = (bool succeeded) async {
          reportedOutcomes.add(succeeded);
        };
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([sourceA, sourceB]));
        when(
          () => mockDatasource.writeSourceLiveStatus(any(), any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockDatasource.updateSourcePrices(any(), any()),
        ).thenAnswer((_) async => Right(buildProductModel()));
        when(
          () => mockRemoteDatasource.fetchPrices(sourceA),
        ).thenAnswer((_) => completerA.future);
        when(
          () => mockRemoteDatasource.fetchPrices(sourceB),
        ).thenAnswer((_) async => const Left(NetworkFailure('unreachable')));

        await engine.enqueueSourceRefresh(['source-1']);
        await Future<void>.delayed(Duration.zero);
        await engine.enqueueSourceRefresh(['source-2']);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        completerA.complete(Right(sourceA));
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(reportedOutcomes, [false]);
      },
    );
  });
}
