// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/load_log_entries.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import '../../fixtures/log_entry.fixture.dart';

class MockILogsRepository extends Mock implements ILogsRepository {}

void main() {
  late MockILogsRepository mockRepo;
  late LoadLogEntriesUseCase useCase;

  setUp(() {
    mockRepo = MockILogsRepository();
    useCase = LoadLogEntriesUseCase(mockRepo);
  });

  group('Usecase LoadLogEntriesUseCase returns the correct value', () {
    test(
      'Usecase LoadLogEntriesUseCase returns Right(List<LogEntry>) when the repository returns Right(List<LogEntry>)',
      () async {
        final LogEntry entry = buildLogEntry();
        when(
          () => mockRepo.loadRecentLogEntries(),
        ).thenAnswer((_) async => Right([entry]));

        final Either<Failure, List<LogEntry>> result = await useCase(
          NoParams(),
        );

        expect(result.isRight(), isTrue);
        result.match(
          (f) => fail('expected Right, got Left($f)'),
          (entries) => expect(entries, [entry]),
        );
        verify(() => mockRepo.loadRecentLogEntries()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'Usecase LoadLogEntriesUseCase returns Left(DatabaseFailure) when the repository returns Left(DatabaseFailure)',
      () async {
        const failure = DatabaseFailure('boom');
        when(
          () => mockRepo.loadRecentLogEntries(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<LogEntry>> result = await useCase(
          NoParams(),
        );

        expect(result, const Left(failure));
        verify(() => mockRepo.loadRecentLogEntries()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
