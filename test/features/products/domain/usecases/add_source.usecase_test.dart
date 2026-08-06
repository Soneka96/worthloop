// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late AddSourceUseCase useCase;

  setUp(() {
    useCase = AddSourceUseCase(mockRepository = MockIProductsRepository());
    registerFallbackValue(
      ProductSource.fromUrl(
        id: 'fallback-source',
        productId: 'fallback-product',
        url: 'https://example.com/fallback',
        createdAt: DateTime(2026),
      ),
    );
  });

  group('AddSourceUseCase returns the correct value', () {
    test('creates a source and delegates it to the repository', () async {
      final Product product = buildProduct();
      when(
        () => mockRepository.addSource(any()),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await useCase(
        const AddSourceParams(
          productId: 'product-1',
          url: 'https://example.com/products/1',
        ),
      );

      expect(result, Right(product));
      final VerificationResult verification = verify(
        () => mockRepository.addSource(captureAny()),
      );
      verification.called(1);
      final ProductSource source = verification.captured[0] as ProductSource;
      expect(source.productId, 'product-1');
      expect(source.url, 'https://example.com/products/1');
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns ValidationFailure for an invalid URL', () async {
      final Either<Failure, Product> result = await useCase(
        const AddSourceParams(
          productId: 'product-1',
          url: 'http://example.com/products/1',
        ),
      );

      expect(result, isA<Left<Failure, Product>>());
      final Failure? failure = result.getLeft().toNullable();
      expect(failure, isA<ValidationFailure>());
      expect(failure?.message, 'Must be a valid HTTPS URL');
      verifyZeroInteractions(mockRepository);
    });

    test('forwards repository failures unchanged', () async {
      const DatabaseFailure failure = DatabaseFailure('database failed');
      when(
        () => mockRepository.addSource(any()),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Product> result = await useCase(
        const AddSourceParams(
          productId: 'product-1',
          url: 'https://example.com/products/1',
        ),
      );

      expect(result, const Left(failure));
      verify(() => mockRepository.addSource(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
