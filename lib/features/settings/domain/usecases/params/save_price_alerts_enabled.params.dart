// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Parameters for saving the price-alert preference.
@immutable
class SavePriceAlertsEnabledParams extends Equatable {
  /// Whether product price-drop notifications should be enabled.
  final bool enabled;

  const SavePriceAlertsEnabledParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
