// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';

/// Parameters for [RenameProductUseCase].
@immutable
class RenameProductParams extends Equatable {
  /// Identifier of the product to rename.
  final String productId;

  /// New display name entered for the product.
  final String name;

  const RenameProductParams({required this.productId, required this.name});

  @override
  List<Object?> get props => [productId, name];
}
