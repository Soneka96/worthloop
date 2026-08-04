// Package imports:
import 'package:equatable/equatable.dart';

/// Parameters for saving a refresh interval.
class SaveRefreshIntervalParams extends Equatable {
  /// Interval to persist in minutes.
  final int intervalMinutes;

  const SaveRefreshIntervalParams({required this.intervalMinutes});

  @override
  List<Object?> get props => [intervalMinutes];
}
