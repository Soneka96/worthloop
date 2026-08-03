// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Root reducer. Each feature reducer is combined here as features are built.
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    githubExplorer: githubExplorerReducer(state.githubExplorer, action),
  );
}
