// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A merchant's decoded price offer for a product.
@immutable
class ProductOffer extends Equatable {
  /// The price in the currency's minor unit, such as cents for EUR.
  final int minorUnits;

  /// ISO 4217 currency code.
  final String currencyCode;

  /// Whether the merchant reports the product as in stock.
  final bool isAvailable;

  const ProductOffer({
    required this.minorUnits,
    required this.currencyCode,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [minorUnits, currencyCode, isAvailable];
}
