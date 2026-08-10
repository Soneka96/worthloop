// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';

/// Parameters for [RefreshProductUseCase].
@immutable
class RefreshProductParams extends Equatable {
  /// Identifier of the product to refresh.
  final String productId;

  const RefreshProductParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
