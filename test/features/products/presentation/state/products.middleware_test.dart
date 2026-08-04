// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.middleware.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import '../../fixtures/product.fixture.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockLoadProductsUseCase extends Mock implements LoadProductsUseCase {}

class MockRefreshProductUseCase extends Mock implements RefreshProductUseCase {}

class MockRefreshAllProductsUseCase extends Mock
    implements RefreshAllProductsUseCase {}

class MockLoggerService extends Mock implements LoggerService {}

class FakeRefreshProductParams extends Fake implements RefreshProductParams {}

void main() {
  late ProductsMiddleware middleware;
  late MockStore store;
  late MockLoadProductsUseCase mockLoadProductsUseCase;
  late MockRefreshProductUseCase mockRefreshProductUseCase;
  late MockRefreshAllProductsUseCase mockRefreshAllProductsUseCase;
  late MockLoggerService mockLoggerService;
  late List<dynamic> actionLog;

  void next(dynamic action) => actionLog.add(action);

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(FakeRefreshProductParams());
  });

  setUp(() {
    middleware = ProductsMiddleware();
    store = MockStore();
    mockLoadProductsUseCase = MockLoadProductsUseCase();
    mockRefreshProductUseCase = MockRefreshProductUseCase();
    mockRefreshAllProductsUseCase = MockRefreshAllProductsUseCase();
    mockLoggerService = MockLoggerService();
    actionLog = [];

    when(() => store.dispatch(any())).thenAnswer(
      (Invocation invocation) =>
          actionLog.add(invocation.positionalArguments[0]),
    );
    sl.registerSingleton<LoadProductsUseCase>(mockLoadProductsUseCase);
    sl.registerSingleton<RefreshProductUseCase>(mockRefreshProductUseCase);
    sl.registerSingleton<RefreshAllProductsUseCase>(
      mockRefreshAllProductsUseCase,
    );
    sl.registerSingleton<LoggerService>(mockLoggerService);
  });

  tearDown(() async {
    await sl.reset();
    reset(mockLoggerService);
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
}
