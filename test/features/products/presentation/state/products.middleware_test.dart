// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.middleware.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/url_launcher_service.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockLoadProductsUseCase extends Mock implements LoadProductsUseCase {}

class MockCreateProductUseCase extends Mock implements CreateProductUseCase {}

class MockRefreshProductUseCase extends Mock implements RefreshProductUseCase {}

class MockRefreshSourceUseCase extends Mock implements RefreshSourceUseCase {}

class MockRefreshAllProductsUseCase extends Mock
    implements RefreshAllProductsUseCase {}

class MockAddSourceUseCase extends Mock implements AddSourceUseCase {}

class MockEditSourceUseCase extends Mock implements EditSourceUseCase {}

class MockDeleteSourceUseCase extends Mock implements DeleteSourceUseCase {}

class MockRenameProductUseCase extends Mock implements RenameProductUseCase {}

class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

class MockLoggerService extends Mock implements LoggerService {}

class MockNavigatorService extends Mock implements NavigatorService {}

class MockUrlLauncherService extends Mock implements UrlLauncherService {}

class FakeRefreshProductParams extends Fake implements RefreshProductParams {}

class FakeRefreshSourceParams extends Fake implements RefreshSourceParams {}

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
  late MockCreateProductUseCase mockCreateProductUseCase;
  late MockRefreshProductUseCase mockRefreshProductUseCase;
  late MockRefreshSourceUseCase mockRefreshSourceUseCase;
  late MockRefreshAllProductsUseCase mockRefreshAllProductsUseCase;
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
    registerFallbackValue(FakeRefreshProductParams());
    registerFallbackValue(FakeRefreshSourceParams());
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
    mockCreateProductUseCase = MockCreateProductUseCase();
    mockRefreshProductUseCase = MockRefreshProductUseCase();
    mockRefreshSourceUseCase = MockRefreshSourceUseCase();
    mockRefreshAllProductsUseCase = MockRefreshAllProductsUseCase();
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
    sl.registerSingleton<CreateProductUseCase>(mockCreateProductUseCase);
    sl.registerSingleton<RefreshProductUseCase>(mockRefreshProductUseCase);
    sl.registerSingleton<RefreshSourceUseCase>(mockRefreshSourceUseCase);
    sl.registerSingleton<RefreshAllProductsUseCase>(
      mockRefreshAllProductsUseCase,
    );
    sl.registerSingleton<AddSourceUseCase>(mockAddSourceUseCase);
    sl.registerSingleton<EditSourceUseCase>(mockEditSourceUseCase);
    sl.registerSingleton<DeleteSourceUseCase>(mockDeleteSourceUseCase);
    sl.registerSingleton<RenameProductUseCase>(mockRenameProductUseCase);
    sl.registerSingleton<DeleteProductUseCase>(mockDeleteProductUseCase);
    sl.registerSingleton<LoggerService>(mockLoggerService);
    sl.registerSingleton<NavigatorService>(mockNavigatorService);
    sl.registerSingleton<UrlLauncherService>(mockUrlLauncherService);
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
      'RefreshProductAction shows completion feedback after all sources check',
      () async {
        final Product product = buildProduct(sources: [buildProductSource()]);
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(() => mockRefreshProductUseCase(any())).thenAnswer((
          invocation,
        ) async {
          final RefreshProductParams params =
              invocation.positionalArguments.single as RefreshProductParams;
          params.onSourceStatusChanged?.call(
            'source-1',
            SourceRefreshStatus.fetching,
          );
          params.onSourceStatusChanged?.call(
            'source-1',
            SourceRefreshStatus.success,
          );
          return Right(product);
        });

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockLoggerService.i(
            t.productDetails.refreshComplete(total: 1),
            showPopup: true,
          ),
        ).called(1);
      },
    );

    test(
      'RefreshProductAction counts unavailable sources as checked',
      () async {
        final Product product = buildProduct(
          sources: [
            buildProductSource(id: 'source-1'),
            buildProductSource(id: 'source-2'),
          ],
        );
        final Product refreshedProduct = buildProduct(
          lastUpdatedAt: DateTime(2026, 2, 1),
          sources: product.sources,
        );
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(() => mockRefreshProductUseCase(any())).thenAnswer((
          invocation,
        ) async {
          final RefreshProductParams params =
              invocation.positionalArguments.single as RefreshProductParams;
          params.onSourceStatusChanged?.call(
            'source-1',
            SourceRefreshStatus.unavailable,
          );
          params.onSourceStatusChanged?.call(
            'source-2',
            SourceRefreshStatus.error,
          );
          return const Left(DatabaseFailure('partial'));
        });
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => Right([refreshedProduct]));

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockLoggerService.i(
            t.productDetails.refreshPartial(completed: 2, total: 2, failed: 1),
            showPopup: true,
          ),
        ).called(1);
        expect(actionLog[4], isA<ProductsLoadedAction>());
        expect((actionLog[4] as ProductsLoadedAction).products, [
          refreshedProduct,
        ]);
        expect(actionLog[5], isA<ProductRefreshFailedAction>());
        final List<dynamic> captured = verify(
          () => mockLoadProductsUseCase(captureAny()),
        ).captured;
        expect(captured.single, isA<NoParams>());
      },
    );

    test(
      'RefreshProductAction dispatches ProductRefreshedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockRefreshProductUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<RefreshProductAction>());
        expect(actionLog[1], isA<SourceRefreshStartedAction>());
        expect((actionLog[1] as SourceRefreshStartedAction).isGlobal, isFalse);
        expect(actionLog[2], isA<ProductRefreshedAction>());
        expect((actionLog[2] as ProductRefreshedAction).product, product);
        expect(actionLog[3], isA<SourceRefreshFinishedAction>());
        verify(
          () => mockRefreshProductUseCase(
            const RefreshProductParams(productId: 'product-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRefreshProductUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'RefreshProductAction dispatches ProductRefreshFailedAction when failed',
      () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockRefreshProductUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        final ProductRefreshFailedAction action =
            actionLog[2] as ProductRefreshFailedAction;
        expect(action.productId, isA<String>());
        expect(action.productId, 'product-1');
        expect(action.message, isA<String>());
        expect(action.message, 'failed');
        verify(
          () => mockRefreshProductUseCase(
            const RefreshProductParams(productId: 'product-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRefreshProductUseCase);
        verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test(
      'RefreshProductAction ignores a second refresh while one is active',
      () async {
        final Completer<Either<Failure, Product>> completer =
            Completer<Either<Failure, Product>>();
        when(
          () => mockRefreshProductUseCase(any()),
        ).thenAnswer((_) => completer.future);

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);
        middleware.call(store, const RefreshProductAction('product-1'), next);

        verify(() => mockRefreshProductUseCase(any())).called(1);
        completer.complete(Right(buildProduct()));
        await Future<void>.delayed(Duration.zero);
      },
    );
  });

  group('ProductsMiddleware processes RefreshSourceAction', () {
    test('RefreshSourceAction dispatches the refreshed product', () async {
      final Product product = buildProduct();
      when(() => mockRefreshSourceUseCase(any())).thenAnswer((
        invocation,
      ) async {
        final RefreshSourceParams params =
            invocation.positionalArguments.single as RefreshSourceParams;
        params.onSourceStatusChanged?.call(
          'source-1',
          SourceRefreshStatus.fetching,
        );
        params.onSourceStatusChanged?.call(
          'source-1',
          SourceRefreshStatus.success,
        );
        return Right(product);
      });

      middleware.call(store, const RefreshSourceAction('source-1'), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[0], const RefreshSourceAction('source-1'));
      expect(actionLog[1], const SourceRefreshStartedAction(['source-1']));
      expect(
        actionLog[2],
        const SourceRefreshStatusChangedAction(
          sourceId: 'source-1',
          status: SourceRefreshStatus.fetching,
        ),
      );
      expect(
        actionLog[3],
        const SourceRefreshStatusChangedAction(
          sourceId: 'source-1',
          status: SourceRefreshStatus.success,
        ),
      );
      expect(actionLog[4], isA<ProductRefreshedAction>());
      expect((actionLog[4] as ProductRefreshedAction).product, product);
      expect(actionLog[5], isA<SourceRefreshFinishedAction>());
      final List<dynamic> captured = verify(
        () => mockRefreshSourceUseCase(captureAny()),
      ).captured;
      expect(captured.single, isA<RefreshSourceParams>());
      expect((captured.single as RefreshSourceParams).sourceId, 'source-1');
      verifyZeroInteractions(mockLoggerService);
    });

    test('RefreshSourceAction reports a failure as a source error', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockRefreshSourceUseCase(any()),
      ).thenAnswer((_) async => const Left(failure));

      middleware.call(store, const RefreshSourceAction('source-1'), next);
      await Future<void>.delayed(Duration.zero);

      expect(actionLog[0], const RefreshSourceAction('source-1'));
      expect(actionLog[1], const SourceRefreshStartedAction(['source-1']));
      expect(
        actionLog[2],
        const SourceRefreshStatusChangedAction(
          sourceId: 'source-1',
          status: SourceRefreshStatus.error,
        ),
      );
      expect(actionLog[3], isA<SourceRefreshFinishedAction>());
      verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
      verifyNoMoreInteractions(mockLoggerService);
    });

    test(
      'RefreshSourceAction does not duplicate a terminal source error',
      () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(() => mockRefreshSourceUseCase(any())).thenAnswer((
          invocation,
        ) async {
          final RefreshSourceParams params =
              invocation.positionalArguments.single as RefreshSourceParams;
          params.onSourceStatusChanged?.call(
            'source-1',
            SourceRefreshStatus.error,
          );
          return const Left(failure);
        });

        middleware.call(store, const RefreshSourceAction('source-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog.length, 4);
        expect(
          actionLog.whereType<SourceRefreshStatusChangedAction>().length,
          1,
        );
        expect(actionLog.last, isA<SourceRefreshFinishedAction>());
      },
    );

    test(
      'RefreshSourceAction ignores a second refresh while one is active',
      () async {
        final Completer<Either<Failure, Product>> completer =
            Completer<Either<Failure, Product>>();
        when(
          () => mockRefreshSourceUseCase(any()),
        ).thenAnswer((_) => completer.future);

        middleware.call(store, const RefreshSourceAction('source-1'), next);
        await Future<void>.delayed(Duration.zero);
        middleware.call(store, const RefreshSourceAction('source-1'), next);

        verify(() => mockRefreshSourceUseCase(any())).called(1);
        completer.complete(Right(buildProduct()));
        await Future<void>.delayed(Duration.zero);
      },
    );
  });

  group('ProductsMiddleware processes RefreshAllProductsAction', () {
    test(
      'RefreshAllProductsAction shows the global completion message',
      () async {
        final Product product = buildProduct(sources: [buildProductSource()]);
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockRefreshAllProductsUseCase(
            any(),
            onSourceStatusChanged: any(named: 'onSourceStatusChanged'),
          ),
        ).thenAnswer((invocation) async {
          final SourceRefreshListener callback =
              invocation.namedArguments[const Symbol('onSourceStatusChanged')];
          callback('source-1', SourceRefreshStatus.success);
          return Right([product]);
        });

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockLoggerService.i(t.home.refreshAllComplete, showPopup: true),
        ).called(1);
      },
    );

    test(
      'RefreshAllProductsAction shows partial feedback when a source fails',
      () async {
        final Product product = buildProduct(sources: [buildProductSource()]);
        final Product refreshedProduct = buildProduct(
          lastUpdatedAt: DateTime(2026, 2, 1),
          sources: product.sources,
        );
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockRefreshAllProductsUseCase(
            any(),
            onSourceStatusChanged: any(named: 'onSourceStatusChanged'),
          ),
        ).thenAnswer((invocation) async {
          final SourceRefreshListener callback =
              invocation.namedArguments[const Symbol('onSourceStatusChanged')];
          callback('source-1', SourceRefreshStatus.error);
          return const Left(DatabaseFailure('failed'));
        });
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => Right([refreshedProduct]));

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockLoggerService.i(
            t.home.refreshAllPartial(failed: 1),
            showPopup: true,
          ),
        ).called(1);
        expect(actionLog[3], isA<ProductsLoadedAction>());
        expect((actionLog[3] as ProductsLoadedAction).products, [
          refreshedProduct,
        ]);
        expect(actionLog[4], isA<RefreshAllProductsFailedAction>());
        final List<dynamic> captured = verify(
          () => mockLoadProductsUseCase(captureAny()),
        ).captured;
        expect(captured.single, isA<NoParams>());
      },
    );

    test(
      'RefreshProductAction keeps the failure when reloading persisted products fails',
      () async {
        final Product product = buildProduct(sources: [buildProductSource()]);
        const DatabaseFailure refreshFailure = DatabaseFailure(
          'refresh failed',
        );
        const DatabaseFailure reloadFailure = DatabaseFailure('reload failed');
        when(() => store.state).thenReturn(
          AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(products: [product]),
          ),
        );
        when(
          () => mockRefreshProductUseCase(any()),
        ).thenAnswer((_) async => const Left(refreshFailure));
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => const Left(reloadFailure));

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog.whereType<ProductsLoadedAction>(), isEmpty);
        final ProductRefreshFailedAction failureAction = actionLog
            .whereType<ProductRefreshFailedAction>()
            .single;
        expect(failureAction.message, refreshFailure.message);
        final List<dynamic> captured = verify(
          () => mockLoadProductsUseCase(captureAny()),
        ).captured;
        expect(captured.single, isA<NoParams>());
      },
    );

    test(
      'RefreshAllProductsAction dispatches ProductsLoadedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockRefreshAllProductsUseCase(
            any(),
            onSourceStatusChanged: any(named: 'onSourceStatusChanged'),
          ),
        ).thenAnswer((_) async => Right([product]));

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<RefreshAllProductsAction>());
        expect(actionLog[1], isA<SourceRefreshStartedAction>());
        expect((actionLog[1] as SourceRefreshStartedAction).isGlobal, isTrue);
        expect(actionLog[2], isA<ProductsLoadedAction>());
        expect((actionLog[2] as ProductsLoadedAction).products, [product]);
        expect(actionLog[3], isA<SourceRefreshFinishedAction>());
        final List<dynamic> captured = verify(
          () => mockRefreshAllProductsUseCase(
            captureAny(),
            onSourceStatusChanged: any(named: 'onSourceStatusChanged'),
          ),
        ).captured;
        expect(captured.single, isA<NoParams>());
        verifyNoMoreInteractions(mockRefreshAllProductsUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'RefreshAllProductsAction dispatches failure action when failed',
      () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockRefreshAllProductsUseCase(
            any(),
            onSourceStatusChanged: any(named: 'onSourceStatusChanged'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[2], isA<RefreshAllProductsFailedAction>());
        expect(
          (actionLog[2] as RefreshAllProductsFailedAction).message,
          isA<String>(),
        );
        expect(
          (actionLog[2] as RefreshAllProductsFailedAction).message,
          'failed',
        );
        expect(actionLog[3], isA<SourceRefreshFinishedAction>());
        final List<dynamic> captured = verify(
          () => mockRefreshAllProductsUseCase(
            captureAny(),
            onSourceStatusChanged: any(named: 'onSourceStatusChanged'),
          ),
        ).captured;
        expect(captured.single, isA<NoParams>());
        verifyNoMoreInteractions(mockRefreshAllProductsUseCase);
        verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
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
