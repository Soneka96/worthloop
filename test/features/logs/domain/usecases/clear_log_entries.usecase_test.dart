// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/clear_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/clear_log_entries.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';

class MockILogsRepository extends Mock implements ILogsRepository {}

void main() {
  late MockILogsRepository mockRepo;
  late ClearLogEntriesUseCase useCase;
  final DateTime cutoff = DateTime(2026, 1, 1, 12);

  setUp(() {
    mockRepo = MockILogsRepository();
    useCase = ClearLogEntriesUseCase(mockRepo);
  });

  group('Usecase ClearLogEntriesUseCase returns the correct value', () {
    test(
      'Usecase ClearLogEntriesUseCase returns Right(unit) when the repository returns Right(unit)',
      () async {
        when(
          () => mockRepo.clearLogEntries(any()),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await useCase(
          ClearLogEntriesParams(cutoff: cutoff),
        );

        expect(result, const Right(unit));
        verify(() => mockRepo.clearLogEntries(cutoff)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'Usecase ClearLogEntriesUseCase returns Left(DatabaseFailure) when the repository returns Left(DatabaseFailure)',
      () async {
        const failure = DatabaseFailure('boom');
        when(
          () => mockRepo.clearLogEntries(any()),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await useCase(
          ClearLogEntriesParams(cutoff: cutoff),
        );

        expect(result, const Left(failure));
        verify(() => mockRepo.clearLogEntries(cutoff)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
