// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Refresh scheduling preferences.
@immutable
class RefreshSettings extends Equatable {
  /// Preferred interval in minutes.
  final int intervalMinutes;

  /// Whether browser-backed background refresh is enabled.
  final bool browserRefreshEnabled;

  /// Whether product price-drop notifications are enabled.
  final bool priceDropAlertsEnabled;

  /// Whether product price-increase notifications are enabled.
  final bool priceIncreaseAlertsEnabled;

  /// Whether a notification is shown for every completed background refresh.
  final bool refreshCompletedAlertsEnabled;

  /// Whether the background refresh shows a progress bar on its
  /// notification while sources are being fetched.
  final bool showRefreshProgress;

  const RefreshSettings({
    required this.intervalMinutes,
    this.browserRefreshEnabled = false,
    this.priceDropAlertsEnabled = false,
    this.priceIncreaseAlertsEnabled = false,
    this.refreshCompletedAlertsEnabled = false,
    this.showRefreshProgress = false,
  });

  @override
  List<Object?> get props => [
    intervalMinutes,
    browserRefreshEnabled,
    priceDropAlertsEnabled,
    priceIncreaseAlertsEnabled,
    refreshCompletedAlertsEnabled,
    showRefreshProgress,
  ];
}
