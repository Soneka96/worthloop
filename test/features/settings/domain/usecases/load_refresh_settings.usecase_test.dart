// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockIRefreshSettingsRepository extends Mock
    implements IRefreshSettingsRepository {}

void main() {
  late MockIRefreshSettingsRepository mockRepository;
  late LoadRefreshSettingsUseCase useCase;

  setUp(() {
    mockRepository = MockIRefreshSettingsRepository();
    useCase = LoadRefreshSettingsUseCase(mockRepository);
  });

  group('Usecase LoadRefreshSettingsUseCase returns the correct value', () {
    test('returns Right when repository succeeds', () async {
      when(
        mockRepository.loadSettings,
      ).thenAnswer((_) async => Right(buildRefreshSettings()));

      final Either<Failure, RefreshSettings> result = await useCase(NoParams());

      expect(result, Right(buildRefreshSettings()));
      verify(mockRepository.loadSettings).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns Left when repository fails', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        mockRepository.loadSettings,
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, RefreshSettings> result = await useCase(NoParams());

      expect(result, const Left(failure));
      verify(mockRepository.loadSettings).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
