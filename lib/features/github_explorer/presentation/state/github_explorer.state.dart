// Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';

/// Redux state for the GitHub Explorer feature.
@immutable
class GithubExplorerState extends Equatable {
  /// The most recently found profile, or `null` before any search succeeds.
  final GithubProfile? profile;

  /// Cached profiles, most recently searched first.
  final List<GithubProfile> recentSearches;

  /// Whether a search is currently in flight.
  final bool isSearching;

  /// The most recent search failure's message, or `null`.
  final String? error;

  const GithubExplorerState({
    required this.profile,
    required this.recentSearches,
    required this.isSearching,
    required this.error,
  });

  /// Returns the default state, used until the first search or load.
  factory GithubExplorerState.initial() => const GithubExplorerState(
    profile: null,
    recentSearches: [],
    isSearching: false,
    error: null,
  );

  /// Returns a copy with the given fields replaced. [error] takes an
  /// [Option] so it can be explicitly cleared to `null` (e.g. on a
  /// successful search) — omitting a parameter keeps its current value,
  /// which a plain `null` default can't distinguish from "clear it."
  GithubExplorerState copyWith({
    GithubProfile? profile,
    List<GithubProfile>? recentSearches,
    bool? isSearching,
    Option<String>? error,
  }) {
    return GithubExplorerState(
      profile: profile ?? this.profile,
      recentSearches: recentSearches ?? this.recentSearches,
      isSearching: isSearching ?? this.isSearching,
      error: error == null ? this.error : error.toNullable(),
    );
  }

  @override
  List<Object?> get props => [profile, recentSearches, isSearching, error];
}
