// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Holds the app's currently selected font-family preset. Registered as a DI
/// singleton and mutated in place via [setFont] — the same shape as
/// [ChangeNotifier] singletons elsewhere in `shared/` (e.g. [AppShape],
/// [AppZoom]).
class AppFont extends ChangeNotifier {
  /// Backing field for [fontId].
  FontId _fontId;

  /// Where the current selection is persisted. `null` skips persistence
  /// entirely (e.g. in tests that don't care about it).
  final AppPreferencesStore? _preferencesStore;

  AppFont({this._fontId = FontId.systemDefault, this._preferencesStore});

  /// Restores a previously persisted selection from [preferencesStore], or
  /// falls back to the constructor default ([FontId.systemDefault]) when
  /// nothing has been saved yet.
  static Future<AppFont> restore(AppPreferencesStore preferencesStore) async {
    final FontId? persisted = await preferencesStore.readFontId();
    if (persisted == null) {
      return AppFont(preferencesStore: preferencesStore);
    }
    return AppFont(fontId: persisted, preferencesStore: preferencesStore);
  }

  /// The currently selected font preset.
  FontId get fontId => _fontId;

  /// Selects [fontId] as the current preset.
  void setFont(FontId fontId) {
    if (fontId == _fontId) {
      return;
    }
    _fontId = fontId;
    notifyListeners();
    _persist();
  }

  // Preference-write failures are silently ignored — losing a font-preset
  // save just means it doesn't persist across restart, not worth surfacing.
  Future<void> _persist() async {
    try {
      await _preferencesStore?.writeFontId(_fontId);
    } on FileSystemException {
      sl<LoggerService>().w('AppFont could not persist font selection');
    }
  }
}
