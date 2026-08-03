// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/domain/entities/github_profile.entity.dart';

/// Requests searching for [username]'s GitHub profile.
@immutable
class SearchProfileAction extends Equatable {
  /// GitHub login/handle to search for.
  final String username;

  const SearchProfileAction(this.username);

  @override
  List<Object?> get props => [username];
}

/// Dispatched by middleware once a search succeeds.
@immutable
class ProfileFoundAction extends Equatable {
  /// The found profile.
  final GithubProfile profile;

  const ProfileFoundAction(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Dispatched by middleware when a search fails with nothing cached to fall
/// back to.
@immutable
class SearchFailedAction extends Equatable {
  /// The failure's message.
  final String message;

  const SearchFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests loading every cached profile, on first mount.
@immutable
class LoadRecentSearchesAction extends Equatable {
  const LoadRecentSearchesAction();

  @override
  List<Object?> get props => [];
}

/// Dispatched by middleware once cached profiles have been loaded.
@immutable
class RecentSearchesLoadedAction extends Equatable {
  /// The loaded profiles, most recently searched first.
  final List<GithubProfile> profiles;

  const RecentSearchesLoadedAction(this.profiles);

  @override
  List<Object?> get props => [profiles];
}

/// Requests flipping [username]'s pinned/favorite state.
@immutable
class ToggleFavoriteAction extends Equatable {
  /// GitHub login/handle to flip the pinned/favorite state of.
  final String username;

  const ToggleFavoriteAction(this.username);

  @override
  List<Object?> get props => [username];
}

/// Requests navigating to the app settings screen. Never handled directly by
/// a widget/viewmodel — [NavigatorService] is only ever called from
/// middleware, regardless of whether the action carries a payload.
@immutable
class GoToSettingsAction extends Equatable {
  const GoToSettingsAction();

  @override
  List<Object?> get props => [];
}

/// Requests navigating back to Home.
@immutable
class GoToHomeAction extends Equatable {
  const GoToHomeAction();

  @override
  List<Object?> get props => [];
}
