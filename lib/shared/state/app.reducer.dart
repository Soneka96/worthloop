// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.reducer.dart';
import 'package:worth_loop/features/logs/presentation/state/logs.reducer.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Root reducer. Each feature reducer is combined here as features are built.
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    generalSettings: generalSettingsReducer(state.generalSettings, action),
    logs: logsReducer(state.logs, action),
    githubExplorer: githubExplorerReducer(state.githubExplorer, action),
  );
}
