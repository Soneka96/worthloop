// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late RenameProductUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = RenameProductUseCase(mockRepository);
  });

  group('Usecase RenameProductUseCase returns the correct value', () {
    test('renames the product and delegates to the repository', () async {
      final Product renamedProduct = buildProduct(name: 'Renamed Product');
      when(
        () => mockRepository.renameProduct('product-1', 'Renamed Product'),
      ).thenAnswer((_) async => Right(renamedProduct));

      final Either<Failure, Product> result = await useCase(
        const RenameProductParams(
          productId: 'product-1',
          name: '  Renamed Product  ',
        ),
      );

      expect(result, Right(renamedProduct));
      verify(
        () => mockRepository.renameProduct('product-1', 'Renamed Product'),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns ValidationFailure when the name is blank', () async {
      final Either<Failure, Product> result = await useCase(
        const RenameProductParams(productId: 'product-1', name: '  '),
      );

      expect(result, const Left(ValidationFailure('Product name is required')));
      verifyZeroInteractions(mockRepository);
    });

    test('forwards repository failures unchanged', () async {
      const NotFoundFailure failure = NotFoundFailure('Product not found');
      when(
        () => mockRepository.renameProduct('product-1', 'Renamed Product'),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Product> result = await useCase(
        const RenameProductParams(
          productId: 'product-1',
          name: 'Renamed Product',
        ),
      );

      expect(result, const Left(failure));
      verify(
        () => mockRepository.renameProduct('product-1', 'Renamed Product'),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
