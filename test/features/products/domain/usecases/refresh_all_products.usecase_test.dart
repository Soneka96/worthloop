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
      'returns Right(List<Product>) when the repository returns Right',
      () async {
        final List<Product> products = [buildProduct()];
        when(
          () => mockRepository.refreshAllProducts(),
        ).thenAnswer((_) async => Right(products));

        final Either<Failure, List<Product>> result = await useCase(NoParams());

        expect(result, Right(products));
        verify(() => mockRepository.refreshAllProducts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the repository returns Left',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.refreshAllProducts(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<Product>> result = await useCase(NoParams());

        expect(result, const Left(failure));
        verify(() => mockRepository.refreshAllProducts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(NetworkFailure) when the repository returns Left',
      () async {
        const NetworkFailure failure = NetworkFailure('network failed');
        when(
          () => mockRepository.refreshAllProducts(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<Product>> result = await useCase(NoParams());

        expect(result, const Left(failure));
        verify(() => mockRepository.refreshAllProducts()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
