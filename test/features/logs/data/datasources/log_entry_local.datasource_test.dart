// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:drift/native.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Project imports:
import 'package:worth_loop/features/logs/data/datasources/log_entry_local.datasource.dart';
import 'package:worth_loop/features/logs/data/models/log_entry.model.dart';
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

class _FakeFileSelectorPlatform extends FileSelectorPlatform
    with MockPlatformInterfaceMixin {
  FileSaveLocation? locationToReturn;
  Object? errorToThrow;
  SaveDialogOptions? lastOptions;

  @override
  Future<FileSaveLocation?> getSaveLocation({
    List<XTypeGroup>? acceptedTypeGroups,
    SaveDialogOptions options = const SaveDialogOptions(),
  }) async {
    lastOptions = options;
    if (errorToThrow != null) throw errorToThrow!;
    return locationToReturn;
  }
}

void main() {
  late AppDatabase db;
  late LogEntryLocalDatasource datasource;
  late _FakeFileSelectorPlatform fakeFileSelector;
  final FileSelectorPlatform originalFileSelector =
      FileSelectorPlatform.instance;
  late Directory tempDir;
  late MockLoggerService mockLoggerService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    datasource = LogEntryLocalDatasource(
      db,
      now: () => DateTime(2026, 1, 5, 9, 8, 7),
    );
    fakeFileSelector = _FakeFileSelectorPlatform();
    FileSelectorPlatform.instance = fakeFileSelector;
    tempDir = Directory.systemTemp.createTempSync('log_export_test');
    mockLoggerService = MockLoggerService();
    sl.registerLazySingleton<LoggerService>(() => mockLoggerService);
  });

  tearDown(() async {
    await db.close();
    FileSelectorPlatform.instance = originalFileSelector;
    tempDir.deleteSync(recursive: true);
    sl.reset();
  });

  group('Method output() behaves correctly', () {
    Future<List<LogEntryRow>> insertedRows() =>
        db.select(db.logEntryTable).get();

    test(
      'output() inserts a row with level = LogLevel.info when Level.trace',
      () async {
        datasource.output(OutputEvent(LogEvent(Level.trace, 'msg'), ['msg']));
        await Future<void>.delayed(Duration.zero);

        expect((await insertedRows()).single.level, LogLevel.info);
      },
    );

    test(
      'output() inserts a row with level = LogLevel.info when Level.debug',
      () async {
        datasource.output(OutputEvent(LogEvent(Level.debug, 'msg'), ['msg']));
        await Future<void>.delayed(Duration.zero);

        expect((await insertedRows()).single.level, LogLevel.info);
      },
    );

    test(
      'output() inserts a row with level = LogLevel.info when Level.info',
      () async {
        datasource.output(OutputEvent(LogEvent(Level.info, 'msg'), ['msg']));
        await Future<void>.delayed(Duration.zero);

        expect((await insertedRows()).single.level, LogLevel.info);
      },
    );

    test(
      'output() inserts a row with level = LogLevel.warning when Level.warning',
      () async {
        datasource.output(OutputEvent(LogEvent(Level.warning, 'msg'), ['msg']));
        await Future<void>.delayed(Duration.zero);

        expect((await insertedRows()).single.level, LogLevel.warning);
      },
    );

    test(
      'output() inserts a row with level = LogLevel.error when Level.error',
      () async {
        datasource.output(OutputEvent(LogEvent(Level.error, 'msg'), ['msg']));
        await Future<void>.delayed(Duration.zero);

        expect((await insertedRows()).single.level, LogLevel.error);
      },
    );

    test(
      'output() inserts a row with level = LogLevel.error when Level.fatal',
      () async {
        datasource.output(OutputEvent(LogEvent(Level.fatal, 'msg'), ['msg']));
        await Future<void>.delayed(Duration.zero);

        expect((await insertedRows()).single.level, LogLevel.error);
      },
    );

    test(
      'output() inserts event.origin.message as message and the joined event.lines as details',
      () async {
        datasource.output(
          OutputEvent(LogEvent(Level.info, 'the raw message'), [
            '┌─────────',
            '│ decorated line',
            '└─────────',
          ]),
        );
        await Future<void>.delayed(Duration.zero);

        final LogEntryRow row = (await insertedRows()).single;
        expect(row.message, 'the raw message');
        expect(row.details, '┌─────────\n│ decorated line\n└─────────');
      },
    );
  });

  group('Method loadRecentEntries() returns the correct value', () {
    test(
      'loadRecentEntries() returns a Right(empty list) when there are no entries',
      () async {
        final Either<Failure, List<LogEntryModel>> result = await datasource
            .loadRecentEntries();

        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => []), isEmpty);
      },
    );

    test(
      'loadRecentEntries() prunes entries older than the retention window before reading',
      () async {
        final DateTime now = DateTime.now();
        await db
            .into(db.logEntryTable)
            .insert(
              LogEntryTableCompanion.insert(
                timestamp: now.subtract(const Duration(days: 8)),
                level: LogLevel.info,
                message: 'stale',
              ),
            );
        await db
            .into(db.logEntryTable)
            .insert(
              LogEntryTableCompanion.insert(
                timestamp: now.subtract(const Duration(days: 1)),
                level: LogLevel.info,
                message: 'fresh',
              ),
            );

        final Either<Failure, List<LogEntryModel>> result = await datasource
            .loadRecentEntries();
        final List<LogEntryModel> entries = result.getOrElse((_) => []);

        expect(entries, hasLength(1));
        expect(entries.single.message, 'fresh');

        final List<LogEntryRow> remainingRows = await db
            .select(db.logEntryTable)
            .get();
        expect(
          remainingRows,
          hasLength(1),
          reason:
              'the stale row should have been deleted, not just filtered out of the read',
        );
      },
    );

    test('loadRecentEntries() respects the limit when limit = 1', () async {
      final DateTime now = DateTime.now();
      await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: now,
              level: LogLevel.info,
              message: 'first',
            ),
          );
      await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: now,
              level: LogLevel.info,
              message: 'second',
            ),
          );

      final Either<Failure, List<LogEntryModel>> result = await datasource
          .loadRecentEntries(limit: 1);

      expect(result.getOrElse((_) => []), hasLength(1));
    });

    test('loadRecentEntries() orders by timestamp descending', () async {
      await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: DateTime.now().subtract(const Duration(hours: 1)),
              level: LogLevel.info,
              message: 'older',
            ),
          );
      await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: DateTime.now(),
              level: LogLevel.info,
              message: 'newer',
            ),
          );

      final Either<Failure, List<LogEntryModel>> result = await datasource
          .loadRecentEntries();
      final List<LogEntryModel> entries = result.getOrElse((_) => []);

      expect(entries.first.message, 'newer');
      expect(entries.last.message, 'older');
    });

    test(
      'loadRecentEntries() returns a Left(DatabaseFailure) when the table is missing',
      () async {
        await db.customStatement('DROP TABLE log_entry_table');

        final Either<Failure, List<LogEntryModel>> result = await datasource
            .loadRecentEntries();

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<DatabaseFailure>()),
          (entries) => fail('expected Left, got Right($entries)'),
        );
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });

  group('Method clearEntries() returns the correct value', () {
    test(
      'clearEntries() deletes a row timestamped exactly at cutoff',
      () async {
        final DateTime cutoff = DateTime.now();
        await db
            .into(db.logEntryTable)
            .insert(
              LogEntryTableCompanion.insert(
                timestamp: cutoff,
                level: LogLevel.info,
                message: 'at cutoff',
              ),
            );

        await datasource.clearEntries(cutoff);

        expect(await db.select(db.logEntryTable).get(), isEmpty);
      },
    );

    test('clearEntries() deletes a row timestamped before cutoff', () async {
      final DateTime cutoff = DateTime.now();
      await db
          .into(db.logEntryTable)
          .insert(
            LogEntryTableCompanion.insert(
              timestamp: cutoff.subtract(const Duration(seconds: 1)),
              level: LogLevel.info,
              message: 'before cutoff',
            ),
          );

      await datasource.clearEntries(cutoff);

      expect(await db.select(db.logEntryTable).get(), isEmpty);
    });

    test(
      'clearEntries() does not delete a row timestamped after cutoff, so an entry logged during the clear operation survives',
      () async {
        final DateTime cutoff = DateTime.now();
        await db
            .into(db.logEntryTable)
            .insert(
              LogEntryTableCompanion.insert(
                timestamp: cutoff.add(const Duration(seconds: 1)),
                level: LogLevel.info,
                message: 'after cutoff',
              ),
            );

        await datasource.clearEntries(cutoff);

        final List<LogEntryRow> rows = await db.select(db.logEntryTable).get();
        expect(rows, hasLength(1));
        expect(rows.single.message, 'after cutoff');
      },
    );

    test('clearEntries() succeeds when the table is empty', () async {
      final Either<Failure, Unit> result = await datasource.clearEntries(
        DateTime.now(),
      );

      expect(result.isRight(), isTrue);
    });

    test(
      'clearEntries() returns a Left(DatabaseFailure) when the table is missing',
      () async {
        await db.customStatement('DROP TABLE log_entry_table');

        final Either<Failure, Unit> result = await datasource.clearEntries(
          DateTime.now(),
        );

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<DatabaseFailure>()),
          (_) => fail('expected Left, got Right(unit)'),
        );
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });

  group('Method exportEntries() returns the correct value', () {
    test(
      'exportEntries() suggests a filename built from now() with a .log extension',
      () async {
        fakeFileSelector.locationToReturn = null;

        await datasource.exportEntries([]);

        expect(
          fakeFileSelector.lastOptions?.suggestedName,
          'app-2026-01-05_09-08-07.log',
        );
      },
    );

    test(
      'exportEntries() returns a Right(null) when the user cancels',
      () async {
        fakeFileSelector.locationToReturn = null;

        final Either<Failure, String?> result = await datasource.exportEntries(
          [],
        );

        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => 'unexpected'), isNull);
      },
    );

    test(
      'exportEntries() writes entry.message when details == null and returns a Right(path) when a location is chosen',
      () async {
        final String path = '${tempDir.path}/logs.txt';
        fakeFileSelector.locationToReturn = FileSaveLocation(path);

        final Either<Failure, String?> result = await datasource.exportEntries([
          LogEntry(
            timestamp: DateTime(2026, 1, 1, 12),
            level: LogLevel.error,
            message: 'File 12 failed',
          ),
        ]);

        expect(result.getOrElse((_) => null), path);
        expect(File(path).readAsStringSync(), contains('File 12 failed'));
      },
    );

    test(
      'exportEntries() writes entry.details instead of entry.message when details != null',
      () async {
        final String path = '${tempDir.path}/logs.txt';
        fakeFileSelector.locationToReturn = FileSaveLocation(path);

        await datasource.exportEntries([
          LogEntry(
            timestamp: DateTime(2026, 1, 1, 12),
            level: LogLevel.error,
            message: 'File 12 failed',
            details: 'decorated File 12 failed',
          ),
        ]);

        expect(
          File(path).readAsStringSync(),
          '${DateTime(2026, 1, 1, 12)} [error] decorated File 12 failed',
        );
      },
    );

    test(
      'exportEntries() returns a Left(FileSystemFailure) when the picker throws',
      () async {
        fakeFileSelector.errorToThrow = PlatformException(code: 'picker_error');

        final Either<Failure, String?> result = await datasource.exportEntries(
          [],
        );

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<FileSystemFailure>()),
          (path) => fail('expected Left, got Right($path)'),
        );
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });
}
