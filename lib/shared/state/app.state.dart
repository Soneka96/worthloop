// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.state.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';

/// Root Redux state. Each feature adds its own sub-state here as it is built.
class AppState extends Equatable {
  /// General settings sub-state.
  final GeneralSettingsState generalSettings;

  /// Logs feature sub-state.
  final LogsState logs;

  /// GitHub Explorer feature sub-state.
  final GithubExplorerState githubExplorer;

  const AppState({
    required this.generalSettings,
    required this.logs,
    required this.githubExplorer,
  });

  /// Returns the initial state used to initialise the Redux store.
  factory AppState.initial() => AppState(
    generalSettings: GeneralSettingsState.initial(),
    logs: LogsState.initial(),
    githubExplorer: GithubExplorerState.initial(),
  );

  /// Returns a copy with the given fields replaced.
  AppState copyWith({
    GeneralSettingsState? generalSettings,
    LogsState? logs,
    GithubExplorerState? githubExplorer,
  }) {
    return AppState(
      generalSettings: generalSettings ?? this.generalSettings,
      logs: logs ?? this.logs,
      githubExplorer: githubExplorer ?? this.githubExplorer,
    );
  }

  @override
  List<Object?> get props => [generalSettings, logs, githubExplorer];
}
