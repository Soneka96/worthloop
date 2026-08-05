// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/load_product_sources.usecase.dart';

/// Parameters for [LoadProductSourcesUseCase].
@immutable
class LoadProductSourcesParams extends Equatable {
  /// Identifier of the product whose sources are loaded.
  final String productId;

  const LoadProductSourcesParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
