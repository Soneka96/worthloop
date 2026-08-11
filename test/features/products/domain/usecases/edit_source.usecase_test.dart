// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late EditSourceUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = EditSourceUseCase(mockRepository);
  });

  group('Usecase EditSourceUseCase returns the correct value', () {
    test('returns Right(Product) when the repository returns Right', () async {
      final Product product = buildProduct();
      when(
        () => mockRepository.updateSource(
          'source-1',
          'https://example.com/updated',
        ),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await useCase(
        const EditSourceParams(
          sourceId: 'source-1',
          url: 'https://example.com/updated',
        ),
      );

      expect(result, Right(product));
      verify(
        () => mockRepository.updateSource(
          'source-1',
          'https://example.com/updated',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'returns Left(ValidationFailure) when the repository returns Left',
      () async {
        const ValidationFailure failure = ValidationFailure(
          'Must be a valid HTTPS URL',
        );
        when(
          () => mockRepository.updateSource('source-1', 'not-a-url'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await useCase(
          const EditSourceParams(sourceId: 'source-1', url: 'not-a-url'),
        );

        expect(result, const Left(failure));
        verify(
          () => mockRepository.updateSource('source-1', 'not-a-url'),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(NotFoundFailure) when the repository returns Left',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Source not found');
        when(
          () => mockRepository.updateSource(
            'source-1',
            'https://example.com/updated',
          ),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await useCase(
          const EditSourceParams(
            sourceId: 'source-1',
            url: 'https://example.com/updated',
          ),
        );

        expect(result, const Left(failure));
        verify(
          () => mockRepository.updateSource(
            'source-1',
            'https://example.com/updated',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the repository returns Left',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.updateSource(
            'source-1',
            'https://example.com/updated',
          ),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await useCase(
          const EditSourceParams(
            sourceId: 'source-1',
            url: 'https://example.com/updated',
          ),
        );

        expect(result, const Left(failure));
        verify(
          () => mockRepository.updateSource(
            'source-1',
            'https://example.com/updated',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
