// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late DeleteProductUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = DeleteProductUseCase(mockRepository);
  });

  group('Usecase DeleteProductUseCase returns the correct value', () {
    test('returns Right(unit) when the repository returns Right', () async {
      when(
        () => mockRepository.deleteProduct('product-1'),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const DeleteProductParams(productId: 'product-1'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteProduct('product-1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'returns Left(NotFoundFailure) when the repository returns Left',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Product not found');
        when(
          () => mockRepository.deleteProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const DeleteProductParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.deleteProduct('product-1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the repository returns Left',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.deleteProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const DeleteProductParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.deleteProduct('product-1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('forwards a different productId to the repository', () async {
      when(
        () => mockRepository.deleteProduct('product-2'),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const DeleteProductParams(productId: 'product-2'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteProduct('product-2')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
