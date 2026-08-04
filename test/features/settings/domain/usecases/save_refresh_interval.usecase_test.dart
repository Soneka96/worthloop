// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_interval.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockIRefreshSettingsRepository extends Mock
    implements IRefreshSettingsRepository {}

void main() {
  late MockIRefreshSettingsRepository mockRepository;
  late SaveRefreshIntervalUseCase useCase;

  setUp(() {
    mockRepository = MockIRefreshSettingsRepository();
    useCase = SaveRefreshIntervalUseCase(mockRepository);
  });

  group('Usecase SaveRefreshIntervalUseCase returns the correct value', () {
    test('returns Right when repository succeeds', () async {
      when(() => mockRepository.saveInterval(180)).thenAnswer(
        (_) async => Right(buildRefreshSettings(intervalMinutes: 180)),
      );

      final Either<Failure, RefreshSettings> result = await useCase(
        const SaveRefreshIntervalParams(intervalMinutes: 180),
      );

      expect(result, Right(buildRefreshSettings(intervalMinutes: 180)));
      verify(() => mockRepository.saveInterval(180)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns Left when repository fails', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockRepository.saveInterval(180),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, RefreshSettings> result = await useCase(
        const SaveRefreshIntervalParams(intervalMinutes: 180),
      );

      expect(result, const Left(failure));
      verify(() => mockRepository.saveInterval(180)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
