// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/datasources/refresh_settings_local.datasource.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Implements [IRefreshSettingsRepository] with [RefreshSettingsLocalDatasource].
class RefreshSettingsRepository implements IRefreshSettingsRepository {
  final RefreshSettingsLocalDatasource _localDatasource;

  /// Creates a repository backed by [_localDatasource].
  RefreshSettingsRepository(this._localDatasource);

  @override
  Future<Either<Failure, RefreshSettings>> loadSettings() =>
      _localDatasource.loadSettings();

  @override
  Future<Either<Failure, RefreshSettings>> saveInterval(int intervalMinutes) =>
      _localDatasource.saveInterval(intervalMinutes);

  @override
  Future<Either<Failure, RefreshSettings>> saveBrowserRefreshEnabled(
    bool enabled,
  ) => _localDatasource.saveBrowserRefreshEnabled(enabled);

  @override
  Future<Either<Failure, RefreshSettings>> savePriceDropAlertsEnabled(
    bool enabled,
  ) => _localDatasource.savePriceDropAlertsEnabled(enabled);

  @override
  Future<Either<Failure, RefreshSettings>> savePriceIncreaseAlertsEnabled(
    bool enabled,
  ) => _localDatasource.savePriceIncreaseAlertsEnabled(enabled);

  @override
  Future<Either<Failure, RefreshSettings>> saveRefreshCompletedAlertsEnabled(
    bool enabled,
  ) => _localDatasource.saveRefreshCompletedAlertsEnabled(enabled);

  @override
  Future<Either<Failure, RefreshSettings>> saveShowRefreshProgress(
    bool enabled,
  ) => _localDatasource.saveShowRefreshProgress(enabled);
}
