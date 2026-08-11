// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_browser_refresh_enabled.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Persists the browser-refresh preference through [IRefreshSettingsRepository].
class SaveBrowserRefreshEnabledUseCase
    extends
        UseCase<
          Either<Failure, RefreshSettings>,
          SaveBrowserRefreshEnabledParams
        > {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  SaveBrowserRefreshEnabledUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(
    SaveBrowserRefreshEnabledParams params,
  ) => _repository.saveBrowserRefreshEnabled(params.enabled);
}
