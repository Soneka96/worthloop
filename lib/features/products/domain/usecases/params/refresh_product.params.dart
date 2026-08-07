// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';

/// Parameters for [RefreshProductUseCase].
@immutable
class RefreshProductParams extends Equatable {
  /// Identifier of the product to refresh.
  final String productId;

  /// Receives lifecycle updates for each source refresh.
  final SourceRefreshListener? onSourceStatusChanged;

  const RefreshProductParams({
    required this.productId,
    this.onSourceStatusChanged,
  });

  @override
  List<Object?> get props => [productId];
}
