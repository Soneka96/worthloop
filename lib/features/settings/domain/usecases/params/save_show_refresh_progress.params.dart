// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Parameters for saving the show-refresh-progress preference.
@immutable
class SaveShowRefreshProgressParams extends Equatable {
  /// Whether the background refresh should show a progress bar on its
  /// notification while sources are being fetched.
  final bool enabled;

  const SaveShowRefreshProgressParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
