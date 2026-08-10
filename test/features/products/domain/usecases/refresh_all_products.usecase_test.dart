// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late RefreshAllProductsUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = RefreshAllProductsUseCase(mockRepository);
  });

  group('Usecase RefreshAllProductsUseCase returns the correct value', () {
    test(
      'queues source ids flattened across every product and returns Right(unit)',
      () async {
        final List<Product> products = [
          buildProduct(
            id: 'product-1',
            sources: [buildProductSource(id: 'source-1')],
          ),
          buildProduct(
            id: 'product-2',
            sources: [
              buildProductSource(
                id: 'source-2',
                productId: 'product-2',
                url: 'https://example.com/2',
              ),
              buildProductSource(
                id: 'source-3',
                productId: 'product-2',
                url: 'https://example.com/3',
              ),
            ],
          ),
        ];
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => Right(products));
        when(
          () => mockRepository.enqueueSourceRefresh([
            'source-1',
            'source-2',
            'source-3',
          ]),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await useCase(NoParams());

        expect(result, const Right(unit));
        verify(() => mockRepository.loadProducts()).called(1);
        verify(
          () => mockRepository.enqueueSourceRefresh([
            'source-1',
            'source-2',
            'source-3',
          ]),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('queues an empty list when there are no tracked products', () async {
      when(
        () => mockRepository.loadProducts(),
      ).thenAnswer((_) async => const Right([]));
      when(
        () => mockRepository.enqueueSourceRefresh([]),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(NoParams());

      expect(result, const Right(unit));
      verify(() => mockRepository.loadProducts()).called(1);
      verify(() => mockRepository.enqueueSourceRefresh([])).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'returns Left(DatabaseFailure) when enqueueSourceRefresh() fails',
      () async {
        final Product product = buildProduct(
          id: 'product-1',
          sources: [buildProductSource(id: 'source-1')],
        );
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => Right([product]));
        when(
          () => mockRepository.enqueueSourceRefresh(['source-1']),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(NoParams());

        expect(result, const Left(failure));
        verify(() => mockRepository.loadProducts()).called(1);
        verify(
          () => mockRepository.enqueueSourceRefresh(['source-1']),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when loadProducts() fails, without enqueueing',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(NoParams());

        expect(result, const Left(failure));
        verify(() => mockRepository.loadProducts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(NetworkFailure) when loadProducts() fails, without enqueueing',
      () async {
        const NetworkFailure failure = NetworkFailure('network failed');
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(NoParams());

        expect(result, const Left(failure));
        verify(() => mockRepository.loadProducts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
