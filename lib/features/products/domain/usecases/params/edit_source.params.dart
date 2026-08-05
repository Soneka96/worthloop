// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';

/// Parameters for [EditSourceUseCase].
@immutable
class EditSourceParams extends Equatable {
  /// Identifier of the source to update.
  final String sourceId;

  /// New HTTPS website link for the source.
  final String url;

  const EditSourceParams({required this.sourceId, required this.url});

  @override
  List<Object?> get props => [sourceId, url];
}
