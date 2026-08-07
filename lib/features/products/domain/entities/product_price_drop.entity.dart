// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Describes a product whose best available price became lower after refresh.
@immutable
class ProductPriceDrop extends Equatable {
  /// Product after the refreshed offer was persisted.
  final Product product;

  /// Best price before the refresh.
  final Money previousBestPrice;

  /// Best price after the refresh.
  final Money currentBestPrice;

  const ProductPriceDrop({
    required this.product,
    required this.previousBestPrice,
    required this.currentBestPrice,
  });

  @override
  List<Object?> get props => [product, previousBestPrice, currentBestPrice];
}
