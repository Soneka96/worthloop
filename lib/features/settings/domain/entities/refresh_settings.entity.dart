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

  const RefreshSettings({
    required this.intervalMinutes,
    this.browserRefreshEnabled = false,
  });

  @override
  List<Object?> get props => [intervalMinutes, browserRefreshEnabled];
}
