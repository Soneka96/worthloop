// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Brightness;

// Package imports:
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Persists app-wide display preferences as one JSON file.
class AppPreferencesStore {
  final Directory? _directoryOverride;

  /// Creates a store. Pass [directory] in tests to avoid touching the real
  /// filesystem — production code omits it and resolves the app's own
  /// support directory lazily.
  AppPreferencesStore({Directory? directory}) : _directoryOverride = directory;

  static const String _fileName = 'app-preferences.json';
  static const String _zoomLevelKey = 'zoomLevel';
  static const String _darkThemeIdKey = 'darkThemeId';
  static const String _lightThemeIdKey = 'lightThemeId';
  static const String _brightnessKey = 'brightness';
  static const String _cornerStyleKey = 'cornerStyle';
  static const String _spacingDensityKey = 'spacingDensity';
  static const String _fontIdKey = 'fontId';
  static const String _localeKey = 'locale';
  static const String _hasSeededIllustrativeProductsKey =
      'hasSeededIllustrativeProducts';

  /// Reads the persisted zoom level, or `null` if none has been saved yet.
  Future<double?> readZoomLevel() async {
    final Map<String, dynamic> data = await _readAll();
    final Object? value = data[_zoomLevelKey];
    return value is num ? value.toDouble() : null;
  }

  /// Persists [level] as the zoom level, leaving other keys untouched.
  Future<void> writeZoomLevel(double level) async {
    final Map<String, dynamic> data = await _readAll();
    data[_zoomLevelKey] = level;
    await _writeAll(data);
  }

  /// Reads the persisted theme selection, or `null` if none has been saved
  /// yet, or if a saved [ThemeId] no longer matches a known enum value.
  Future<({ThemeId darkThemeId, ThemeId lightThemeId, Brightness brightness})?>
  readThemeSelection() async {
    final Map<String, dynamic> data = await _readAll();
    final Object? darkName = data[_darkThemeIdKey];
    final Object? lightName = data[_lightThemeIdKey];
    final Object? brightnessName = data[_brightnessKey];
    if (darkName is! String ||
        lightName is! String ||
        brightnessName is! String) {
      return null;
    }
    try {
      return (
        darkThemeId: ThemeId.values.byName(darkName),
        lightThemeId: ThemeId.values.byName(lightName),
        brightness: Brightness.values.byName(brightnessName),
      );
    } on ArgumentError {
      return null;
    }
  }

  /// Persists the current theme selection, leaving other keys untouched.
  Future<void> writeThemeSelection({
    required ThemeId darkThemeId,
    required ThemeId lightThemeId,
    required Brightness brightness,
  }) async {
    final Map<String, dynamic> data = await _readAll();
    data[_darkThemeIdKey] = darkThemeId.name;
    data[_lightThemeIdKey] = lightThemeId.name;
    data[_brightnessKey] = brightness.name;
    await _writeAll(data);
  }

  /// Reads the persisted corner style, or `null` if none has been saved yet,
  /// or if the saved value no longer matches a known [CornerStyle] member.
  Future<CornerStyle?> readCornerStyle() async {
    final Map<String, dynamic> data = await _readAll();
    final Object? name = data[_cornerStyleKey];
    if (name is! String) {
      return null;
    }
    try {
      return CornerStyle.values.byName(name);
    } on ArgumentError {
      return null;
    }
  }

  /// Persists [cornerStyle], leaving other keys untouched.
  Future<void> writeCornerStyle(CornerStyle cornerStyle) async {
    final Map<String, dynamic> data = await _readAll();
    data[_cornerStyleKey] = cornerStyle.name;
    await _writeAll(data);
  }

  /// Reads the persisted spacing density, or `null` if none has been saved
  /// yet, or if the saved value no longer matches a known [SpacingDensity]
  /// member.
  Future<SpacingDensity?> readSpacingDensity() async {
    final Map<String, dynamic> data = await _readAll();
    final Object? name = data[_spacingDensityKey];
    if (name is! String) {
      return null;
    }
    try {
      return SpacingDensity.values.byName(name);
    } on ArgumentError {
      return null;
    }
  }

  /// Persists [density], leaving other keys untouched.
  Future<void> writeSpacingDensity(SpacingDensity density) async {
    final Map<String, dynamic> data = await _readAll();
    data[_spacingDensityKey] = density.name;
    await _writeAll(data);
  }

  /// Reads the persisted font preset, or `null` if none has been saved yet,
  /// or if the saved value no longer matches a known [FontId] member.
  Future<FontId?> readFontId() async {
    final Map<String, dynamic> data = await _readAll();
    final Object? name = data[_fontIdKey];
    if (name is! String) {
      return null;
    }
    try {
      return FontId.values.byName(name);
    } on ArgumentError {
      return null;
    }
  }

  /// Persists [fontId], leaving other keys untouched.
  Future<void> writeFontId(FontId fontId) async {
    final Map<String, dynamic> data = await _readAll();
    data[_fontIdKey] = fontId.name;
    await _writeAll(data);
  }

  /// Reads the persisted UI language, or `null` if none has been saved yet,
  /// or if the saved value no longer matches a known [AppLocale] member.
  Future<AppLocale?> readLocale() async {
    final Map<String, dynamic> data = await _readAll();
    final Object? name = data[_localeKey];
    if (name is! String) {
      return null;
    }
    try {
      return AppLocale.values.byName(name);
    } on ArgumentError {
      return null;
    }
  }

  /// Persists [locale], leaving other keys untouched.
  Future<void> writeLocale(AppLocale locale) async {
    final Map<String, dynamic> data = await _readAll();
    data[_localeKey] = locale.name;
    await _writeAll(data);
  }

  /// Reads whether illustrative products have ever been seeded, defaulting
  /// to `false` when unset.
  Future<bool> readHasSeededIllustrativeProducts() async {
    final Map<String, dynamic> data = await _readAll();
    return data[_hasSeededIllustrativeProductsKey] == true;
  }

  /// Marks illustrative products as seeded, leaving other keys untouched.
  Future<void> writeHasSeededIllustrativeProducts() async {
    final Map<String, dynamic> data = await _readAll();
    data[_hasSeededIllustrativeProductsKey] = true;
    await _writeAll(data);
  }

  Future<File> _resolveFile() async {
    final Directory directory =
        _directoryOverride ?? await getApplicationSupportDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<Map<String, dynamic>> _readAll() async {
    final File file = await _resolveFile();
    if (!await file.exists()) {
      return <String, dynamic>{};
    }
    try {
      final String contents = await file.readAsString();
      final Object? decoded = jsonDecode(contents);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }

  Future<void> _writeAll(Map<String, dynamic> data) async {
    final File file = await _resolveFile();
    await file.writeAsString(jsonEncode(data));
  }
}
