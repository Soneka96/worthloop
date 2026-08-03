// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/features/github_explorer/domain/usecases/params/search_profile.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Searches for a GitHub username's profile and top repositories. Delegates
/// to [IGithubExplorerRepository].
class SearchProfileUseCase
    extends UseCase<Either<Failure, GithubProfile>, SearchProfileParams> {
  SearchProfileUseCase(this._repository);

  /// Repository this use case delegates to.
  final IGithubExplorerRepository _repository;

  @override
  Future<Either<Failure, GithubProfile>> call(SearchProfileParams params) {
    return _repository.searchProfile(params.username);
  }
}
