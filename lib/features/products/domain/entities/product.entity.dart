// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';

/// An item whose merchant offers are tracked.
@immutable
class Product extends Equatable {
  /// Stable product identifier.
  final String id;

  /// Product display name.
  final String name;

  /// Optional product image URL.
  final String? imageUrl;

  /// Latest known merchant offers.
  final List<StorePrice> storePrices;

  /// When any offer for this product was last updated.
  final DateTime lastUpdatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.storePrices,
    required this.lastUpdatedAt,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, storePrices, lastUpdatedAt];
}
