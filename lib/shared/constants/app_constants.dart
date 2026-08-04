/// Cross-cutting constants for user-facing alerts.
abstract final class AlertConstants {
  /// A repeat of the same alert message within this window is dropped, so a
  /// failing retry loop can't stack popups.
  static const Duration alertDedupeWindow = Duration(seconds: 10);
}
