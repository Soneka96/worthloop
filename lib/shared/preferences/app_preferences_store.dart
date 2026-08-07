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
  static const String _priceAlertEventsKey = 'priceAlertEvents';
  static const String _backgroundRefreshCompletionKey =
      'backgroundRefreshCompletion';

  /// Records that a background refresh finished, including its outcome.
  Future<void> markBackgroundRefreshCompleted({required bool succeeded}) async {
    await _updateLocked((Map<String, dynamic> data) {
      data[_backgroundRefreshCompletionKey] = <String, dynamic>{
        'succeeded': succeeded,
        'completedAt': DateTime.now().toIso8601String(),
      };
      return true;
    });
  }

  /// Consumes the completion marker left by the background engine.
  Future<bool?> consumeBackgroundRefreshCompletion() async {
    return _updateLocked((Map<String, dynamic> data) {
      final Object? value = data[_backgroundRefreshCompletionKey];
      data.remove(_backgroundRefreshCompletionKey);
      if (value is! Map<String, dynamic>) {
        return null;
      }
      return value['succeeded'] is bool ? value['succeeded'] as bool : null;
    });
  }

  /// Atomically claims [eventKey], returning `false` when it was already seen.
  Future<bool> claimPriceAlertEvent(String productId, String eventKey) async {
    return _updateLocked((Map<String, dynamic> data) {
      final Map<String, dynamic> events = _priceAlertEvents(data);
      final List<String> productEvents = _eventList(events[productId]);
      if (productEvents.contains(eventKey)) return false;
      productEvents.add(eventKey);
      events[productId] = productEvents;
      data[_priceAlertEventsKey] = events;
      return true;
    });
  }

  /// Removes a claimed event when notification delivery did not succeed.
  Future<void> releasePriceAlertEvent(String productId, String eventKey) async {
    await _updateLocked((Map<String, dynamic> data) {
      final Map<String, dynamic> events = _priceAlertEvents(data);
      final List<String> productEvents = _eventList(events[productId])
        ..remove(eventKey);
      if (productEvents.isEmpty) {
        events.remove(productId);
      } else {
        events[productId] = productEvents;
      }
      data[_priceAlertEventsKey] = events;
      return true;
    });
  }

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

  Map<String, dynamic> _priceAlertEvents(Map<String, dynamic> data) {
    final Object? value = data[_priceAlertEventsKey];
    return value is Map
        ? Map<String, dynamic>.from(value)
        : <String, dynamic>{};
  }

  List<String> _eventList(Object? value) => value is List
      ? value.whereType<String>().toList()
      : value is String
      ? [value]
      : <String>[];

  Future<T> _updateLocked<T>(
    T Function(Map<String, dynamic> data) update,
  ) async {
    final File file = await _resolveFile();
    await file.parent.create(recursive: true);
    if (!await file.exists()) await file.writeAsString('{}');
    final File lockFile = File('${file.path}.lock');
    final RandomAccessFile handle = await lockFile.open(mode: FileMode.write);
    await handle.lock();
    try {
      final Map<String, dynamic> data = await _readAll();
      final T result = update(data);
      await _writeAll(data);
      return result;
    } finally {
      await handle.unlock();
      await handle.close();
    }
  }
}
