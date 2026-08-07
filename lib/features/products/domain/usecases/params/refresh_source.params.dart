// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_source.usecase.dart';

/// Parameters for [RefreshSourceUseCase].
@immutable
class RefreshSourceParams extends Equatable {
  /// Identifier of the source to refresh.
  final String sourceId;

  /// Receives lifecycle updates for the source refresh.
  final SourceRefreshListener? onSourceStatusChanged;

  const RefreshSourceParams({
    required this.sourceId,
    this.onSourceStatusChanged,
  });

  @override
  List<Object?> get props => [sourceId];
}
