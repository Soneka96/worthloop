// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_theme_presets.dart';
import 'package:worth_loop/shared/theme/presets/dark/default_dark_theme.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Holds the app's currently active colour theme. Registered as a DI
/// singleton and mutated in place via [setTheme]/[setBrightness] — the same
/// shape as GoRouter's own registration, mutated via go/push/replace/pop.
///
/// Brightness and preset are independent: the app remembers a separately
/// chosen preset per brightness, and [setBrightness] only flips which one is
/// visible — it never recomputes a [ColorScheme].
class AppTheme extends ChangeNotifier {
  /// Backing field for [darkThemeId].
  ThemeId _darkThemeId;

  /// Backing field for [lightThemeId].
  ThemeId _lightThemeId;

  /// Backing field for [brightness].
  Brightness _brightness;

  /// Where the current selection is persisted. `null` skips persistence
  /// entirely (e.g. in tests that don't care about it).
  final AppPreferencesStore? _preferencesStore;

  AppTheme({
    this._darkThemeId = ThemeId.defaultDark,
    this._lightThemeId = ThemeId.defaultLight,
    this._brightness = Brightness.dark,
    this._preferencesStore,
  });

  /// Restores a previously persisted selection from [preferencesStore], or
  /// falls back to the constructor defaults when nothing has been saved yet.
  static Future<AppTheme> restore(AppPreferencesStore preferencesStore) async {
    final ({ThemeId darkThemeId, ThemeId lightThemeId, Brightness brightness})?
    selection = await preferencesStore.readThemeSelection();
    if (selection == null) {
      return AppTheme(preferencesStore: preferencesStore);
    }
    return AppTheme(
      darkThemeId: selection.darkThemeId,
      lightThemeId: selection.lightThemeId,
      brightness: selection.brightness,
      preferencesStore: preferencesStore,
    );
  }

  /// The currently visible brightness.
  Brightness get brightness => _brightness;

  /// The theme currently selected for dark mode.
  ThemeId get darkThemeId => _darkThemeId;

  /// The theme currently selected for light mode.
  ThemeId get lightThemeId => _lightThemeId;

  /// The [ColorScheme] for whichever brightness is currently visible.
  ColorScheme get colorScheme {
    final ThemeId themeId = _brightness == Brightness.dark
        ? _darkThemeId
        : _lightThemeId;
    return themePresets[themeId] ?? defaultDarkColorScheme;
  }

  /// Selects [themeId] for whichever brightness its [ColorScheme] declares —
  /// does not change which brightness is currently visible.
  void setTheme(ThemeId themeId) {
    final ColorScheme preset = themePresets[themeId] ?? defaultDarkColorScheme;
    if (preset.brightness == Brightness.light) {
      _lightThemeId = themeId;
    } else {
      _darkThemeId = themeId;
    }
    notifyListeners();
    _persist();
  }

  /// Switches which brightness's stored theme is currently visible.
  void setBrightness(Brightness brightness) {
    _brightness = brightness;
    notifyListeners();
    _persist();
  }

  // Preference-write failures are silently ignored — losing a theme
  // save just means it doesn't persist across restart, not worth surfacing.
  Future<void> _persist() async {
    try {
      await _preferencesStore?.writeThemeSelection(
        darkThemeId: _darkThemeId,
        lightThemeId: _lightThemeId,
        brightness: _brightness,
      );
    } on FileSystemException {
      sl<LoggerService>().w('AppTheme could not persist theme selection');
    }
  }
}
