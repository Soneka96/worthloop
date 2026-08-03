// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/datasources/github_local.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/datasources/github_remote.datasource.dart';
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/repositories/Igithub_explorer.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Implements [IGithubExplorerRepository]. Coordinates [GithubLocalDatasource]
/// and [GithubRemoteDatasource] — fail-open: a network failure falls back to
/// a cached copy of the same username when one exists.
class GithubExplorerRepository implements IGithubExplorerRepository {
  GithubExplorerRepository(this._local, this._remote);

  /// Local datasource this repository coordinates.
  final GithubLocalDatasource _local;

  /// Remote datasource this repository coordinates.
  final GithubRemoteDatasource _remote;

  @override
  Future<Either<Failure, GithubProfile>> searchProfile(String username) async {
    return (await _remote.fetchProfile(username)).fold(
      (failure) async {
        final Either<Failure, GithubProfileModel?> cached = await _local
            .getCachedProfile(username);
        return cached.fold(
          (_) => Left(failure),
          (profile) => profile == null ? Left(failure) : Right(profile),
        );
      },
      (profile) async {
        // A cache-write failure doesn't invalidate a successful fresh
        // fetch — the caller still gets the real, current result either way.
        await _local.cacheProfile(profile);
        return Right(profile);
      },
    );
  }

  @override
  Future<Either<Failure, List<GithubProfile>>> loadRecentSearches() {
    return _local.loadRecentSearches();
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String username) {
    return _local.toggleFavorite(username);
  }
}
