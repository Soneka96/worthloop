// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_source.usecase.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product.fixture.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late RefreshSourceUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = RefreshSourceUseCase(mockRepository);
  });

  group('Usecase RefreshSourceUseCase returns the correct value', () {
    test(
      'delegates sourceId and listener and returns Right(Product)',
      () async {
        final Product product = buildProduct();
        void listener(String sourceId, SourceRefreshStatus status) {}
        when(
          () => mockRepository.refreshSource(
            'source-1',
            onSourceStatusChanged: listener,
          ),
        ).thenAnswer((_) async => Right(product));

        final Either<Failure, Product> result = await useCase(
          RefreshSourceParams(
            sourceId: 'source-1',
            onSourceStatusChanged: listener,
          ),
        );

        expect(result, Right(product));
        verify(
          () => mockRepository.refreshSource(
            'source-1',
            onSourceStatusChanged: listener,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('returns the repository failure unchanged', () async {
      const NetworkFailure failure = NetworkFailure('network failed');
      when(
        () => mockRepository.refreshSource(
          'source-1',
          onSourceStatusChanged: null,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Product> result = await useCase(
        const RefreshSourceParams(sourceId: 'source-1'),
      );

      expect(result, const Left(failure));
      verify(
        () => mockRepository.refreshSource(
          'source-1',
          onSourceStatusChanged: null,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
