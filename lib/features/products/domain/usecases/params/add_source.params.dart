// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';

/// Parameters for [AddSourceUseCase].
@immutable
class AddSourceParams extends Equatable {
  /// Identifier of the product this source is attached to.
  final String productId;

  /// HTTPS website link entered for the source.
  final String url;

  const AddSourceParams({required this.productId, required this.url});

  @override
  List<Object?> get props => [productId, url];
}
