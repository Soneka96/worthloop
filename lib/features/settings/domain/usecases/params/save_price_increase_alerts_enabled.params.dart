// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Parameters for saving the price-increase-alert preference.
@immutable
class SavePriceIncreaseAlertsEnabledParams extends Equatable {
  /// Whether product price-increase notifications should be enabled.
  final bool enabled;

  const SavePriceIncreaseAlertsEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
