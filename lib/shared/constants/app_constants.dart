/// Cross-cutting constants for user-facing alerts.
abstract final class AlertConstants {
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

/// Supported automatic-refresh intervals.
abstract final class RefreshIntervalConstants {
  /// One hour in minutes.
  static const int hourly = 60;

  /// Three hours in minutes.
  static const int everyThreeHours = 180;

  /// Six hours in minutes.
  static const int everySixHours = 360;

  /// Twelve hours in minutes.
  static const int everyTwelveHours = 720;

  /// All supported intervals.
  static const List<int> values = [
    hourly,
    everyThreeHours,
    everySixHours,
    everyTwelveHours,
  ];
}
