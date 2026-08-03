// Package imports:
import 'package:drift/drift.dart';

/// Cached GitHub profile search results — one row per searched username.
@DataClassName('GithubProfileRow')
class GithubProfileTable extends Table {
  /// GitHub login/handle — primary key, not auto-incremented.
  TextColumn get username => text()();

  /// URL of the user's avatar image.
  TextColumn get avatarUrl => text()();

  /// Display name, `null` if the user hasn't set one.
  TextColumn get name => text().nullable()();

  /// Profile bio, `null` if the user hasn't set one.
  TextColumn get bio => text().nullable()();

  /// Total public repository count.
  IntColumn get publicRepos => integer()();

  /// Follower count.
  IntColumn get followers => integer()();

  /// This user's top starred repositories, JSON-encoded — a handful of
  /// small denormalized rows per profile isn't worth a second table and
  /// join for this feature's scope.
  TextColumn get reposJson => text()();

  /// Whether this profile is pinned in the recent-searches list.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// When this profile was last fetched.
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {username};
}
