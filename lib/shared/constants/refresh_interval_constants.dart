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
