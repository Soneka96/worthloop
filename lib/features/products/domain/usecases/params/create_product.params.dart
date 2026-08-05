// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';

/// Parameters for [CreateProductUseCase].
@immutable
class CreateProductParams extends Equatable {
  /// Display name entered for the product.
  final String name;

  const CreateProductParams({required this.name});

  @override
  List<Object?> get props => [name];
}
