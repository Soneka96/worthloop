// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Holds the app's currently selected UI language. Registered as a DI
/// singleton and mutated in place via [setLocale] — the same shape as
/// [ChangeNotifier] singletons elsewhere in `shared/` (e.g. `AppFont`).
class AppLanguage extends ChangeNotifier {
  /// Backing field for [locale].
  AppLocale _locale;

  /// Where the current selection is persisted. `null` skips persistence
  /// entirely (e.g. in tests that don't care about it).
  final AppPreferencesStore? _preferencesStore;

  AppLanguage({this._locale = AppLocale.en, this._preferencesStore});

  /// Restores a previously persisted selection from [preferencesStore], or
  /// falls back to the constructor default ([AppLocale.en]) when nothing has
  /// been saved yet — then syncs slang's own [LocaleSettings] to match. This
  /// is the one path that must apply the restored locale for real; the bare
  /// constructor stays side-effect-free so tests can construct [AppLanguage]
  /// without touching slang's global state.
  static Future<AppLanguage> restore(
    AppPreferencesStore preferencesStore,
  ) async {
    final AppLocale? persisted = await preferencesStore.readLocale();
    final AppLanguage appLanguage = persisted == null
        ? AppLanguage(preferencesStore: preferencesStore)
        : AppLanguage(locale: persisted, preferencesStore: preferencesStore);
    LocaleSettings.setLocale(appLanguage.locale);
    return appLanguage;
  }

  /// The currently selected UI language.
  AppLocale get locale => _locale;

  /// Selects [locale] as the current UI language.
  void setLocale(AppLocale locale) {
    if (locale == _locale) {
      return;
    }
    _locale = locale;
    LocaleSettings.setLocale(locale);
    notifyListeners();
    _persist();
  }

  // Preference-write failures are silently ignored — losing a language
  // save just means it doesn't persist across restart, not worth surfacing.
  Future<void> _persist() async {
    try {
      await _preferencesStore?.writeLocale(_locale);
    } on FileSystemException {
      sl<LoggerService>().w('AppLanguage could not persist locale selection');
    }
  }
}

/// Display helpers for [AppLocale] — kept off the generated enum itself,
/// same convention as `enums.dart`'s hand-written enum extensions.
extension AppLocaleX on AppLocale {
  /// The locale's name in its own language, shown in the language picker.
  String get label => switch (this) {
    AppLocale.en => 'English',
    AppLocale.pt => 'Português',
  };
}
