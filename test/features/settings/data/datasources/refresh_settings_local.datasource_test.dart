// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/datasources/refresh_settings_local.datasource.dart';
import 'package:worth_loop/features/settings/data/models/refresh_settings.model.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late AppDatabase db;
  late RefreshSettingsLocalDatasource datasource;
  late MockLoggerService mockLoggerService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    datasource = RefreshSettingsLocalDatasource(db);
    mockLoggerService = MockLoggerService();
    sl.registerSingleton<LoggerService>(mockLoggerService);
  });

  tearDown(() async {
    await db.close();
    await sl.reset();
    reset(mockLoggerService);
  });

  group('Method loadSettings() returns the correct value', () {
    test('loadSettings() returns and persists the hourly default', () async {
      final Either<Failure, RefreshSettingsModel> result = await datasource
          .loadSettings();
      final List<RefreshSettingsRow> rows = await db
          .select(db.refreshSettingsTable)
          .get();

      expect(result, const Right(RefreshSettingsModel(intervalMinutes: 60)));
      expect(rows.length, isA<int>());
      expect(rows.length, 1);
      expect(rows.single.intervalMinutes, isA<int>());
      expect(rows.single.intervalMinutes, 60);
      expect(rows.single.browserRefreshEnabled, isA<bool>());
      expect(rows.single.browserRefreshEnabled, isFalse);
      verifyZeroInteractions(mockLoggerService);
    });

    test('loadSettings() returns a previously saved interval', () async {
      await datasource.saveBrowserRefreshEnabled(true);
      await datasource.saveInterval(180);

      final Either<Failure, RefreshSettingsModel> result = await datasource
          .loadSettings();

      expect(
        result,
        const Right(
          RefreshSettingsModel(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
          ),
        ),
      );
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'loadSettings() returns Left(DatabaseFailure) when table is missing',
      () async {
        await db.customStatement('DROP TABLE refresh_settings_table');

        final Either<Failure, RefreshSettingsModel> result = await datasource
            .loadSettings();
        final Failure failure = result.fold(
          (Failure failure) => failure,
          (_) => throw StateError('Expected loadSettings() to fail'),
        );

        expect(result.isLeft(), isA<bool>());
        expect(result.isLeft(), isTrue);
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method saveInterval() returns the correct value', () {
    test('saveInterval() replaces the singleton interval', () async {
      await datasource.saveInterval(180);

      final Either<Failure, RefreshSettingsModel> result = await datasource
          .saveInterval(360);
      final RefreshSettingsRow row = await db
          .select(db.refreshSettingsTable)
          .getSingle();

      expect(result, const Right(RefreshSettingsModel(intervalMinutes: 360)));
      expect(row.intervalMinutes, isA<int>());
      expect(row.intervalMinutes, 360);
      expect(row.browserRefreshEnabled, isA<bool>());
      expect(row.browserRefreshEnabled, isFalse);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'saveInterval() returns Left(DatabaseFailure) when table is missing',
      () async {
        await db.customStatement('DROP TABLE refresh_settings_table');

        final Either<Failure, RefreshSettingsModel> result = await datasource
            .saveInterval(180);
        final Failure failure = result.fold(
          (Failure failure) => failure,
          (_) => throw StateError('Expected saveInterval() to fail'),
        );

        expect(result.isLeft(), isA<bool>());
        expect(result.isLeft(), isTrue);
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method saveBrowserRefreshEnabled() returns the correct value', () {
    test('saveBrowserRefreshEnabled() preserves the saved interval', () async {
      await datasource.saveInterval(180);

      final Either<Failure, RefreshSettingsModel> result = await datasource
          .saveBrowserRefreshEnabled(true);
      final RefreshSettingsRow row = await db
          .select(db.refreshSettingsTable)
          .getSingle();

      expect(
        result,
        const Right(
          RefreshSettingsModel(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
          ),
        ),
      );
      expect(row.intervalMinutes, 180);
      expect(row.browserRefreshEnabled, isTrue);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'saveBrowserRefreshEnabled() returns Left(DatabaseFailure) when table is missing',
      () async {
        await db.customStatement('DROP TABLE refresh_settings_table');

        final Either<Failure, RefreshSettingsModel> result = await datasource
            .saveBrowserRefreshEnabled(true);
        final Failure failure = result.fold(
          (Failure failure) => failure,
          (_) =>
              throw StateError('Expected saveBrowserRefreshEnabled() to fail'),
        );

        expect(result.isLeft(), isA<bool>());
        expect(result.isLeft(), isTrue);
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });
}
