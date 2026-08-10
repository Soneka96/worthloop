// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_alerts_enabled.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists the price-alert preference through [IRefreshSettingsRepository].
class SavePriceAlertsEnabledUseCase
    extends
        UseCase<
          Either<Failure, RefreshSettings>,
          SavePriceAlertsEnabledParams
        > {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SavePriceAlertsEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SavePriceAlertsEnabledParams params,
  ) => _repository.savePriceDropAlertsEnabled(params.enabled);
}
