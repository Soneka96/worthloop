// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';

class MockIProductsRepository extends Mock implements IProductsRepository {}

void main() {
  late MockIProductsRepository mockRepository;
  late DeleteSourceUseCase useCase;

  setUp(() {
    mockRepository = MockIProductsRepository();
    useCase = DeleteSourceUseCase(mockRepository);
  });

  group('Usecase DeleteSourceUseCase returns the correct value', () {
    test('returns Right(unit) when the repository returns Right', () async {
      when(
        () => mockRepository.deleteSource('source-1'),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const DeleteSourceParams(sourceId: 'source-1'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteSource('source-1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'returns Left(NotFoundFailure) when the repository returns Left',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Source not found');
        when(
          () => mockRepository.deleteSource('source-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const DeleteSourceParams(sourceId: 'source-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.deleteSource('source-1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the repository returns Left',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockRepository.deleteSource('source-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          const DeleteSourceParams(sourceId: 'source-1'),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.deleteSource('source-1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('forwards a different sourceId to the repository', () async {
      when(
        () => mockRepository.deleteSource('source-2'),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await useCase(
        const DeleteSourceParams(sourceId: 'source-2'),
      );

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteSource('source-2')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
