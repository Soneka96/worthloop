// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_drop_alerts_enabled.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists the price-drop-alert preference through
/// [IRefreshSettingsRepository].
class SavePriceDropAlertsEnabledUseCase
    extends
        UseCase<
          Either<Failure, RefreshSettings>,
          SavePriceDropAlertsEnabledParams
        > {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SavePriceDropAlertsEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SavePriceDropAlertsEnabledParams params,
  ) => _repository.savePriceDropAlertsEnabled(params.enabled);
}
