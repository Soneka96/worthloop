/// Cross-cutting business constants for the logs feature.
abstract final class LogsConstants {
  /// Name of the subfolder, inside the data root, holding the `logger`
  /// package's file output.
  static const String folderName = 'logs';

  /// How long a persisted app log entry is kept before it's pruned.
  static const Duration logRetentionWindow = Duration(days: 7);

  /// Max log entries read at once for the Logs settings screen.
  static const int logReadLimit = 200;

  /// A repeat of the same alert message within this window is dropped, so a
  /// failing retry loop can't stack popups.
  static const Duration alertDedupeWindow = Duration(seconds: 10);
}

/// Cross-cutting business constants for the GitHub Explorer feature.
abstract final class GithubExplorerConstants {
  /// Base URL of GitHub's public REST API — unauthenticated reads only, no
  /// API key needed for the endpoints this feature calls.
  static const String baseUrl = 'https://api.github.com';

  /// Max repositories fetched per search, most-starred first.
  static const int repoFetchLimit = 5;

  /// Max cached searches shown in the recent-searches list.
  static const int recentSearchesLimit = 10;
}
