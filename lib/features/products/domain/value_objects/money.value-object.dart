// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// An exact monetary amount in a specific currency.
@immutable
class Money extends Equatable {
  /// Amount in the currency's minor unit, such as cents for EUR.
  final int minorUnits;

  /// ISO 4217 currency code.
  final String currencyCode;

  const Money({required this.minorUnits, required this.currencyCode});

  @override
  List<Object?> get props => [minorUnits, currencyCode];
}
