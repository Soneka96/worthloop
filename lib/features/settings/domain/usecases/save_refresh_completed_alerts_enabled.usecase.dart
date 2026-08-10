// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_completed_alerts_enabled.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists the refresh-completed-alert preference through
/// [IRefreshSettingsRepository].
class SaveRefreshCompletedAlertsEnabledUseCase
    extends
        UseCase<
          Either<Failure, RefreshSettings>,
          SaveRefreshCompletedAlertsEnabledParams
        > {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SaveRefreshCompletedAlertsEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SaveRefreshCompletedAlertsEnabledParams params,
  ) => _repository.saveRefreshCompletedAlertsEnabled(params.enabled);
}
