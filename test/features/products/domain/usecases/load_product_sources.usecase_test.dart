// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/load_product_sources.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/load_product_sources.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product_source.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late LoadProductSourcesUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = LoadProductSourcesUseCase(mockRepository);
  });

  group('Usecase LoadProductSourcesUseCase returns the correct value', () {
    test(
      'returns Right(List<ProductSource>) when the repository returns Right',
      () async {
        final List<ProductSource> sources = [buildProductSource()];
        when(
          () => mockRepository.loadSourcesForProduct('product-1'),
        ).thenAnswer((_) async => Right(sources));

        final Either<Failure, List<ProductSource>> result = await useCase(
          const LoadProductSourcesParams(productId: 'product-1'),
        );

        expect(result, Right(sources));
        verify(
          () => mockRepository.loadSourcesForProduct('product-1'),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the repository returns Left',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.loadSourcesForProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<ProductSource>> result = await useCase(
          const LoadProductSourcesParams(productId: 'product-1'),
        );

        expect(result, const Left(failure));
        verify(
          () => mockRepository.loadSourcesForProduct('product-1'),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('forwards a different productId to the repository', () async {
      when(
        () => mockRepository.loadSourcesForProduct('product-2'),
      ).thenAnswer((_) async => const Right(<ProductSource>[]));

      final Either<Failure, List<ProductSource>> result = await useCase(
        const LoadProductSourcesParams(productId: 'product-2'),
      );

      expect(result, const Right(<ProductSource>[]));
      verify(() => mockRepository.loadSourcesForProduct('product-2')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
