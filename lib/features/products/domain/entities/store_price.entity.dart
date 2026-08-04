// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// A merchant's latest offer for a tracked product.
@immutable
class StorePrice extends Equatable {
  /// Merchant display name.
  final String storeName;

  /// Merchant page where the product offer can be found.
  final String productUrl;

  /// Latest checked product price.
  final Money currentPrice;

  /// Whether the merchant currently has the product available.
  final bool isAvailable;

  /// When this offer was last checked.
  final DateTime lastCheckedAt;

  const StorePrice({
    required this.storeName,
    required this.productUrl,
    required this.currentPrice,
    required this.isAvailable,
    required this.lastCheckedAt,
  });

  @override
  List<Object?> get props => [
    storeName,
    productUrl,
    currentPrice,
    isAvailable,
    lastCheckedAt,
  ];
}
