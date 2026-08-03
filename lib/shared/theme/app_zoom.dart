// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_font_presets.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Holds the app's current display zoom level. Registered as a DI singleton
/// and mutated in place via [setLevel] — the same shape as [ChangeNotifier]
/// singletons elsewhere in `shared/` (e.g. [AppTheme]).
class AppZoom extends ChangeNotifier {
  /// Backing field for [level].
  double _level;

  /// Where the current level is persisted. `null` skips persistence
  /// entirely (e.g. in tests that don't care about it).
  final AppPreferencesStore? _preferencesStore;

  AppZoom({this._level = 100, this._preferencesStore});

  /// The five zoom steps the UI can snap to.
  static const List<double> levels = [75, 88, 100, 125, 150];

  /// Multiplier applied on top of [levels] (as a fraction, alongside
  /// [fontSizeFactorPresets]'s per-font correction) so 100% itself renders
  /// at a comfortable size — Flutter's stock Material 3 type scale that
  /// "100%" maps to by default reads too small on a desktop window. Tune
  /// this one number to shift the whole 75%-150% range up or down together;
  /// the five step values above stay untouched.
  static const double baselineBump = 1.25;

  /// Restores a previously persisted level from [preferencesStore], or
  /// falls back to the constructor default (100) when nothing has been
  /// saved yet.
  static Future<AppZoom> restore(AppPreferencesStore preferencesStore) async {
    final double? persisted = await preferencesStore.readZoomLevel();
    if (persisted == null) {
      return AppZoom(preferencesStore: preferencesStore);
    }
    return AppZoom(level: persisted, preferencesStore: preferencesStore);
  }

  /// The currently active zoom level.
  double get level => _level;

  /// Snaps [target] to the nearest value in [levels] and makes it the
  /// current level. Does nothing if that's already the current level.
  void setLevel(double target) {
    final double nearest = levels.reduce(
      (a, b) => (target - a).abs() <= (target - b).abs() ? a : b,
    );
    if (nearest == _level) {
      return;
    }
    _level = nearest;
    notifyListeners();
    _persist();
  }

  // Preference-write failures are silently ignored — losing a zoom-level
  // save just means it doesn't persist across restart, not worth surfacing.
  Future<void> _persist() async {
    try {
      await _preferencesStore?.writeZoomLevel(_level);
    } on FileSystemException {
      sl<LoggerService>().w('AppZoom could not persist zoom level');
    }
  }
}
