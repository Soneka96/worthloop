// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_increase_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_increase_alerts_enabled.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockIRefreshSettingsRepository extends Mock
    implements IRefreshSettingsRepository {}

void main() {
  late MockIRefreshSettingsRepository mockRepository;
  late SavePriceIncreaseAlertsEnabledUseCase useCase;

  setUp(() {
    mockRepository = MockIRefreshSettingsRepository();
    useCase = SavePriceIncreaseAlertsEnabledUseCase(mockRepository);
  });

  group(
    'Usecase SavePriceIncreaseAlertsEnabledUseCase returns the correct value',
    () {
      test('returns Right when repository succeeds', () async {
        when(
          () => mockRepository.savePriceIncreaseAlertsEnabled(true),
        ).thenAnswer(
          (_) async =>
              Right(buildRefreshSettings(priceIncreaseAlertsEnabled: true)),
        );

        final Either<Failure, RefreshSettings> result = await useCase(
          const SavePriceIncreaseAlertsEnabledParams(enabled: true),
        );

        expect(
          result,
          Right(buildRefreshSettings(priceIncreaseAlertsEnabled: true)),
        );
        verify(
          () => mockRepository.savePriceIncreaseAlertsEnabled(true),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('returns Left when repository fails', () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockRepository.savePriceIncreaseAlertsEnabled(false),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, RefreshSettings> result = await useCase(
          const SavePriceIncreaseAlertsEnabledParams(enabled: false),
        );

        expect(result, const Left(failure));
        verify(
          () => mockRepository.savePriceIncreaseAlertsEnabled(false),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    },
  );
}
