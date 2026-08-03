// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/export_log_entries.usecase.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/export_log_entries.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/log_entry.fixture.dart';

class MockILogsRepository extends Mock implements ILogsRepository {}

void main() {
  late MockILogsRepository mockRepo;
  late ExportLogEntriesUseCase useCase;
  final List<LogEntry> entries = [buildLogEntry()];

  setUp(() {
    mockRepo = MockILogsRepository();
    useCase = ExportLogEntriesUseCase(mockRepo);
  });

  group('Usecase ExportLogEntriesUseCase returns the correct value', () {
    test(
      'Usecase ExportLogEntriesUseCase returns Right(path) when the repository returns Right(path)',
      () async {
        when(
          () => mockRepo.exportLogEntries(any()),
        ).thenAnswer((_) async => const Right('C:/App/logs.txt'));

        final Either<Failure, String?> result = await useCase(
          ExportLogEntriesParams(entries: entries),
        );

        expect(result, const Right('C:/App/logs.txt'));
        verify(() => mockRepo.exportLogEntries(entries)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test(
      'Usecase ExportLogEntriesUseCase returns Left(FileSystemFailure) when the repository returns Left(FileSystemFailure)',
      () async {
        const failure = FileSystemFailure('boom');
        when(
          () => mockRepo.exportLogEntries(any()),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, String?> result = await useCase(
          ExportLogEntriesParams(entries: entries),
        );

        expect(result, const Left(failure));
        verify(() => mockRepo.exportLogEntries(entries)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );
  });
}
