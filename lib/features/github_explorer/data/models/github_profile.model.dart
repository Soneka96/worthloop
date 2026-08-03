// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';
import 'package:worth_loop/features/github_explorer/domain/entities/github_repo.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// DTO mapping between [GithubProfile] and both its sources — the GitHub
/// REST API's JSON responses and a drift [GithubProfileTable] row. Extends
/// [GithubProfile] directly — no `toEntity()` mapping needed; a
/// [GithubProfileModel] already satisfies anywhere a [GithubProfile] is
/// expected.
class GithubProfileModel extends GithubProfile {
  const GithubProfileModel({
    required super.username,
    required super.avatarUrl,
    required super.publicRepos,
    required super.followers,
    required super.repos,
    required super.fetchedAt,
    super.name,
    super.bio,
    super.isFavorite,
  });

  /// Builds a [GithubProfileModel] from GitHub's `/users/{username}` and
  /// `/users/{username}/repos` response bodies. Validates each field's shape
  /// before casting, so a malformed response can only ever throw
  /// [FormatException] — never a caught [Error] type, per dart-style.md.
  factory GithubProfileModel.fromRemote({
    required Object? profileJson,
    required Object? reposJson,
    bool isFavorite = false,
  }) {
    if (profileJson is! Map<String, dynamic>) {
      throw const FormatException('Invalid GitHub profile response');
    }
    final Object? username = profileJson['login'];
    final Object? avatarUrl = profileJson['avatar_url'];
    final Object? publicRepos = profileJson['public_repos'];
    final Object? followers = profileJson['followers'];
    if (username is! String ||
        avatarUrl is! String ||
        publicRepos is! int ||
        followers is! int) {
      throw const FormatException('Invalid GitHub profile response');
    }
    final Object? name = profileJson['name'];
    final Object? bio = profileJson['bio'];

    if (reposJson is! List<dynamic>) {
      throw const FormatException('Invalid GitHub repos response');
    }

    return GithubProfileModel(
      username: username,
      avatarUrl: avatarUrl,
      name: name is String ? name : null,
      bio: bio is String ? bio : null,
      publicRepos: publicRepos,
      followers: followers,
      repos: reposJson.map(_parseRemoteRepo).toList(growable: false),
      fetchedAt: DateTime.now(),
      isFavorite: isFavorite,
    );
  }

  static GithubRepo _parseRemoteRepo(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid GitHub repo entry');
    }
    final Object? name = json['name'];
    final Object? stars = json['stargazers_count'];
    if (name is! String || stars is! int) {
      throw const FormatException('Invalid GitHub repo entry');
    }
    final Object? description = json['description'];
    final Object? language = json['language'];
    return GithubRepo(
      name: name,
      stars: stars,
      description: description is String ? description : null,
      language: language is String ? language : null,
    );
  }

  /// Builds a [GithubProfileModel] from a generated drift row, decoding
  /// [GithubProfileTable.reposJson] back into [GithubRepo]s. Validates shape
  /// the same way [fromRemote] does — the cached JSON was written by this
  /// app's own [toCompanion], but a corrupted-on-disk file must still only
  /// ever throw [FormatException], never a caught [Error] type.
  factory GithubProfileModel.fromRow(GithubProfileRow row) {
    final Object? decoded = jsonDecode(row.reposJson);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Invalid cached repos JSON');
    }
    return GithubProfileModel(
      username: row.username,
      avatarUrl: row.avatarUrl,
      name: row.name,
      bio: row.bio,
      publicRepos: row.publicRepos,
      followers: row.followers,
      repos: decoded.map(_parseCachedRepo).toList(growable: false),
      isFavorite: row.isFavorite,
      fetchedAt: row.fetchedAt,
    );
  }

  static GithubRepo _parseCachedRepo(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid cached repo entry');
    }
    final Object? name = json['name'];
    final Object? stars = json['stars'];
    if (name is! String || stars is! int) {
      throw const FormatException('Invalid cached repo entry');
    }
    final Object? description = json['description'];
    final Object? language = json['language'];
    return GithubRepo(
      name: name,
      stars: stars,
      description: description is String ? description : null,
      language: language is String ? language : null,
    );
  }

  /// Encodes this model as a drift insert-or-update companion, ready for
  /// [GithubProfileTable].
  GithubProfileTableCompanion toCompanion() =>
      GithubProfileTableCompanion.insert(
        username: username,
        avatarUrl: avatarUrl,
        name: Value(name),
        bio: Value(bio),
        publicRepos: publicRepos,
        followers: followers,
        reposJson: jsonEncode(
          repos
              .map(
                (repo) => {
                  'name': repo.name,
                  'stars': repo.stars,
                  'description': repo.description,
                  'language': repo.language,
                },
              )
              .toList(growable: false),
        ),
        isFavorite: Value(isFavorite),
        fetchedAt: fetchedAt,
      );
}
