// Project imports:
import 'package:worth_loop/features/github_explorer/data/models/github_profile.model.dart';
import 'package:worth_loop/features/github_explorer/domain/entities/github_repo.entity.dart';

/// Builds a [GithubProfileModel] with default values for every field, overridable individually.
GithubProfileModel buildGithubProfileModel({
  String username = 'test-user',
  String avatarUrl = 'https://example.com/avatar.png',
  int publicRepos = 5,
  int followers = 3,
  List<GithubRepo> repos = const [],
  DateTime? fetchedAt,
  String? name = 'Test User',
  String? bio = 'A test bio.',
  bool isFavorite = false,
}) => GithubProfileModel(
  username: username,
  avatarUrl: avatarUrl,
  publicRepos: publicRepos,
  followers: followers,
  repos: repos,
  fetchedAt: fetchedAt ?? DateTime(2026, 1, 1, 12),
  name: name,
  bio: bio,
  isFavorite: isFavorite,
);
