// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_interval.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists a refresh interval through [IRefreshSettingsRepository].
class SaveRefreshIntervalUseCase
    extends
        UseCase<Either<Failure, RefreshSettings>, SaveRefreshIntervalParams> {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SaveRefreshIntervalUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SaveRefreshIntervalParams params,
  ) => _repository.saveInterval(params.intervalMinutes);
}
