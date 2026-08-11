// Package imports:
import 'package:equatable/equatable.dart';

/// Parameters for persisting the browser-refresh preference.
class SaveBrowserRefreshEnabledParams extends Equatable {
  /// Whether browser-backed background refresh should be enabled.
  final bool enabled;

  const SaveBrowserRefreshEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
