/// The narrow slice of `dart:io`'s process-spawning API needed to relaunch
/// this app as a new, detached process. Exists so callers can be tested
/// without spawning a real process.
abstract interface class IAppRelaunchGateway {
  /// Starts a new, detached instance of this app's own running executable —
  /// the first half of a full app restart. The caller is responsible for
  /// quitting the current process afterward.
  Future<void> relaunch();
}
