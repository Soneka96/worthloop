// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Coordinates persisted refresh settings.
abstract class IRefreshSettingsRepository {
  /// Loads refresh scheduling preferences.
  Future<Either<Failure, RefreshSettings>> loadSettings();

  /// Persists [intervalMinutes] as the preferred refresh interval.
  Future<Either<Failure, RefreshSettings>> saveInterval(int intervalMinutes);

  /// Persists whether browser-backed background refresh is enabled.
  Future<Either<Failure, RefreshSettings>> saveBrowserRefreshEnabled(
    bool enabled,
  );

  /// Persists whether product price-drop notifications are enabled.
  Future<Either<Failure, RefreshSettings>> savePriceDropAlertsEnabled(
    bool enabled,
  );

  /// Persists whether product price-increase notifications are enabled.
  Future<Either<Failure, RefreshSettings>> savePriceIncreaseAlertsEnabled(
    bool enabled,
  );

  /// Persists whether a notification is shown for every completed
  /// background refresh.
  Future<Either<Failure, RefreshSettings>> saveRefreshCompletedAlertsEnabled(
    bool enabled,
  );

  /// Persists whether the background refresh shows a progress bar on its
  /// notification while sources are being fetched.
  Future<Either<Failure, RefreshSettings>> saveShowRefreshProgress(
    bool enabled,
  );
}
