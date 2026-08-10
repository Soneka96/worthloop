// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Describes a product whose best available price moved after refresh.
@immutable
class ProductPriceChange extends Equatable {
  /// Product after the refreshed offer was persisted.
  final Product product;

  /// Best price before the refresh.
  final Money previousBestPrice;

  /// Best price after the refresh.
  final Money currentBestPrice;

  /// Which way the price moved.
  final PriceChangeDirection direction;

  const ProductPriceChange({
    required this.product,
    required this.previousBestPrice,
    required this.currentBestPrice,
    required this.direction,
  });

  @override
  List<Object?> get props => [
    product,
    previousBestPrice,
    currentBestPrice,
    direction,
  ];
}
