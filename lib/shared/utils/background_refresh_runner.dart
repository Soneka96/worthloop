// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Executes one local background-refresh cycle and chooses the next delay.
class BackgroundRefreshRunner {
  final Future<Either<Failure, RefreshSettings>> Function() _loadSettings;
  final Future<Either<Failure, Unit>> Function() _refreshAllProducts;

  /// Creates a runner backed by settings and an all-products enqueue call.
  BackgroundRefreshRunner({
    required Future<Either<Failure, RefreshSettings>> Function() loadSettings,
    required Future<Either<Failure, Unit>> Function() refreshAllProducts,
  }) : _loadSettings = loadSettings,
       _refreshAllProducts = refreshAllProducts;

  /// Runs one cycle, returning `null` when the service should stop.
  ///
  /// A forced cycle refreshes once even when automatic refresh is disabled.
  Future<Duration?> runOnce({
    bool force = false,
    Future<void> Function()? onRefreshStarted,
    Future<void> Function(bool succeeded)? onRefreshOutcome,
  }) async {
    final Either<Failure, RefreshSettings> settingsResult =
        await _loadSettings();
    return settingsResult.fold(
      (_) async {
        await onRefreshStarted?.call();
        final Either<Failure, Unit> refreshResult = await _refreshAllProducts();
        await onRefreshOutcome?.call(
          refreshResult.fold((_) => false, (_) => true),
        );
        return const Duration(minutes: RefreshIntervalConstants.hourly);
      },
      (RefreshSettings settings) async {
        if (!settings.browserRefreshEnabled && !force) {
          return null;
        }
        await onRefreshStarted?.call();
        final Either<Failure, Unit> refreshResult = await _refreshAllProducts();
        await onRefreshOutcome?.call(
          refreshResult.fold((_) => false, (_) => true),
        );
        final int intervalMinutes = settings.intervalMinutes < 1
            ? RefreshIntervalConstants.hourly
            : settings.intervalMinutes;
        return Duration(minutes: intervalMinutes);
      },
    );
  }
}
