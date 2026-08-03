// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Handles Home actions. Added to [CreateStore]'s middleware list — see
/// `lib/shared/state/create_store.dart`.
class HomeMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case GoToGithubExplorerAction _:
        _goToGithubExplorer();
      case GoToSettingsAction _:
        _goToSettings();
    }
  }

  /// Handles [GoToGithubExplorerAction]. Navigates to the GitHub Explorer
  /// screen.
  void _goToGithubExplorer() {
    sl<NavigatorService>().push(AppRoutes.githubExplorer);
  }

  /// Handles [GoToSettingsAction]. Navigates to the app settings screen.
  void _goToSettings() {
    sl<NavigatorService>().push(AppRoutes.appSettings);
  }
}
