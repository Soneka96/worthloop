// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/toggle_favorite.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Flips a cached profile's pinned/favorite state. Delegates to
/// [IGithubExplorerRepository].
class ToggleFavoriteUseCase
    extends UseCase<Either<Failure, Unit>, ToggleFavoriteParams> {
  ToggleFavoriteUseCase(this._repository);

  /// Repository this use case delegates to.
  final IGithubExplorerRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ToggleFavoriteParams params) {
    return _repository.toggleFavorite(params.username);
  }
}
