// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A product's best-price summary for a home-screen widget.
@immutable
class HomeWidgetPriceDto extends Equatable {
  /// Stable product identifier.
  final String productId;

  /// Product display name.
  final String productName;

  /// Best price in the currency's minor units.
  final int minorUnits;

  /// ISO 4217 currency code.
  final String currencyCode;

  /// Store offering the best price.
  final String storeName;

  /// When the offer was last checked.
  final DateTime updatedAt;

  const HomeWidgetPriceDto({
    required this.productId,
    required this.productName,
    required this.minorUnits,
    required this.currencyCode,
    required this.storeName,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    minorUnits,
    currencyCode,
    storeName,
    updatedAt,
  ];
}
