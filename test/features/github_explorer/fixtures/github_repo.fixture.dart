// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_repo.entity.dart';

/// Builds a [GithubRepo] with default values for every field, overridable individually.
GithubRepo buildGithubRepo({
  String name = 'test-repo',
  int stars = 10,
  String? description = 'A test repository.',
  String? language = 'Dart',
}) => GithubRepo(
  name: name,
  stars: stars,
  description: description,
  language: language,
);
