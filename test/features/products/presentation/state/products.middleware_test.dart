// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/watch_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.middleware.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/url_launcher_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockLoadProductsUseCase extends Mock implements LoadProductsUseCase {}

class MockWatchProductsUseCase extends Mock implements WatchProductsUseCase {}

class MockCreateProductUseCase extends Mock implements CreateProductUseCase {}

class MockAndroidBackgroundRefreshService extends Mock
    implements AndroidBackgroundRefreshService {}

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

class MockAddSourceUseCase extends Mock implements AddSourceUseCase {}

class MockEditSourceUseCase extends Mock implements EditSourceUseCase {}

class MockDeleteSourceUseCase extends Mock implements DeleteSourceUseCase {}

class MockRenameProductUseCase extends Mock implements RenameProductUseCase {}

class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

class MockLoggerService extends Mock implements LoggerService {}

class MockNavigatorService extends Mock implements NavigatorService {}

class MockUrlLauncherService extends Mock implements UrlLauncherService {}

class FakeCreateProductParams extends Fake implements CreateProductParams {}

class FakeAddSourceParams extends Fake implements AddSourceParams {}

class FakeEditSourceParams extends Fake implements EditSourceParams {}

class FakeDeleteSourceParams extends Fake implements DeleteSourceParams {}

class FakeRenameProductParams extends Fake implements RenameProductParams {}

class FakeDeleteProductParams extends Fake implements DeleteProductParams {}

void main() {
  late ProductsMiddleware middleware;
  late MockStore store;
  late MockLoadProductsUseCase mockLoadProductsUseCase;
  late MockWatchProductsUseCase mockWatchProductsUseCase;
  late MockCreateProductUseCase mockCreateProductUseCase;
  late MockAndroidBackgroundRefreshService mockBackgroundRefreshService;
  late MockAppPreferencesStore mockPreferencesStore;
  late MockAddSourceUseCase mockAddSourceUseCase;
  late MockEditSourceUseCase mockEditSourceUseCase;
  late MockDeleteSourceUseCase mockDeleteSourceUseCase;
  late MockRenameProductUseCase mockRenameProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;
  late MockLoggerService mockLoggerService;
  late MockNavigatorService mockNavigatorService;
  late MockUrlLauncherService mockUrlLauncherService;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(FakeCreateProductParams());
    registerFallbackValue(FakeAddSourceParams());
    registerFallbackValue(FakeEditSourceParams());
    registerFallbackValue(FakeDeleteSourceParams());
    registerFallbackValue(FakeRenameProductParams());
    registerFallbackValue(FakeDeleteProductParams());
  });

  setUp(() {
    middleware = ProductsMiddleware();
    store = MockStore();
    mockLoadProductsUseCase = MockLoadProductsUseCase();
    mockWatchProductsUseCase = MockWatchProductsUseCase();
    mockCreateProductUseCase = MockCreateProductUseCase();
    mockBackgroundRefreshService = MockAndroidBackgroundRefreshService();
    mockPreferencesStore = MockAppPreferencesStore();
    mockAddSourceUseCase = MockAddSourceUseCase();
    mockEditSourceUseCase = MockEditSourceUseCase();
    mockDeleteSourceUseCase = MockDeleteSourceUseCase();
    mockRenameProductUseCase = MockRenameProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();
    mockLoggerService = MockLoggerService();
    mockNavigatorService = MockNavigatorService();
    mockUrlLauncherService = MockUrlLauncherService();
    actionLog = [];

    when(() => store.state).thenReturn(AppState.initial());

    when(() => store.dispatch(any())).thenAnswer(
      (Invocation invocation) =>
          actionLog.add(invocation.positionalArguments[0]),
    );
    sl.registerSingleton<LoadProductsUseCase>(mockLoadProductsUseCase);
    sl.registerSingleton<WatchProductsUseCase>(mockWatchProductsUseCase);
    sl.registerSingleton<CreateProductUseCase>(mockCreateProductUseCase);
    sl.registerSingleton<AndroidBackgroundRefreshService>(
      mockBackgroundRefreshService,
    );
    sl.registerSingleton<AppPreferencesStore>(mockPreferencesStore);
    sl.registerSingleton<AddSourceUseCase>(mockAddSourceUseCase);
    sl.registerSingleton<EditSourceUseCase>(mockEditSourceUseCase);
    sl.registerSingleton<DeleteSourceUseCase>(mockDeleteSourceUseCase);
    sl.registerSingleton<RenameProductUseCase>(mockRenameProductUseCase);
    sl.registerSingleton<DeleteProductUseCase>(mockDeleteProductUseCase);
    sl.registerSingleton<LoggerService>(mockLoggerService);
    sl.registerSingleton<NavigatorService>(mockNavigatorService);
    sl.registerSingleton<UrlLauncherService>(mockUrlLauncherService);
    when(
      () => mockWatchProductsUseCase(any()),
    ).thenAnswer((_) => const Stream<List<Product>>.empty());
  });

  tearDown(() async {
    await sl.reset();
    reset(mockLoggerService);
    reset(mockNavigatorService);
    reset(mockUrlLauncherService);
  });

  group('ProductsMiddleware processes LoadProductsAction', () {
    test(
      'LoadProductsAction dispatches ProductsLoadedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => Right([product]));

        middleware.call(store, const LoadProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<LoadProductsAction>());
        expect(actionLog[1], isA<ProductsLoadedAction>());
        expect((actionLog[1] as ProductsLoadedAction).products, [product]);
        final List<dynamic> captured = verify(
          () => mockLoadProductsUseCase(captureAny()),
        ).captured;
        expect(captured.single, isA<NoParams>());
        verifyNoMoreInteractions(mockLoadProductsUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'LoadProductsAction dispatches ProductsLoadFailedAction when failed',
      () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const LoadProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], isA<ProductsLoadFailedAction>());
        expect(
          (actionLog[1] as ProductsLoadFailedAction).message,
          isA<String>(),
        );
        expect((actionLog[1] as ProductsLoadFailedAction).message, 'failed');
        final List<dynamic> captured = verify(
          () => mockLoadProductsUseCase(captureAny()),
        ).captured;
        expect(captured.single, isA<NoParams>());
        verifyNoMoreInteractions(mockLoadProductsUseCase);
        verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test(
      'LoadProductsAction starts the product subscription only once',
      () async {
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, const LoadProductsAction(), next);
        middleware.call(store, const LoadProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockWatchProductsUseCase(any())).called(1);
        verify(() => mockLoadProductsUseCase(any())).called(2);
      },
    );

    test('LoadProductsAction dispatches streamed database updates', () async {
      final Product product = buildProduct(name: 'Streamed Product');
      final Product updatedProduct = buildProduct(name: 'Updated Stream');
      when(() => mockWatchProductsUseCase(any())).thenAnswer(
        (_) => Stream.fromIterable([
          [product],
          [updatedProduct],
        ]),
      );
      when(
        () => mockLoadProductsUseCase(any()),
      ).thenAnswer((_) async => const Right([]));

      middleware.call(store, const LoadProductsAction(), next);
      await Future<void>.delayed(Duration.zero);

      final List<ProductsUpdatedFromDatabaseAction> streamedActions = actionLog
          .whereType<ProductsUpdatedFromDatabaseAction>()
          .where(
            (ProductsUpdatedFromDatabaseAction action) =>
                action.products.isNotEmpty,
          )
          .toList();
      expect(streamedActions, hasLength(2));
      expect(streamedActions[0].products, [product]);
      expect(streamedActions[1].products, [updatedProduct]);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'LoadProductsAction dispatches an empty database stream emission',
      () async {
        when(
          () => mockWatchProductsUseCase(any()),
        ).thenAnswer((_) => Stream.value(const <Product>[]));
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, const LoadProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(
          actionLog.whereType<ProductsUpdatedFromDatabaseAction>(),
          hasLength(1),
        );
        expect(
          actionLog
              .whereType<ProductsUpdatedFromDatabaseAction>()
              .single
              .products,
          isEmpty,
        );
      },
    );

    test(
      'LoadProductsAction logs a stream error without dispatching a failure',
      () async {
        when(
          () => mockWatchProductsUseCase(any()),
        ).thenAnswer((_) => Stream<List<Product>>.error('watch failed'));
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));

        middleware.call(store, const LoadProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockLoggerService.e('watch failed')).called(1);
        expect(actionLog.whereType<ProductsLoadFailedAction>(), isEmpty);
      },
    );
  });

  group('ProductsMiddleware ignores unrelated actions', () {
    test('does not start the product subscription', () async {
      middleware.call(store, const GoBackFromProductDetailsAction(), next);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => mockWatchProductsUseCase(any()));
      verify(() => mockNavigatorService.pop()).called(1);
    });
  });

  group('ProductsMiddleware processes CreateProductAction', () {
    test(
      'CreateProductAction dispatches ProductCreatedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockCreateProductUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(
          store,
          const CreateProductAction(name: 'Example Product'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<CreateProductAction>());
        expect(actionLog[1], isA<ProductCreatedAction>());
        expect((actionLog[1] as ProductCreatedAction).product, product);
        verify(
          () => mockCreateProductUseCase(
            const CreateProductParams(name: 'Example Product'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockCreateProductUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'CreateProductAction dispatches failure when creation fails',
      () async {
        const ValidationFailure failure = ValidationFailure('invalid');
        when(
          () => mockCreateProductUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          store,
          const CreateProductAction(name: 'Example Product'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], const ProductCreationFailedAction('invalid'));
        verify(() => mockCreateProductUseCase(any())).called(1);
        verify(() => mockLoggerService.e('invalid', showPopup: true)).called(1);
        verifyNoMoreInteractions(mockCreateProductUseCase);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('ProductsMiddleware processes RefreshProductAction', () {
    test(
      "enqueues the matching product's source ids on the background service",
      () async {
        final Product product = buildProduct(
          sources: [
            buildProductSource(id: 'source-1'),
            buildProductSource(id: 'source-2', url: 'https://example.com/2'),
          ],
        );
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
            'source-2',
          ]),
        ).thenAnswer((_) async => true);

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [isA<RefreshProductAction>()]);
        verify(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
            'source-2',
          ]),
        ).called(1);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'does not call the background service when the product has no sources',
      () async {
        final Product product = buildProduct();
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        verifyZeroInteractions(mockBackgroundRefreshService);
      },
    );

    test(
      'does not call the background service when no product matches productId',
      () async {
        middleware.call(
          store,
          const RefreshProductAction('missing-product'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        verifyZeroInteractions(mockBackgroundRefreshService);
      },
    );

    test(
      'shows a failure popup when the background service rejects the request',
      () async {
        final Product product = buildProduct(
          sources: [buildProductSource(id: 'source-1')],
        );
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockBackgroundRefreshService.enqueueSources(['source-1']),
        ).thenAnswer((_) async => false);

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const RefreshProductAction('product-1')]);
        verify(
          () => mockLoggerService.e(t.common.refreshFailed, showPopup: true),
        ).called(1);
      },
    );

    test("selects the matching product's sources among several", () async {
      final Product otherProduct = buildProduct(
        id: 'product-1',
        sources: [buildProductSource(id: 'other-source')],
      );
      final Product targetProduct = buildProduct(
        id: 'product-2',
        sources: [
          buildProductSource(
            id: 'target-source',
            productId: 'product-2',
            url: 'https://example.com/target',
          ),
        ],
      );
      when(() => store.state).thenReturn(
        AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(
            products: [otherProduct, targetProduct],
          ),
        ),
      );
      when(
        () => mockBackgroundRefreshService.enqueueSources(['target-source']),
      ).thenAnswer((_) async => true);

      middleware.call(store, const RefreshProductAction('product-2'), next);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockBackgroundRefreshService.enqueueSources(['target-source']),
      ).called(1);
      verifyNever(
        () => mockBackgroundRefreshService.enqueueSources(['other-source']),
      );
    });
  });

  group('ProductsMiddleware processes RefreshSourceAction', () {
    test(
      'enqueues the source on the background service, bypassing its cooldown',
      () async {
        when(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
          ], bypassCooldown: true),
        ).thenAnswer((_) async => true);

        middleware.call(store, const RefreshSourceAction('source-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const RefreshSourceAction('source-1')]);
        verify(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
          ], bypassCooldown: true),
        ).called(1);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'shows a failure popup when the background service rejects the request',
      () async {
        when(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
          ], bypassCooldown: true),
        ).thenAnswer((_) async => false);

        middleware.call(store, const RefreshSourceAction('source-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const RefreshSourceAction('source-1')]);
        verify(
          () => mockLoggerService.e(t.common.refreshFailed, showPopup: true),
        ).called(1);
      },
    );
  });

  test('reconciles persisted background results and clears progress', () async {
    final Product product = buildProduct();
    when(
      () => mockPreferencesStore.consumeBackgroundRefreshCompletion(),
    ).thenAnswer((_) async => true);
    when(
      () => mockLoadProductsUseCase(any()),
    ).thenAnswer((_) async => Right([product]));

    middleware.call(store, const ReconcileBackgroundRefreshAction(), next);
    await Future<void>.delayed(Duration.zero);

    expect(actionLog.first, const ReconcileBackgroundRefreshAction());
    expect(actionLog.whereType<ProductsLoadedAction>().single.products, [
      product,
    ]);
    expect(actionLog.last, const SourceRefreshFinishedAction());
  });

  group('ProductsMiddleware processes RefreshAllProductsAction', () {
    test(
      'enqueues every tracked source id on the background service',
      () async {
        final Product product = buildProduct(
          sources: [
            buildProductSource(id: 'source-1'),
            buildProductSource(id: 'source-2', url: 'https://example.com/2'),
          ],
        );
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
            'source-2',
          ]),
        ).thenAnswer((_) async => true);

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [isA<RefreshAllProductsAction>()]);
        verify(
          () => mockBackgroundRefreshService.enqueueSources([
            'source-1',
            'source-2',
          ]),
        ).called(1);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'shows a failure popup when the background service rejects the request',
      () async {
        final Product product = buildProduct(
          sources: [buildProductSource(id: 'source-1')],
        );
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockBackgroundRefreshService.enqueueSources(['source-1']),
        ).thenAnswer((_) async => false);

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const RefreshAllProductsAction()]);
        verify(
          () => mockLoggerService.e(t.common.refreshFailed, showPopup: true),
        ).called(1);
      },
    );

    test(
      'does not call the background service when there are no product sources',
      () async {
        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [const RefreshAllProductsAction()]);
        verifyZeroInteractions(mockBackgroundRefreshService);
      },
    );

    test('flattens source ids across every tracked product', () async {
      final Product first = buildProduct(
        id: 'product-1',
        sources: [buildProductSource(id: 'source-1')],
      );
      final Product second = buildProduct(
        id: 'product-2',
        sources: [
          buildProductSource(
            id: 'source-2',
            productId: 'product-2',
            url: 'https://example.com/2',
          ),
        ],
      );
      when(() => store.state).thenReturn(
        AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(products: [first, second]),
        ),
      );
      when(
        () => mockBackgroundRefreshService.enqueueSources([
          'source-1',
          'source-2',
        ]),
      ).thenAnswer((_) async => true);

      middleware.call(store, const RefreshAllProductsAction(), next);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockBackgroundRefreshService.enqueueSources([
          'source-1',
          'source-2',
        ]),
      ).called(1);
    });
  });

  group('ProductsMiddleware processes GoToProductDetailsAction', () {
    test('GoToProductDetailsAction calls push with the product path', () async {
      middleware.call(store, const GoToProductDetailsAction('product-1'), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog, [const GoToProductDetailsAction('product-1')]);
      verify(
        () => mockNavigatorService.push(
          AppRoutes.productDetailsPath('product-1'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockNavigatorService);
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('ProductsMiddleware processes GoBackFromProductDetailsAction', () {
    test('GoBackFromProductDetailsAction calls pop', () async {
      middleware.call(store, const GoBackFromProductDetailsAction(), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog, [const GoBackFromProductDetailsAction()]);
      verify(mockNavigatorService.pop).called(1);
      verifyNoMoreInteractions(mockNavigatorService);
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('ProductsMiddleware processes AddSourceAction', () {
    test(
      'AddSourceAction dispatches SourceAddedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockAddSourceUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(
          store,
          const AddSourceAction(
            productId: 'product-1',
            url: 'https://example.com/products/1',
          ),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<AddSourceAction>());
        expect(actionLog[1], isA<SourceAddedAction>());
        expect((actionLog[1] as SourceAddedAction).product, product);
        verify(
          () => mockAddSourceUseCase(
            const AddSourceParams(
              productId: 'product-1',
              url: 'https://example.com/products/1',
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAddSourceUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'AddSourceAction dispatches SourceAddFailedAction when failed',
      () async {
        const ValidationFailure failure = ValidationFailure('invalid url');
        when(
          () => mockAddSourceUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          store,
          const AddSourceAction(productId: 'product-1', url: 'not-a-url'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], isA<SourceAddFailedAction>());
        expect((actionLog[1] as SourceAddFailedAction).message, isA<String>());
        expect((actionLog[1] as SourceAddFailedAction).message, 'invalid url');
        verify(
          () => mockAddSourceUseCase(
            const AddSourceParams(productId: 'product-1', url: 'not-a-url'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAddSourceUseCase);
        verify(
          () => mockLoggerService.e('invalid url', showPopup: true),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('ProductsMiddleware processes EditSourceAction', () {
    test(
      'EditSourceAction dispatches SourceEditedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockEditSourceUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(
          store,
          const EditSourceAction(
            sourceId: 'source-1',
            url: 'https://example.com/updated',
          ),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<EditSourceAction>());
        expect(actionLog[1], isA<SourceEditedAction>());
        expect((actionLog[1] as SourceEditedAction).product, product);
        verify(
          () => mockEditSourceUseCase(
            const EditSourceParams(
              sourceId: 'source-1',
              url: 'https://example.com/updated',
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockEditSourceUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'EditSourceAction dispatches SourceEditFailedAction when failed',
      () async {
        const ValidationFailure failure = ValidationFailure('invalid url');
        when(
          () => mockEditSourceUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          store,
          const EditSourceAction(sourceId: 'source-1', url: 'not-a-url'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], isA<SourceEditFailedAction>());
        expect((actionLog[1] as SourceEditFailedAction).message, isA<String>());
        expect((actionLog[1] as SourceEditFailedAction).message, 'invalid url');
        verify(
          () => mockEditSourceUseCase(
            const EditSourceParams(sourceId: 'source-1', url: 'not-a-url'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockEditSourceUseCase);
        verify(
          () => mockLoggerService.e('invalid url', showPopup: true),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('ProductsMiddleware processes DeleteSourceAction', () {
    test(
      'DeleteSourceAction dispatches SourceDeletedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockDeleteSourceUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(
          store,
          const DeleteSourceAction(
            productId: 'product-1',
            sourceId: 'source-1',
          ),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<DeleteSourceAction>());
        expect(
          actionLog[1],
          SourceDeletedAction(sourceId: 'source-1', product: product),
        );
        verify(
          () => mockDeleteSourceUseCase(
            const DeleteSourceParams(sourceId: 'source-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDeleteSourceUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'DeleteSourceAction dispatches SourceDeleteFailedAction when failed',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Source not found');
        when(
          () => mockDeleteSourceUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          store,
          const DeleteSourceAction(
            productId: 'product-1',
            sourceId: 'source-1',
          ),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(
          actionLog[1],
          const SourceDeleteFailedAction(
            sourceId: 'source-1',
            message: 'Source not found',
          ),
        );
        verify(
          () => mockDeleteSourceUseCase(
            const DeleteSourceParams(sourceId: 'source-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDeleteSourceUseCase);
        verify(
          () => mockLoggerService.e('Source not found', showPopup: true),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('ProductsMiddleware processes OpenOfferUrlAction', () {
    test(
      'OpenOfferUrlAction opens the URL and logs nothing when successful',
      () async {
        when(
          () => mockUrlLauncherService.open('https://example.com/products/1'),
        ).thenAnswer((_) async => true);

        middleware.call(
          store,
          const OpenOfferUrlAction('https://example.com/products/1'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog, [
          const OpenOfferUrlAction('https://example.com/products/1'),
        ]);
        verify(
          () => mockUrlLauncherService.open('https://example.com/products/1'),
        ).called(1);
        verifyNoMoreInteractions(mockUrlLauncherService);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('OpenOfferUrlAction logs a popup when it fails to open', () async {
      when(
        () => mockUrlLauncherService.open('https://example.com/products/1'),
      ).thenAnswer((_) async => false);

      middleware.call(
        store,
        const OpenOfferUrlAction('https://example.com/products/1'),
        next,
      );
      await Future<void>.delayed(Duration.zero);

      expect(actionLog, [
        const OpenOfferUrlAction('https://example.com/products/1'),
      ], reason: 'the failure is only logged, no action is dispatched');
      verify(
        () => mockUrlLauncherService.open('https://example.com/products/1'),
      ).called(1);
      verify(
        () => mockLoggerService.e(
          t.productDetails.openOfferFailed,
          showPopup: true,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockLoggerService);
    });
  });

  group('ProductsMiddleware processes RenameProductAction', () {
    test(
      'RenameProductAction dispatches ProductRenamedAction when successful',
      () async {
        final Product product = buildProduct(name: 'Renamed Product');
        when(
          () => mockRenameProductUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(
          store,
          const RenameProductAction(
            productId: 'product-1',
            name: 'Renamed Product',
          ),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<RenameProductAction>());
        expect(actionLog[1], isA<ProductRenamedAction>());
        expect((actionLog[1] as ProductRenamedAction).product, product);
        verify(
          () => mockRenameProductUseCase(
            const RenameProductParams(
              productId: 'product-1',
              name: 'Renamed Product',
            ),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRenameProductUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'RenameProductAction dispatches ProductRenameFailedAction when failed',
      () async {
        const ValidationFailure failure = ValidationFailure(
          'Product name is required',
        );
        when(
          () => mockRenameProductUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          store,
          const RenameProductAction(productId: 'product-1', name: '  '),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], isA<ProductRenameFailedAction>());
        expect(
          (actionLog[1] as ProductRenameFailedAction).message,
          isA<String>(),
        );
        expect(
          (actionLog[1] as ProductRenameFailedAction).message,
          'Product name is required',
        );
        verify(
          () => mockRenameProductUseCase(
            const RenameProductParams(productId: 'product-1', name: '  '),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRenameProductUseCase);
        verify(
          () =>
              mockLoggerService.e('Product name is required', showPopup: true),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('ProductsMiddleware processes DeleteProductAction', () {
    test(
      'DeleteProductAction dispatches ProductDeletedAction and pops when successful',
      () async {
        when(
          () => mockDeleteProductUseCase(any()),
        ).thenAnswer((_) async => const Right(unit));

        middleware.call(store, const DeleteProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<DeleteProductAction>());
        expect(actionLog[1], const ProductDeletedAction('product-1'));
        verify(
          () => mockDeleteProductUseCase(
            const DeleteProductParams(productId: 'product-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDeleteProductUseCase);
        verify(mockNavigatorService.pop).called(1);
        verifyNoMoreInteractions(mockNavigatorService);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'DeleteProductAction dispatches ProductDeleteFailedAction and does not pop when failed',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Product not found');
        when(
          () => mockDeleteProductUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const DeleteProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(
          actionLog[1],
          const ProductDeleteFailedAction(
            productId: 'product-1',
            message: 'Product not found',
          ),
        );
        verify(
          () => mockDeleteProductUseCase(
            const DeleteProductParams(productId: 'product-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDeleteProductUseCase);
        verifyNever(mockNavigatorService.pop);
        verifyNoMoreInteractions(mockNavigatorService);
        verify(
          () => mockLoggerService.e('Product not found', showPopup: true),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });
}
