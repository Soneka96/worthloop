// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Parameters for saving the price-drop-alert preference.
@immutable
class SavePriceDropAlertsEnabledParams extends Equatable {
  /// Whether product price-drop notifications should be enabled.
  final bool enabled;

  const SavePriceDropAlertsEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
