// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/datasources/refresh_settings_local.datasource.dart';
import 'package:worth_loop/features/settings/data/models/refresh_settings.model.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';
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
      expect(rows.single.priceDropAlertsEnabled, isA<bool>());
      expect(rows.single.priceDropAlertsEnabled, isFalse);
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
            priceDropAlertsEnabled: false,
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
      expect(row.priceDropAlertsEnabled, isFalse);
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
            priceDropAlertsEnabled: false,
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

  group('Method savePriceDropAlertsEnabled() returns the correct value', () {
    test('savePriceDropAlertsEnabled() preserves the other preferences', () async {
      await datasource.saveInterval(180);
      await datasource.saveBrowserRefreshEnabled(true);

      final Either<Failure, RefreshSettingsModel> result = await datasource
          .savePriceDropAlertsEnabled(true);
      final RefreshSettingsRow row = await db
          .select(db.refreshSettingsTable)
          .getSingle();

      expect(
        result,
        const Right(
          RefreshSettingsModel(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
            priceDropAlertsEnabled: true,
          ),
        ),
      );
      expect(row.intervalMinutes, 180);
      expect(row.browserRefreshEnabled, isTrue);
      expect(row.priceDropAlertsEnabled, isTrue);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'savePriceDropAlertsEnabled() returns Left(DatabaseFailure) when table is missing',
      () async {
        await db.customStatement('DROP TABLE refresh_settings_table');

        final Either<Failure, RefreshSettingsModel> result = await datasource
            .savePriceDropAlertsEnabled(true);
        final Failure failure = result.fold(
          (Failure failure) => failure,
          (_) => throw StateError('Expected savePriceDropAlertsEnabled() to fail'),
        );

        expect(result.isLeft(), isA<bool>());
        expect(result.isLeft(), isTrue);
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group(
    'Method savePriceIncreaseAlertsEnabled() returns the correct value',
    () {
      test(
        'savePriceIncreaseAlertsEnabled() preserves the other preferences',
        () async {
          await datasource.saveInterval(180);
          await datasource.saveBrowserRefreshEnabled(true);
          await datasource.savePriceDropAlertsEnabled(true);
          await datasource.saveRefreshCompletedAlertsEnabled(true);
          await datasource.saveShowRefreshProgress(true);

          final Either<Failure, RefreshSettingsModel> result = await datasource
              .savePriceIncreaseAlertsEnabled(true);
          final RefreshSettingsRow row = await db
              .select(db.refreshSettingsTable)
              .getSingle();

          expect(
            result,
            const Right(
              RefreshSettingsModel(
                intervalMinutes: 180,
                browserRefreshEnabled: true,
                priceDropAlertsEnabled: true,
                priceIncreaseAlertsEnabled: true,
                refreshCompletedAlertsEnabled: true,
                showRefreshProgress: true,
              ),
            ),
          );
          expect(row.intervalMinutes, 180);
          expect(row.browserRefreshEnabled, isTrue);
          expect(row.priceDropAlertsEnabled, isTrue);
          expect(row.priceIncreaseAlertsEnabled, isTrue);
          expect(row.refreshCompletedAlertsEnabled, isTrue);
          expect(row.showRefreshProgress, isTrue);
          verifyZeroInteractions(mockLoggerService);
        },
      );

      test(
        'savePriceIncreaseAlertsEnabled() defaults other preferences when no row exists yet',
        () async {
          final Either<Failure, RefreshSettingsModel> result = await datasource
              .savePriceIncreaseAlertsEnabled(true);

          expect(
            result,
            const Right(
              RefreshSettingsModel(
                intervalMinutes: RefreshIntervalConstants.hourly,
                priceIncreaseAlertsEnabled: true,
              ),
            ),
          );
        },
      );

      test(
        'savePriceIncreaseAlertsEnabled() returns Left(DatabaseFailure) when table is missing',
        () async {
          await db.customStatement('DROP TABLE refresh_settings_table');

          final Either<Failure, RefreshSettingsModel> result = await datasource
              .savePriceIncreaseAlertsEnabled(true);
          final Failure failure = result.fold(
            (Failure failure) => failure,
            (_) => throw StateError(
              'Expected savePriceIncreaseAlertsEnabled() to fail',
            ),
          );

          expect(result.isLeft(), isA<bool>());
          expect(result.isLeft(), isTrue);
          verify(() => mockLoggerService.e(failure.message)).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );
    },
  );

  group(
    'Method saveRefreshCompletedAlertsEnabled() returns the correct value',
    () {
      test(
        'saveRefreshCompletedAlertsEnabled() preserves the other preferences',
        () async {
          await datasource.saveInterval(180);
          await datasource.saveBrowserRefreshEnabled(true);
          await datasource.savePriceDropAlertsEnabled(true);
          await datasource.savePriceIncreaseAlertsEnabled(true);
          await datasource.saveShowRefreshProgress(true);

          final Either<Failure, RefreshSettingsModel> result = await datasource
              .saveRefreshCompletedAlertsEnabled(true);
          final RefreshSettingsRow row = await db
              .select(db.refreshSettingsTable)
              .getSingle();

          expect(
            result,
            const Right(
              RefreshSettingsModel(
                intervalMinutes: 180,
                browserRefreshEnabled: true,
                priceDropAlertsEnabled: true,
                priceIncreaseAlertsEnabled: true,
                refreshCompletedAlertsEnabled: true,
                showRefreshProgress: true,
              ),
            ),
          );
          expect(row.intervalMinutes, 180);
          expect(row.browserRefreshEnabled, isTrue);
          expect(row.priceDropAlertsEnabled, isTrue);
          expect(row.priceIncreaseAlertsEnabled, isTrue);
          expect(row.refreshCompletedAlertsEnabled, isTrue);
          expect(row.showRefreshProgress, isTrue);
          verifyZeroInteractions(mockLoggerService);
        },
      );

      test(
        'saveRefreshCompletedAlertsEnabled() defaults other preferences when no row exists yet',
        () async {
          final Either<Failure, RefreshSettingsModel> result = await datasource
              .saveRefreshCompletedAlertsEnabled(true);

          expect(
            result,
            const Right(
              RefreshSettingsModel(
                intervalMinutes: RefreshIntervalConstants.hourly,
                refreshCompletedAlertsEnabled: true,
              ),
            ),
          );
        },
      );

      test(
        'saveRefreshCompletedAlertsEnabled() returns Left(DatabaseFailure) when table is missing',
        () async {
          await db.customStatement('DROP TABLE refresh_settings_table');

          final Either<Failure, RefreshSettingsModel> result = await datasource
              .saveRefreshCompletedAlertsEnabled(true);
          final Failure failure = result.fold(
            (Failure failure) => failure,
            (_) => throw StateError(
              'Expected saveRefreshCompletedAlertsEnabled() to fail',
            ),
          );

          expect(result.isLeft(), isA<bool>());
          expect(result.isLeft(), isTrue);
          verify(() => mockLoggerService.e(failure.message)).called(1);
          verifyNoMoreInteractions(mockLoggerService);
        },
      );
    },
  );

  group('Method saveShowRefreshProgress() returns the correct value', () {
    test(
      'saveShowRefreshProgress() preserves the other preferences',
      () async {
        await datasource.saveInterval(180);
        await datasource.saveBrowserRefreshEnabled(true);
        await datasource.savePriceDropAlertsEnabled(true);
        await datasource.savePriceIncreaseAlertsEnabled(true);
        await datasource.saveRefreshCompletedAlertsEnabled(true);

        final Either<Failure, RefreshSettingsModel> result = await datasource
            .saveShowRefreshProgress(true);
        final RefreshSettingsRow row = await db
            .select(db.refreshSettingsTable)
            .getSingle();

        expect(
          result,
          const Right(
            RefreshSettingsModel(
              intervalMinutes: 180,
              browserRefreshEnabled: true,
              priceDropAlertsEnabled: true,
              priceIncreaseAlertsEnabled: true,
              refreshCompletedAlertsEnabled: true,
              showRefreshProgress: true,
            ),
          ),
        );
        expect(row.intervalMinutes, 180);
        expect(row.browserRefreshEnabled, isTrue);
        expect(row.priceDropAlertsEnabled, isTrue);
        expect(row.priceIncreaseAlertsEnabled, isTrue);
        expect(row.refreshCompletedAlertsEnabled, isTrue);
        expect(row.showRefreshProgress, isTrue);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'saveShowRefreshProgress() defaults other preferences when no row exists yet',
      () async {
        final Either<Failure, RefreshSettingsModel> result = await datasource
            .saveShowRefreshProgress(true);

        expect(
          result,
          const Right(
            RefreshSettingsModel(
              intervalMinutes: RefreshIntervalConstants.hourly,
              showRefreshProgress: true,
            ),
          ),
        );
      },
    );

    test(
      'saveShowRefreshProgress() returns Left(DatabaseFailure) when table is missing',
      () async {
        await db.customStatement('DROP TABLE refresh_settings_table');

        final Either<Failure, RefreshSettingsModel> result = await datasource
            .saveShowRefreshProgress(true);
        final Failure failure = result.fold(
          (Failure failure) => failure,
          (_) =>
              throw StateError('Expected saveShowRefreshProgress() to fail'),
        );

        expect(result.isLeft(), isA<bool>());
        expect(result.isLeft(), isTrue);
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });
}
