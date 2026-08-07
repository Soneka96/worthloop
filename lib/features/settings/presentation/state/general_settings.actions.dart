// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';

/// Requests an update check.
@immutable
class CheckForUpdatesAction extends Equatable {
  const CheckForUpdatesAction();

  @override
  List<Object?> get props => [];
}

/// Requests opening the privacy policy.
@immutable
class OpenPrivacyPolicyAction extends Equatable {
  const OpenPrivacyPolicyAction();

  @override
  List<Object?> get props => [];
}

/// Requests loading persisted refresh settings.
@immutable
class LoadRefreshSettingsAction extends Equatable {
  const LoadRefreshSettingsAction();

  @override
  List<Object?> get props => [];
}

/// Carries persisted refresh settings.
@immutable
class RefreshSettingsLoadedAction extends Equatable {
  /// Settings loaded from persistence.
  final RefreshSettings settings;

  const RefreshSettingsLoadedAction(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Carries a refresh-settings loading failure.
@immutable
class RefreshSettingsLoadFailedAction extends Equatable {
  /// Failure message.
  final String message;

  const RefreshSettingsLoadFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests persisting a refresh interval.
@immutable
class SaveRefreshIntervalAction extends Equatable {
  /// Interval to persist in minutes.
  final int intervalMinutes;

  const SaveRefreshIntervalAction(this.intervalMinutes);

  @override
  List<Object?> get props => [intervalMinutes];
}

/// Carries a persisted refresh interval.
@immutable
class RefreshIntervalSavedAction extends Equatable {
  /// Persisted interval in minutes.
  final int intervalMinutes;

  const RefreshIntervalSavedAction(this.intervalMinutes);

  @override
  List<Object?> get props => [intervalMinutes];
}

/// Carries a refresh-interval persistence failure.
@immutable
class RefreshIntervalSaveFailedAction extends Equatable {
  /// Failure message.
  final String message;

  const RefreshIntervalSaveFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests persisting the browser-refresh preference.
@immutable
class SaveBrowserRefreshEnabledAction extends Equatable {
  /// Whether browser-backed background refresh should be enabled.
  final bool enabled;

  const SaveBrowserRefreshEnabledAction(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Carries a persisted browser-refresh preference.
@immutable
class BrowserRefreshEnabledSavedAction extends Equatable {
  /// Persisted preference value.
  final bool enabled;

  const BrowserRefreshEnabledSavedAction(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Carries a browser-refresh preference persistence failure.
@immutable
class BrowserRefreshSaveFailedAction extends Equatable {
  /// Failure message.
  final String message;

  const BrowserRefreshSaveFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests opening Android's background-restriction settings.
@immutable
class OpenBackgroundRestrictionsAction extends Equatable {
  const OpenBackgroundRestrictionsAction();

  @override
  List<Object?> get props => [];
}
