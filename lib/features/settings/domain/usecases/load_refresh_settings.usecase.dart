// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Loads refresh settings through [IRefreshSettingsRepository].
class LoadRefreshSettingsUseCase
    extends UseCase<Either<Failure, RefreshSettings>, NoParams> {
  final IRefreshSettingsRepository _repository;

  /// Creates a use case backed by [_repository].
  LoadRefreshSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, RefreshSettings>> call(NoParams params) =>
      _repository.loadSettings();
}
