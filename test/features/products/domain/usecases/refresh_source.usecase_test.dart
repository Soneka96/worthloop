// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_source.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';

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
      'queues the source with bypassCooldown = false by default and returns Right(unit)',
      () async {
        when(
          () => mockRepository.enqueueSourceRefresh([
            'source-1',
          ], bypassCooldown: false),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await useCase(
          const RefreshSourceParams(sourceId: 'source-1'),
        );

        expect(result, const Right(unit));
        verify(
          () => mockRepository.enqueueSourceRefresh([
            'source-1',
          ], bypassCooldown: false),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('returns the repository failure unchanged', () async {
      const NetworkFailure failure = NetworkFailure('network failed');
      when(
        () => mockRepository.enqueueSourceRefresh([
          'source-1',
        ], bypassCooldown: false),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Unit> result = await useCase(
        const RefreshSourceParams(sourceId: 'source-1'),
      );

      expect(result, const Left(failure));
      verify(
        () => mockRepository.enqueueSourceRefresh([
          'source-1',
        ], bypassCooldown: false),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('forwards an overridden cooldown bypass to the repository', () async {
      when(
        () => mockRepository.enqueueSourceRefresh([
          'source-1',
        ], bypassCooldown: true),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const RefreshSourceParams(sourceId: 'source-1', bypassCooldown: true),
      );

      expect(result, const Right(unit));
      verify(
        () => mockRepository.enqueueSourceRefresh([
          'source-1',
        ], bypassCooldown: true),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
