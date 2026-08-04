// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Refresh scheduling preferences.
@immutable
class RefreshSettings extends Equatable {
  /// Preferred interval in minutes.
  final int intervalMinutes;

  const RefreshSettings({required this.intervalMinutes});

  @override
  List<Object?> get props => [intervalMinutes];
}
