// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late RefreshProductUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = RefreshProductUseCase(mockRepository);
  });

  group('Usecase RefreshProductUseCase returns the correct value', () {
    test(
      "queues the matching product's source ids and returns Right(unit)",
      () async {
        final Product product = buildProduct(
          sources: [
            buildProductSource(id: 'source-1'),
            buildProductSource(id: 'source-2', url: 'https://example.com/2'),
          ],
        );
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => Right([product]));
        when(
          () => mockRepository.enqueueSourceRefresh(['source-1', 'source-2']),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await useCase(
          const RefreshProductParams(productId: 'product-1'),
        );

        expect(result, const Right(unit));
        verify(() => mockRepository.loadProducts()).called(1);
        verify(
          () => mockRepository.enqueueSourceRefresh(['source-1', 'source-2']),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('queues an empty list when the product has no sources', () async {
      final Product product = buildProduct();
      when(
        () => mockRepository.loadProducts(),
      ).thenAnswer((_) async => Right([product]));
      when(
        () => mockRepository.enqueueSourceRefresh([]),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const RefreshProductParams(productId: 'product-1'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.loadProducts()).called(1);
      verify(() => mockRepository.enqueueSourceRefresh([])).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('queues an empty list when no product matches productId', () async {
      when(
        () => mockRepository.loadProducts(),
      ).thenAnswer((_) async => const Right([]));
      when(
        () => mockRepository.enqueueSourceRefresh([]),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const RefreshProductParams(productId: 'missing-product'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.loadProducts()).called(1);
      verify(() => mockRepository.enqueueSourceRefresh([])).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'returns Left(DatabaseFailure) when loadProducts() fails, without enqueueing',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const RefreshProductParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.loadProducts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when enqueueSourceRefresh() fails',
      () async {
        final Product product = buildProduct(
          sources: [buildProductSource(id: 'source-1')],
        );
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.loadProducts(),
        ).thenAnswer((_) async => Right([product]));
        when(
          () => mockRepository.enqueueSourceRefresh(['source-1']),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const RefreshProductParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.loadProducts()).called(1);
        verify(
          () => mockRepository.enqueueSourceRefresh(['source-1']),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('selects the correct product among several by productId', () async {
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
      when(
        () => mockRepository.loadProducts(),
      ).thenAnswer((_) async => Right([otherProduct, targetProduct]));
      when(
        () => mockRepository.enqueueSourceRefresh(['target-source']),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const RefreshProductParams(productId: 'product-2'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.loadProducts()).called(1);
      verify(
        () => mockRepository.enqueueSourceRefresh(['target-source']),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
