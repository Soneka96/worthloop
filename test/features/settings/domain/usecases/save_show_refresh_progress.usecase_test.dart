// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_show_refresh_progress.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_show_refresh_progress.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockIRefreshSettingsRepository extends Mock
    implements IRefreshSettingsRepository {}

void main() {
  late MockIRefreshSettingsRepository mockRepository;
  late SaveShowRefreshProgressUseCase useCase;

  setUp(() {
    mockRepository = MockIRefreshSettingsRepository();
    useCase = SaveShowRefreshProgressUseCase(mockRepository);
  });

  group(
    'Usecase SaveShowRefreshProgressUseCase returns the correct value',
    () {
      test('returns Right when repository succeeds', () async {
        when(
          () => mockRepository.saveShowRefreshProgress(true),
        ).thenAnswer(
          (_) async => Right(buildRefreshSettings(showRefreshProgress: true)),
        );

        final Either<Failure, RefreshSettings> result = await useCase(
          const SaveShowRefreshProgressParams(enabled: true),
        );

        expect(
          result,
          Right(buildRefreshSettings(showRefreshProgress: true)),
        );
        verify(() => mockRepository.saveShowRefreshProgress(true)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('returns Left when repository fails', () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockRepository.saveShowRefreshProgress(false),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, RefreshSettings> result = await useCase(
          const SaveShowRefreshProgressParams(enabled: false),
        );

        expect(result, const Left(failure));
        verify(() => mockRepository.saveShowRefreshProgress(false)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    },
  );
}
