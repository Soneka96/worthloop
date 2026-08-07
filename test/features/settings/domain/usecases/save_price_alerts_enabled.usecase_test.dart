// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_alerts_enabled.usecase.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/refresh_settings.fixture.dart';

class MockIRefreshSettingsRepository extends Mock
    implements IRefreshSettingsRepository {}

void main() {
  late MockIRefreshSettingsRepository mockRepository;
  late SavePriceAlertsEnabledUseCase useCase;

  setUp(() {
    mockRepository = MockIRefreshSettingsRepository();
    useCase = SavePriceAlertsEnabledUseCase(mockRepository);
  });

  group('Usecase SavePriceAlertsEnabledUseCase returns the correct value', () {
    test('returns Right when repository succeeds', () async {
      when(() => mockRepository.savePriceAlertsEnabled(true)).thenAnswer(
        (_) async => Right(buildRefreshSettings(priceAlertsEnabled: true)),
      );

      final Either<Failure, RefreshSettings> result = await useCase(
        const SavePriceAlertsEnabledParams(enabled: true),
      );

      expect(result, Right(buildRefreshSettings(priceAlertsEnabled: true)));
      verify(() => mockRepository.savePriceAlertsEnabled(true)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns Left when repository fails', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockRepository.savePriceAlertsEnabled(false),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, RefreshSettings> result = await useCase(
        const SavePriceAlertsEnabledParams(enabled: false),
      );

      expect(result, const Left(failure));
      verify(() => mockRepository.savePriceAlertsEnabled(false)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
