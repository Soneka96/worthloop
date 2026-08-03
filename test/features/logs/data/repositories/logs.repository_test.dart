// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/features/logs/data/models/log_entry.model.dart';
import 'package:worth_loop/features/logs/data/repositories/logs.repository.dart';
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/log_entry_model.fixture.dart';

class MockLogEntryLocalDatasource extends Mock
    implements LogEntryLocalDatasource {}

void main() {
  late MockLogEntryLocalDatasource mockLocal;
  late LogsRepository repository;

  final LogEntryModel model = buildLogEntryModel();
  const failure = DatabaseFailure('boom');

  setUp(() {
    mockLocal = MockLogEntryLocalDatasource();
    repository = LogsRepository(mockLocal);
  });

  group('LogsRepository implements the appropriate repository interface', () {
    test('LogsRepository is an implementation of ILogsRepository', () {
      expect(repository, isA<ILogsRepository>());
    });
  });

  group('LogsRepository implements loadRecentLogEntries() correctly', () {
    test(
      'Method loadRecentLogEntries() returns Right(List<LogEntry>) when the datasource returns Right(List<LogEntryModel>)',
      () async {
        when(
          () => mockLocal.loadRecentEntries(),
        ).thenAnswer((_) async => Right([model]));

        final Either<Failure, List<LogEntry>> result = await repository
            .loadRecentLogEntries();

        expect(result.isRight(), isTrue);
        result.match(
          (f) => fail('expected Right, got Left($f)'),
          (entities) => expect(entities.single.message, 'Test log message'),
        );
      },
    );

    test(
      'Method loadRecentLogEntries() returns Left(DatabaseFailure) when the datasource returns Left(DatabaseFailure)',
      () async {
        when(
          () => mockLocal.loadRecentEntries(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<LogEntry>> result = await repository
            .loadRecentLogEntries();

        expect(result, const Left(failure));
      },
    );

    test(
      'Method loadRecentLogEntries() calls LogEntryLocalDatasource.loadRecentEntries() when called',
      () async {
        when(
          () => mockLocal.loadRecentEntries(),
        ).thenAnswer((_) async => const Right([]));

        await repository.loadRecentLogEntries();

        verify(() => mockLocal.loadRecentEntries()).called(1);
        verifyNoMoreInteractions(mockLocal);
      },
    );
  });

  group('LogsRepository implements clearLogEntries() correctly', () {
    final DateTime cutoff = DateTime(2026, 1, 1, 12);

    test(
      'Method clearLogEntries() returns Right(unit) when the datasource returns Right(unit)',
      () async {
        when(
          () => mockLocal.clearEntries(any()),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await repository.clearLogEntries(
          cutoff,
        );

        expect(result, const Right(unit));
      },
    );

    test(
      'Method clearLogEntries() returns Left(DatabaseFailure) when the datasource returns Left(DatabaseFailure)',
      () async {
        when(
          () => mockLocal.clearEntries(any()),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await repository.clearLogEntries(
          cutoff,
        );

        expect(result, const Left(failure));
      },
    );

    test(
      'Method clearLogEntries() calls LogEntryLocalDatasource.clearEntries() when cutoff = the given value',
      () async {
        when(
          () => mockLocal.clearEntries(any()),
        ).thenAnswer((_) async => const Right(unit));

        await repository.clearLogEntries(cutoff);

        verify(() => mockLocal.clearEntries(cutoff)).called(1);
        verifyNoMoreInteractions(mockLocal);
      },
    );
  });

  group('LogsRepository implements exportLogEntries() correctly', () {
    test(
      'Method exportLogEntries() returns Right(path) when the datasource returns Right(path)',
      () async {
        when(
          () => mockLocal.exportEntries(any()),
        ).thenAnswer((_) async => const Right('C:/App/logs.txt'));

        final Either<Failure, String?> result = await repository
            .exportLogEntries([model]);

        expect(result, const Right('C:/App/logs.txt'));
      },
    );

    test(
      'Method exportLogEntries() returns Left(FileSystemFailure) when the datasource returns Left(FileSystemFailure)',
      () async {
        const FileSystemFailure fsFailure = FileSystemFailure('boom');
        when(
          () => mockLocal.exportEntries(any()),
        ).thenAnswer((_) async => const Left(fsFailure));

        final Either<Failure, String?> result = await repository
            .exportLogEntries([model]);

        expect(result, const Left(fsFailure));
      },
    );

    test(
      'Method exportLogEntries() calls LogEntryLocalDatasource.exportEntries() when entries = the given list',
      () async {
        when(
          () => mockLocal.exportEntries(any()),
        ).thenAnswer((_) async => const Right(null));

        await repository.exportLogEntries([model]);

        verify(() => mockLocal.exportEntries([model])).called(1);
        verifyNoMoreInteractions(mockLocal);
      },
    );
  });
}
