// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
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
        storePrices: [],
        lastUpdatedAt: DateTime(2026),
      ),
    );
    registerFallbackValue(
      ProductSource.fromUrl(
        id: 'fallback-source',
        productId: 'fallback-product',
        url: 'https://example.com/fallback',
        createdAt: DateTime(2026),
      ),
    );
  });

  group('CreateProductUseCase returns the correct value', () {
    test(
      'creates a product and forwards its source to the repository',
      () async {
        final Product createdProduct = Product(
          id: 'product-1',
          name: 'Example Product',
          storePrices: [],
          lastUpdatedAt: DateTime(2026),
        );
        when(
          () => mockRepository.createProduct(any(), any()),
        ).thenAnswer((_) async => Right(createdProduct));

        final Either<Failure, Product> result = await useCase(
          const CreateProductParams(
            name: '  Example Product  ',
            url: 'https://example.com/products/1',
          ),
        );

        expect(result, Right(createdProduct));
        final VerificationResult verification = verify(
          () => mockRepository.createProduct(captureAny(), captureAny()),
        );
        verification.called(1);
        final Product product = verification.captured[0] as Product;
        final ProductSource source = verification.captured[1] as ProductSource;
        expect(product.name, 'Example Product');
        expect(product.id, source.productId);
        expect(source.url, 'https://example.com/products/1');
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('returns ValidationFailure when the name is blank', () async {
      final Either<Failure, Product> result = await useCase(
        const CreateProductParams(
          name: '  ',
          url: 'https://example.com/products/1',
        ),
      );

      expect(result, const Left(ValidationFailure('Product name is required')));
      verifyZeroInteractions(mockRepository);
    });

    test('returns ValidationFailure for an invalid URL', () async {
      final Either<Failure, Product> result = await useCase(
        const CreateProductParams(
          name: 'Example Product',
          url: 'http://example.com/products/1',
        ),
      );

      expect(result, isA<Left<Failure, Product>>());
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyZeroInteractions(mockRepository);
    });

    test('forwards repository failures unchanged', () async {
      const DatabaseFailure failure = DatabaseFailure('database failed');
      when(
        () => mockRepository.createProduct(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Product> result = await useCase(
        const CreateProductParams(
          name: 'Example Product',
          url: 'https://example.com/products/1',
        ),
      );

      expect(result, const Left(failure));
      verify(() => mockRepository.createProduct(any(), any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
