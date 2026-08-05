// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';

/// Parameters for [DeleteProductUseCase].
@immutable
class DeleteProductParams extends Equatable {
  /// Identifier of the product to delete.
  final String productId;

  const DeleteProductParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
