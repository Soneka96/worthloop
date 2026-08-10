// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/datasources/refresh_settings_local.datasource.dart';
import 'package:worth_loop/features/settings/data/repositories/refresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/refresh_settings_model.fixture.dart';

class MockRefreshSettingsLocalDatasource extends Mock
    implements RefreshSettingsLocalDatasource {}

void main() {
  late MockRefreshSettingsLocalDatasource mockDatasource;
  late RefreshSettingsRepository repository;

  setUp(() {
    mockDatasource = MockRefreshSettingsLocalDatasource();
    repository = RefreshSettingsRepository(mockDatasource);
  });

  group(
    'RefreshSettingsRepository implements the appropriate IRefreshSettingsRepository parent',
    () {
      test(
        'RefreshSettingsRepository is an implementation of IRefreshSettingsRepository',
        () {
          expect(repository, isA<IRefreshSettingsRepository>());
        },
      );
    },
  );

  group('RefreshSettingsRepository implements loadSettings() correctly', () {
    test('Method loadSettings() calls datasource loadSettings()', () async {
      final Either<Failure, RefreshSettings> expected = Right(
        buildRefreshSettingsModel(),
      );
      when(
        () => mockDatasource.loadSettings(),
      ).thenAnswer((_) async => Right(buildRefreshSettingsModel()));

      final Either<Failure, RefreshSettings> result = await repository
          .loadSettings();

      expect(result, expected);
      verify(mockDatasource.loadSettings).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('Method loadSettings() returns datasource failures', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockDatasource.loadSettings(),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, RefreshSettings> result = await repository
          .loadSettings();

      expect(result, const Left(failure));
      verify(mockDatasource.loadSettings).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });

  group('RefreshSettingsRepository implements saveInterval() correctly', () {
    test('Method saveInterval() calls datasource saveInterval()', () async {
      when(() => mockDatasource.saveInterval(180)).thenAnswer(
        (_) async => Right(buildRefreshSettingsModel(intervalMinutes: 180)),
      );

      final Either<Failure, RefreshSettings> result = await repository
          .saveInterval(180);

      expect(result, Right(buildRefreshSettingsModel(intervalMinutes: 180)));
      verify(() => mockDatasource.saveInterval(180)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('Method saveInterval() returns datasource failures', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockDatasource.saveInterval(180),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, RefreshSettings> result = await repository
          .saveInterval(180);

      expect(result, const Left(failure));
      verify(() => mockDatasource.saveInterval(180)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });

  group(
    'RefreshSettingsRepository implements saveBrowserRefreshEnabled() correctly',
    () {
      test(
        'Method saveBrowserRefreshEnabled() calls datasource saveBrowserRefreshEnabled()',
        () async {
          when(() => mockDatasource.saveBrowserRefreshEnabled(true)).thenAnswer(
            (_) async =>
                Right(buildRefreshSettingsModel(browserRefreshEnabled: true)),
          );

          final Either<Failure, RefreshSettings> result = await repository
              .saveBrowserRefreshEnabled(true);

          expect(
            result,
            Right(buildRefreshSettingsModel(browserRefreshEnabled: true)),
          );
          verify(
            () => mockDatasource.saveBrowserRefreshEnabled(true),
          ).called(1);
          verifyNoMoreInteractions(mockDatasource);
        },
      );

      test(
        'Method saveBrowserRefreshEnabled() returns datasource failures',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockDatasource.saveBrowserRefreshEnabled(false),
          ).thenAnswer((_) async => const Left(failure));

          final Either<Failure, RefreshSettings> result = await repository
              .saveBrowserRefreshEnabled(false);

          expect(result, const Left(failure));
          verify(
            () => mockDatasource.saveBrowserRefreshEnabled(false),
          ).called(1);
          verifyNoMoreInteractions(mockDatasource);
        },
      );
    },
  );

  group(
    'RefreshSettingsRepository implements savePriceDropAlertsEnabled() correctly',
    () {
      test(
        'Method savePriceDropAlertsEnabled() calls datasource savePriceDropAlertsEnabled()',
        () async {
          when(() => mockDatasource.savePriceDropAlertsEnabled(true)).thenAnswer(
            (_) async =>
                Right(buildRefreshSettingsModel(priceDropAlertsEnabled: true)),
          );

          final Either<Failure, RefreshSettings> result = await repository
              .savePriceDropAlertsEnabled(true);

          expect(
            result,
            Right(buildRefreshSettingsModel(priceDropAlertsEnabled: true)),
          );
          verify(() => mockDatasource.savePriceDropAlertsEnabled(true)).called(1);
          verifyNoMoreInteractions(mockDatasource);
        },
      );

      test(
        'Method savePriceDropAlertsEnabled() returns datasource failures',
        () async {
          const DatabaseFailure failure = DatabaseFailure('failed');
          when(
            () => mockDatasource.savePriceDropAlertsEnabled(false),
          ).thenAnswer((_) async => const Left(failure));

          final Either<Failure, RefreshSettings> result = await repository
              .savePriceDropAlertsEnabled(false);

          expect(result, const Left(failure));
          verify(() => mockDatasource.savePriceDropAlertsEnabled(false)).called(1);
          verifyNoMoreInteractions(mockDatasource);
        },
      );
    },
  );
}
