// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';

/// Wraps [GoRouter] and exposes typed navigation verbs.
///
/// Registered in [initDependencies]. Called only from middleware — never from a widget, Section,
/// Screen, or ViewModel directly, and never [GoRouter]/`context.go` directly either.
/// Route paths come from [AppRoutes] — never pass inline strings.
class NavigatorService {
  /// The wrapped [GoRouter] instance.
  final GoRouter _router;

  NavigatorService(this._router);

  /// Navigates to [path], replacing the current location in the history stack.
  void go(String path) => _router.go(path);

  /// Pushes [path] onto the history stack.
  void push(String path) => _router.push(path);

  /// Replaces the current route with [path] without adding to the history stack.
  void replace(String path) => _router.replace(path);

  /// Pops the top-most route off the stack.
  void pop() => _router.pop();
}
