// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/state/create_store.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';

class MockLoadProductsUseCase extends Mock implements LoadProductsUseCase {}

void main() {
  setUpAll(() => registerFallbackValue(NoParams()));

  group('CreateStore behaves correctly', () {
    late Store<AppState> store;
    late MockLoadProductsUseCase mockLoadProductsUseCase;

    setUp(() {
      store = CreateStore()();
      mockLoadProductsUseCase = MockLoadProductsUseCase();
    });

    tearDown(() async => sl.reset());

    test('CreateStore returns a Store with the initial AppState', () {
      expect(store.state, AppState.initial());
    });

    test(
      'CreateStore processes LoadProductsAction with product middleware',
      () async {
        when(
          () => mockLoadProductsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));
        sl.registerSingleton<LoadProductsUseCase>(mockLoadProductsUseCase);

        store.dispatch(const LoadProductsAction());
        await Future<void>.delayed(Duration.zero);

        verify(() => mockLoadProductsUseCase(any())).called(1);
        expect(store.state.products.isLoading, isA<bool>());
        expect(store.state.products.isLoading, isFalse);
      },
    );
  });
}
