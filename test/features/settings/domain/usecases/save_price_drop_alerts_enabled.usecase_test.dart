// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_drop_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_drop_alerts_enabled.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockIRefreshSettingsRepository extends Mock
    implements IRefreshSettingsRepository {}

void main() {
  late MockIRefreshSettingsRepository mockRepository;
  late SavePriceDropAlertsEnabledUseCase useCase;

  setUp(() {
    mockRepository = MockIRefreshSettingsRepository();
    useCase = SavePriceDropAlertsEnabledUseCase(mockRepository);
  });

  group(
    'Usecase SavePriceDropAlertsEnabledUseCase returns the correct value',
    () {
      test('returns Right when repository succeeds', () async {
        when(() => mockRepository.savePriceDropAlertsEnabled(true)).thenAnswer(
          (_) async =>
              Right(buildRefreshSettings(priceDropAlertsEnabled: true)),
        );

        final Either<Failure, RefreshSettings> result = await useCase(
          const SavePriceDropAlertsEnabledParams(enabled: true),
        );

        expect(
          result,
          Right(buildRefreshSettings(priceDropAlertsEnabled: true)),
        );
        verify(() => mockRepository.savePriceDropAlertsEnabled(true)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('returns Left when repository fails', () async {
        const DatabaseFailure failure = DatabaseFailure('failed');
        when(
          () => mockRepository.savePriceDropAlertsEnabled(false),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, RefreshSettings> result = await useCase(
          const SavePriceDropAlertsEnabledParams(enabled: false),
        );

        expect(result, const Left(failure));
        verify(
          () => mockRepository.savePriceDropAlertsEnabled(false),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    },
  );
}
