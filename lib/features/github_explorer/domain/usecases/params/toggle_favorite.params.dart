// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/usecases/toggle_favorite.usecase.dart';

/// Parameters for [ToggleFavoriteUseCase].
@immutable
class ToggleFavoriteParams extends Equatable {
  /// GitHub login/handle to flip the pinned/favorite state of.
  final String username;

  const ToggleFavoriteParams({required this.username});

  @override
  List<Object?> get props => [username];
}
