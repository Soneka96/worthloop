// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Coordinates the remote and local datasources for the GitHub Explorer
/// feature.
abstract class IGithubExplorerRepository {
  /// Fetches [username]'s profile and top repositories from GitHub, caching
  /// the result locally. Fail-open: if the network call fails, falls back to
  /// a previously cached copy of [username] when one exists, only
  /// surfacing the network failure when there's nothing cached to show.
  Future<Either<Failure, GithubProfile>> searchProfile(String username);

  /// Loads every cached profile, most recently fetched first.
  Future<Either<Failure, List<GithubProfile>>> loadRecentSearches();

  /// Flips [username]'s pinned/favorite state in the local cache.
  Future<Either<Failure, Unit>> toggleFavorite(String username);
}
