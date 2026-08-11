// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late CreateProductUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = CreateProductUseCase(mockRepository);
    registerFallbackValue(
      Product(
        id: 'fallback-product',
        name: 'Fallback Product',
        sources: [],
        lastUpdatedAt: DateTime(2026),
      ),
    );
  });

  group('CreateProductUseCase returns the correct value', () {
    test(
      'creates a bare product and delegates it to the repository with no source',
      () async {
        final Product createdProduct = Product(
          id: 'product-1',
          name: 'Example Product',
          sources: [],
          lastUpdatedAt: DateTime(2026),
        );
        when(
          () => mockRepository.createProduct(any(), null),
        ).thenAnswer((_) async => Right(createdProduct));

        final Either<Failure, Product> result = await useCase(
          const CreateProductParams(name: '  Example Product  '),
        );

        expect(result, Right(createdProduct));
        final VerificationResult verification = verify(
          () => mockRepository.createProduct(captureAny(), null),
        );
        verification.called(1);
        final Product product = verification.captured[0] as Product;
        expect(product.name, 'Example Product');
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('returns ValidationFailure when the name is blank', () async {
      final Either<Failure, Product> result = await useCase(
        const CreateProductParams(name: '  '),
      );

      expect(result, const Left(ValidationFailure('Product name is required')));
      verifyZeroInteractions(mockRepository);
    });

    test('forwards repository failures unchanged', () async {
      const DatabaseFailure failure = DatabaseFailure('database failed');
      when(
        () => mockRepository.createProduct(any(), null),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Product> result = await useCase(
        const CreateProductParams(name: 'Example Product'),
      );

      expect(result, const Left(failure));
      verify(() => mockRepository.createProduct(any(), null)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
