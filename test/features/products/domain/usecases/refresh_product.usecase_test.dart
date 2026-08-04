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

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late RefreshProductUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = RefreshProductUseCase(mockRepository);
  });

  group('Usecase RefreshProductUseCase returns the correct value', () {
    test('returns Right(Product) when the repository returns Right', () async {
      final Product product = buildProduct();
      when(
        () => mockRepository.refreshProduct('product-1'),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await useCase(
        const RefreshProductParams(productId: 'product-1'),
      );

      expect(result, Right(product));
      verify(() => mockRepository.refreshProduct('product-1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'returns Left(DatabaseFailure) when the repository returns Left',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.refreshProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await useCase(
          const RefreshProductParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.refreshProduct('product-1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(NetworkFailure) when the repository returns Left',
      () async {
        const NetworkFailure failure = NetworkFailure('network failed');
        when(
          () => mockRepository.refreshProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await useCase(
          const RefreshProductParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.refreshProduct('product-1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('forwards a different productId to the repository', () async {
      final Product product = buildProduct(id: 'product-2');
      when(
        () => mockRepository.refreshProduct('product-2'),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await useCase(
        const RefreshProductParams(productId: 'product-2'),
      );

      expect(result, Right(product));
      verify(() => mockRepository.refreshProduct('product-2')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
