// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/window/window_controller.dart';

/// Locks [WindowController] to Home's fixed size while [AppRoutes.home] is
/// the current location, and unlocks/restores it everywhere else.
///
/// Reads the router's current location directly rather than acting as a
/// [NavigatorObserver]: Home's route lives inside a [StatefulShellRoute],
/// which gives its branch its own nested [Navigator] with its own
/// [Navigator.observers] list, separate from the root one — a root-level
/// [NavigatorObserver] never sees Home's named route get pushed there.
class WindowRouteWatcher {
  /// Where lock/unlock calls are delegated.
  final WindowController _windowController;

  WindowRouteWatcher(this._windowController);

  /// Starts watching [router]'s current location, syncing immediately for
  /// whichever location it's already at.
  void attachTo(GoRouter router) {
    router.routerDelegate.addListener(() => _applyFor(router));
    _applyFor(router);
  }

  void _applyFor(GoRouter router) {
    final RouteMatchList configuration =
        router.routerDelegate.currentConfiguration;
    if (configuration.isEmpty) {
      return;
    }
    if (configuration.last.matchedLocation == AppRoutes.home) {
      _windowController.lockHome();
    } else {
      _windowController.unlockAndRestore();
    }
  }
}
