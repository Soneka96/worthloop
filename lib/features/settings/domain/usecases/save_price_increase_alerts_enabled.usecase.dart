// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_increase_alerts_enabled.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists the price-increase-alert preference through
/// [IRefreshSettingsRepository].
class SavePriceIncreaseAlertsEnabledUseCase
    extends
        UseCase<
          Either<Failure, RefreshSettings>,
          SavePriceIncreaseAlertsEnabledParams
        > {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SavePriceIncreaseAlertsEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SavePriceIncreaseAlertsEnabledParams params,
  ) => _repository.savePriceIncreaseAlertsEnabled(params.enabled);
}
