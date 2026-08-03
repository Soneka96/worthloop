// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing_presets.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Holds the app's currently selected spacing density. Registered as a DI
/// singleton and mutated in place via [setDensity] — the same shape as
/// [AppShape].
class AppSpacing extends ChangeNotifier {
  /// Backing field for [density].
  SpacingDensity _density;

  /// Where the current selection is persisted. `null` skips persistence
  /// entirely (e.g. in tests that don't care about it).
  final AppPreferencesStore? _preferencesStore;

  AppSpacing({
    this._density = SpacingDensity.comfortable,
    this._preferencesStore,
  });

  /// Restores a previously persisted selection from [preferencesStore], or
  /// falls back to the constructor default ([SpacingDensity.comfortable])
  /// when nothing has been saved yet.
  static Future<AppSpacing> restore(
    AppPreferencesStore preferencesStore,
  ) async {
    final SpacingDensity? persisted = await preferencesStore
        .readSpacingDensity();
    if (persisted == null) {
      return AppSpacing(preferencesStore: preferencesStore);
    }
    return AppSpacing(density: persisted, preferencesStore: preferencesStore);
  }

  /// The currently selected density preset.
  SpacingDensity get density => _density;

  /// The [VisualDensity] for [density], per [spacingDensityPresets].
  VisualDensity get visualDensity =>
      spacingDensityPresets[_density] ?? VisualDensity.standard;

  /// The gap sizes for [density], per [spacingValuePresets].
  AppSpacingThemeExtension get spacingValues =>
      spacingValuePresets[_density] ?? AppSpacingThemeExtension.comfortable;

  /// Selects [density] as the current preset.
  void setDensity(SpacingDensity density) {
    if (density == _density) {
      return;
    }
    _density = density;
    notifyListeners();
    _persist();
  }

  // Preference-write failures are silently ignored — losing a density save
  // just means it doesn't persist across restart, not worth surfacing.
  Future<void> _persist() async {
    try {
      await _preferencesStore?.writeSpacingDensity(_density);
    } on FileSystemException {
      sl<LoggerService>().w('AppSpacing could not persist density selection');
    }
  }
}
