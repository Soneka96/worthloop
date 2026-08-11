// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Decides whether to notify the foreground service's native host about
/// refresh progress or outcome, based on the user's notification settings.
class BackgroundRefreshNotifications {
  final Future<Either<Failure, RefreshSettings>> Function() _loadSettings;
  final Future<void> Function(String method, {Object? arguments}) _notifyEngine;

  /// Creates a notifier backed by [loadSettings] and [notifyEngine].
  BackgroundRefreshNotifications({
    required Future<Either<Failure, RefreshSettings>> Function() loadSettings,
    required Future<void> Function(String method, {Object? arguments})
    notifyEngine,
  }) : _loadSettings = loadSettings,
       _notifyEngine = notifyEngine;

  /// Notifies the native host of live progress, if the user has progress
  /// notifications enabled.
  Future<void> notifyProgress(int completed, int total) async {
    final Either<Failure, RefreshSettings> settingsResult =
        await _loadSettings();
    final bool showProgress = settingsResult.fold(
      (_) => false,
      (RefreshSettings settings) => settings.showRefreshProgress,
    );
    if (!showProgress) {
      return;
    }
    await _notifyEngine(
      'updateProgress',
      arguments: {'completed': completed, 'total': total},
    );
  }

  /// Notifies the native host that a refresh cycle finished, including
  /// whether to also show a result popup per the user's alert setting.
  Future<void> notifyOutcome(bool succeeded) async {
    final Either<Failure, RefreshSettings> settingsResult =
        await _loadSettings();
    final bool showResult = settingsResult.fold(
      (_) => false,
      (RefreshSettings settings) => settings.refreshCompletedAlertsEnabled,
    );
    await _notifyEngine(
      succeeded ? 'refreshCompleted' : 'refreshFailed',
      arguments: {'showResult': showResult},
    );
  }
}
