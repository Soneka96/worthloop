// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_show_refresh_progress.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists the show-refresh-progress preference through
/// [IRefreshSettingsRepository].
class SaveShowRefreshProgressUseCase
    extends
        UseCase<
          Either<Failure, RefreshSettings>,
          SaveShowRefreshProgressParams
        > {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SaveShowRefreshProgressUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SaveShowRefreshProgressParams params,
  ) => _repository.saveShowRefreshProgress(params.enabled);
}
