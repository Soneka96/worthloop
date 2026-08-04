// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/compare_prices.usecase.dart';

/// Parameters for [ComparePricesUseCase].
@immutable
class ComparePricesParams extends Equatable {
  /// Product whose available offers will be compared.
  final Product product;

  const ComparePricesParams({required this.product});

  @override
  List<Object?> get props => [product];
}
