// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// One of a [GithubProfile]'s public repositories.
@immutable
class GithubRepo extends Equatable {
  /// Repository name (not including the owner).
  final String name;

  /// Short description, or `null` if the repository has none.
  final String? description;

  /// Star count.
  final int stars;

  /// Primary language, or `null` if GitHub couldn't detect one.
  final String? language;

  const GithubRepo({
    required this.name,
    required this.stars,
    this.description,
    this.language,
  });

  @override
  List<Object?> get props => [name, description, stars, language];
}
