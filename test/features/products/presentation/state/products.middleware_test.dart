// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_product_sources.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/load_product_sources.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.middleware.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockLoadProductsUseCase extends Mock implements LoadProductsUseCase {}

class MockCreateProductUseCase extends Mock implements CreateProductUseCase {}

class MockRefreshProductUseCase extends Mock implements RefreshProductUseCase {}

class MockRefreshAllProductsUseCase extends Mock
    implements RefreshAllProductsUseCase {}

class MockLoadProductSourcesUseCase extends Mock
    implements LoadProductSourcesUseCase {}

class MockAddSourceUseCase extends Mock implements AddSourceUseCase {}

class MockEditSourceUseCase extends Mock implements EditSourceUseCase {}

class MockDeleteSourceUseCase extends Mock implements DeleteSourceUseCase {}

class MockRenameProductUseCase extends Mock implements RenameProductUseCase {}

class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

class MockLoggerService extends Mock implements LoggerService {}

class MockNavigatorService extends Mock implements NavigatorService {}

class FakeRefreshProductParams extends Fake implements RefreshProductParams {}

class FakeCreateProductParams extends Fake implements CreateProductParams {}

class FakeLoadProductSourcesParams extends Fake
    implements LoadProductSourcesParams {}

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
  late MockRefreshAllProductsUseCase mockRefreshAllProductsUseCase;
  late MockLoadProductSourcesUseCase mockLoadProductSourcesUseCase;
  late MockAddSourceUseCase mockAddSourceUseCase;
  late MockEditSourceUseCase mockEditSourceUseCase;
  late MockDeleteSourceUseCase mockDeleteSourceUseCase;
  late MockRenameProductUseCase mockRenameProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;
  late MockLoggerService mockLoggerService;
  late MockNavigatorService mockNavigatorService;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(FakeRefreshProductParams());
    registerFallbackValue(FakeCreateProductParams());
    registerFallbackValue(FakeLoadProductSourcesParams());
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
    mockRefreshAllProductsUseCase = MockRefreshAllProductsUseCase();
    mockLoadProductSourcesUseCase = MockLoadProductSourcesUseCase();
    mockAddSourceUseCase = MockAddSourceUseCase();
    mockEditSourceUseCase = MockEditSourceUseCase();
    mockDeleteSourceUseCase = MockDeleteSourceUseCase();
    mockRenameProductUseCase = MockRenameProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();
    mockLoggerService = MockLoggerService();
    mockNavigatorService = MockNavigatorService();
    actionLog = [];

    when(() => store.dispatch(any())).thenAnswer(
      (Invocation invocation) =>
          actionLog.add(invocation.positionalArguments[0]),
    );
    sl.registerSingleton<LoadProductsUseCase>(mockLoadProductsUseCase);
    sl.registerSingleton<CreateProductUseCase>(mockCreateProductUseCase);
    sl.registerSingleton<RefreshProductUseCase>(mockRefreshProductUseCase);
    sl.registerSingleton<RefreshAllProductsUseCase>(
      mockRefreshAllProductsUseCase,
    );
    sl.registerSingleton<LoadProductSourcesUseCase>(
      mockLoadProductSourcesUseCase,
    );
    sl.registerSingleton<AddSourceUseCase>(mockAddSourceUseCase);
    sl.registerSingleton<EditSourceUseCase>(mockEditSourceUseCase);
    sl.registerSingleton<DeleteSourceUseCase>(mockDeleteSourceUseCase);
    sl.registerSingleton<RenameProductUseCase>(mockRenameProductUseCase);
    sl.registerSingleton<DeleteProductUseCase>(mockDeleteProductUseCase);
    sl.registerSingleton<LoggerService>(mockLoggerService);
    sl.registerSingleton<NavigatorService>(mockNavigatorService);
  });

  tearDown(() async {
    await sl.reset();
    reset(mockLoggerService);
    reset(mockNavigatorService);
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
          const CreateProductAction(
            name: 'Example Product',
            url: 'https://example.com/products/1',
          ),
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
          const CreateProductAction(
            name: 'Example Product',
            url: 'http://example.com/products/1',
          ),
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
      'RefreshProductAction dispatches ProductRefreshedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockRefreshProductUseCase(any()),
        ).thenAnswer((_) async => Right(product));

        middleware.call(store, const RefreshProductAction('product-1'), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<RefreshProductAction>());
        expect(actionLog[1], isA<ProductRefreshedAction>());
        expect((actionLog[1] as ProductRefreshedAction).product, product);
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
            actionLog[1] as ProductRefreshFailedAction;
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
  });

  group('ProductsMiddleware processes RefreshAllProductsAction', () {
    test(
      'RefreshAllProductsAction dispatches ProductsLoadedAction when successful',
      () async {
        final Product product = buildProduct();
        when(
          () => mockRefreshAllProductsUseCase(any()),
        ).thenAnswer((_) async => Right([product]));

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<RefreshAllProductsAction>());
        expect(actionLog[1], isA<ProductsLoadedAction>());
        expect((actionLog[1] as ProductsLoadedAction).products, [product]);
        final List<dynamic> captured = verify(
          () => mockRefreshAllProductsUseCase(captureAny()),
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
          () => mockRefreshAllProductsUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(store, const RefreshAllProductsAction(), next);
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[1], isA<RefreshAllProductsFailedAction>());
        expect(
          (actionLog[1] as RefreshAllProductsFailedAction).message,
          isA<String>(),
        );
        expect(
          (actionLog[1] as RefreshAllProductsFailedAction).message,
          'failed',
        );
        final List<dynamic> captured = verify(
          () => mockRefreshAllProductsUseCase(captureAny()),
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

  group('ProductsMiddleware processes LoadProductSourcesAction', () {
    test(
      'LoadProductSourcesAction dispatches ProductSourcesLoadedAction when successful',
      () async {
        final ProductSource source = buildProductSource();
        when(
          () => mockLoadProductSourcesUseCase(any()),
        ).thenAnswer((_) async => Right([source]));

        middleware.call(
          store,
          const LoadProductSourcesAction('product-1'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        expect(actionLog[0], isA<LoadProductSourcesAction>());
        expect(actionLog[1], isA<ProductSourcesLoadedAction>());
        expect(
          (actionLog[1] as ProductSourcesLoadedAction).productId,
          'product-1',
        );
        expect((actionLog[1] as ProductSourcesLoadedAction).sources, [source]);
        verify(
          () => mockLoadProductSourcesUseCase(
            const LoadProductSourcesParams(productId: 'product-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLoadProductSourcesUseCase);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'LoadProductSourcesAction dispatches ProductSourcesLoadFailedAction when failed',
      () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockLoadProductSourcesUseCase(any()),
        ).thenAnswer((_) async => const Left(failure));

        middleware.call(
          store,
          const LoadProductSourcesAction('product-1'),
          next,
        );
        await Future<void>.delayed(Duration.zero);

        final ProductSourcesLoadFailedAction action =
            actionLog[1] as ProductSourcesLoadFailedAction;
        expect(action.productId, isA<String>());
        expect(action.productId, 'product-1');
        expect(action.message, isA<String>());
        expect(action.message, 'failed');
        verify(
          () => mockLoadProductSourcesUseCase(
            const LoadProductSourcesParams(productId: 'product-1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLoadProductSourcesUseCase);
        verify(() => mockLoggerService.e('failed', showPopup: true)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('ProductsMiddleware processes AddSourceAction', () {
    test(
      'AddSourceAction dispatches SourceAddedAction when successful',
      () async {
        final ProductSource source = buildProductSource();
        when(
          () => mockAddSourceUseCase(any()),
        ).thenAnswer((_) async => Right(source));

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
        expect((actionLog[1] as SourceAddedAction).source, source);
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
        final ProductSource source = buildProductSource();
        when(
          () => mockEditSourceUseCase(any()),
        ).thenAnswer((_) async => Right(source));

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
        expect((actionLog[1] as SourceEditedAction).source, source);
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
        when(
          () => mockDeleteSourceUseCase(any()),
        ).thenAnswer((_) async => const Right(unit));

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
          const SourceDeletedAction(
            productId: 'product-1',
            sourceId: 'source-1',
          ),
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
