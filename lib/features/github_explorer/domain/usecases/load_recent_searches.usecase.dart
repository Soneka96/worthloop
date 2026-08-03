// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Loads every cached profile, most recently searched first. Delegates to
/// [IGithubExplorerRepository].
class LoadRecentSearchesUseCase
    extends UseCase<Either<Failure, List<GithubProfile>>, NoParams> {
  LoadRecentSearchesUseCase(this._repository);

  /// Repository this use case delegates to.
  final IGithubExplorerRepository _repository;

  @override
  Future<Either<Failure, List<GithubProfile>>> call(NoParams params) {
    return _repository.loadRecentSearches();
  }
}
