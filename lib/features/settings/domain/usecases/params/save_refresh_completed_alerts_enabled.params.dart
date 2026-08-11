// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Parameters for saving the refresh-completed-alert preference.
@immutable
class SaveRefreshCompletedAlertsEnabledParams extends Equatable {
  /// Whether a notification should be shown for every completed
  /// background refresh.
  final bool enabled;

  const SaveRefreshCompletedAlertsEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
