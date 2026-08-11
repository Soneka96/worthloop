// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';

/// Parameters for [DeleteSourceUseCase].
@immutable
class DeleteSourceParams extends Equatable {
  /// Identifier of the source to delete.
  final String sourceId;

  const DeleteSourceParams({required this.sourceId});

  @override
  List<Object?> get props => [sourceId];
}
