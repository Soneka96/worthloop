// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/screens/github_explorer.screen.dart';
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/app_settings.screen.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/navigation/window_route_watcher.dart';

/// Creates and returns the app [GoRouter] instance.
///
/// Pass the returned router to [NavigatorService] and to [MaterialApp.router].
/// Window lock/unlock as the active route changes is wired separately via
/// [WindowRouteWatcher.attachTo] — see its own doc comment for why that
/// can't be a [NavigatorObserver] passed in here.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            Scaffold(body: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.githubExplorer,
        name: AppRoutes.githubExplorer,
        builder: (context, state) =>
            const Scaffold(body: GithubExplorerScreen()),
      ),
      GoRoute(
        path: AppRoutes.appSettings,
        name: AppRoutes.appSettings,
        builder: (context, state) => const AppSettingsScreen(),
      ),
    ],
  );
}
