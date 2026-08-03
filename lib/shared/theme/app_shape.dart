// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Holds the app's currently selected corner-radius preset. Registered as a
/// DI singleton and mutated in place via [setCornerStyle] — the same shape as
/// [ChangeNotifier] singletons elsewhere in `shared/` (e.g. [AppTheme],
/// [AppZoom]).
class AppShape extends ChangeNotifier {
  /// Backing field for [cornerStyle].
  CornerStyle _cornerStyle;

  /// Where the current selection is persisted. `null` skips persistence
  /// entirely (e.g. in tests that don't care about it).
  final AppPreferencesStore? _preferencesStore;

  AppShape({this._cornerStyle = CornerStyle.rounded, this._preferencesStore});

  /// Restores a previously persisted selection from [preferencesStore], or
  /// falls back to the constructor default ([CornerStyle.rounded]) when
  /// nothing has been saved yet.
  static Future<AppShape> restore(AppPreferencesStore preferencesStore) async {
    final CornerStyle? persisted = await preferencesStore.readCornerStyle();
    if (persisted == null) {
      return AppShape(preferencesStore: preferencesStore);
    }
    return AppShape(cornerStyle: persisted, preferencesStore: preferencesStore);
  }

  /// The currently selected corner-style preset.
  CornerStyle get cornerStyle => _cornerStyle;

  /// The corner radius for [cornerStyle], per [cornerRadiusPresets].
  double get cornerRadius => cornerRadiusPresets[_cornerStyle] ?? 20.0;

  /// Selects [cornerStyle] as the current preset.
  void setCornerStyle(CornerStyle cornerStyle) {
    if (cornerStyle == _cornerStyle) {
      return;
    }
    _cornerStyle = cornerStyle;
    notifyListeners();
    _persist();
  }

  // Preference-write failures are silently ignored — losing a corner-style
  // save just means it doesn't persist across restart, not worth surfacing.
  Future<void> _persist() async {
    try {
      await _preferencesStore?.writeCornerStyle(_cornerStyle);
    } on FileSystemException {
      sl<LoggerService>().w(
        'AppShape could not persist corner-style selection',
      );
    }
  }
}
