// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Requests navigating to the GitHub Explorer screen. Never handled directly
/// by a widget/viewmodel — [NavigatorService] is only ever called from
/// middleware, regardless of whether the action carries a payload.
@immutable
class GoToGithubExplorerAction extends Equatable {
  const GoToGithubExplorerAction();

  @override
  List<Object?> get props => [];
}

/// Requests navigating to the app settings screen.
@immutable
class GoToSettingsAction extends Equatable {
  const GoToSettingsAction();

  @override
  List<Object?> get props => [];
}
