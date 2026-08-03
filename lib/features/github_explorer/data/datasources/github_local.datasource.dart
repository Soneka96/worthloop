// Package imports:
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqlite3/sqlite3.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/shared/constants/app_constants.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Local persistence for the GitHub Explorer feature — every searched
/// profile is cached here, keyed by username.
class GithubLocalDatasource {
  GithubLocalDatasource(this._db);

  /// The app's drift database connection.
  final AppDatabase _db;

  /// Inserts [profile], or overwrites the existing cached row for the same
  /// username. Returns [DatabaseFailure] on the left if the write fails.
  Future<Either<Failure, Unit>> cacheProfile(GithubProfileModel profile) async {
    try {
      await _db
          .into(_db.githubProfileTable)
          .insertOnConflictUpdate(profile.toCompanion());
      return const Right(unit);
    } on SqliteException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  /// Reads the cached profile for [username], or `null` if none is cached.
  /// Returns [DatabaseFailure] on the left if the read fails.
  Future<Either<Failure, GithubProfileModel?>> getCachedProfile(
    String username,
  ) async {
    try {
      final GithubProfileRow? row =
          await (_db.select(_db.githubProfileTable)
                ..where((t) => t.username.equals(username)))
              .getSingleOrNull();
      return Right(row == null ? null : GithubProfileModel.fromRow(row));
    } on SqliteException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  /// Loads up to [GithubExplorerConstants.recentSearchesLimit] cached
  /// profiles, most recently fetched first. Returns [DatabaseFailure] on the
  /// left if the read fails.
  Future<Either<Failure, List<GithubProfileModel>>> loadRecentSearches() async {
    try {
      final List<GithubProfileRow> rows =
          await (_db.select(_db.githubProfileTable)
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.fetchedAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(GithubExplorerConstants.recentSearchesLimit))
              .get();
      return Right(rows.map(GithubProfileModel.fromRow).toList());
    } on SqliteException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  /// Flips [username]'s cached `isFavorite` flag. A no-op if [username]
  /// isn't cached. Returns [DatabaseFailure] on the left if the write fails.
  Future<Either<Failure, Unit>> toggleFavorite(String username) async {
    try {
      final GithubProfileRow? row =
          await (_db.select(_db.githubProfileTable)
                ..where((t) => t.username.equals(username)))
              .getSingleOrNull();
      if (row == null) {
        return const Right(unit);
      }
      await (_db.update(
        _db.githubProfileTable,
      )..where((t) => t.username.equals(username))).write(
        GithubProfileTableCompanion(isFavorite: Value(!row.isFavorite)),
      );
      return const Right(unit);
    } on SqliteException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
