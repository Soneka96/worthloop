/// Central registry of all route paths.
///
/// Use these constants everywhere — never write route strings inline.
abstract final class AppRoutes {
  /// The app's initial screen — a compact launcher, locked to a small window
  /// size via [WindowRouteWatcher].
  static const String home = '/';

  /// The GitHub Explorer reference feature.
  static const String githubExplorer = '/github-explorer';

  /// App-wide settings — appearance, etc.
  static const String appSettings = '/settings';
}
