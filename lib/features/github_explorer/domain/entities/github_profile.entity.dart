// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_repo.entity.dart';

/// A searched GitHub user's public profile, plus their top starred
/// repositories — the result of one search in the GitHub Explorer feature.
@immutable
class GithubProfile extends Equatable {
  /// GitHub login/handle — the primary key everywhere this is cached.
  final String username;

  /// URL of the user's avatar image.
  final String avatarUrl;

  /// Display name, or `null` if the user hasn't set one.
  final String? name;

  /// Profile bio, or `null` if the user hasn't set one.
  final String? bio;

  /// Total public repository count (not the length of [repos], which is
  /// capped to the top few by star count).
  final int publicRepos;

  /// Follower count.
  final int followers;

  /// This user's top starred public repositories, most-starred first.
  final List<GithubRepo> repos;

  /// Whether this profile is pinned in the recent-searches list.
  final bool isFavorite;

  /// When this profile was last fetched — cache reads fall back to this to
  /// show "how stale" a result is, and recent-search ordering is newest
  /// first.
  final DateTime fetchedAt;

  const GithubProfile({
    required this.username,
    required this.avatarUrl,
    required this.publicRepos,
    required this.followers,
    required this.repos,
    required this.fetchedAt,
    this.name,
    this.bio,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    username,
    avatarUrl,
    name,
    bio,
    publicRepos,
    followers,
    repos,
    isFavorite,
    fetchedAt,
  ];
}
