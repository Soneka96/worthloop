// Dart imports:
import 'dart:io';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';

void main() {
  late Directory tempDirectory;
  late AppPreferencesStore store;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('app_preferences_test');
    store = AppPreferencesStore(directory: tempDirectory);
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  group('AppPreferencesStore behaves correctly', () {
    test('returns null when no preferences file exists', () async {
      expect(await store.readZoomLevel(), isNull);
      expect(await store.readThemeSelection(), isNull);
      expect(await store.readCornerStyle(), isNull);
      expect(await store.readSpacingDensity(), isNull);
      expect(await store.readFontId(), isNull);
      expect(await store.readLocale(), isNull);
    });

    test('persists every supported preference', () async {
      await store.writeZoomLevel(125);
      await store.writeThemeSelection(
        darkThemeId: ThemeId.oneDarkPro,
        lightThemeId: ThemeId.catppuccinLatte,
        brightness: Brightness.light,
      );
      await store.writeCornerStyle(CornerStyle.square);
      await store.writeSpacingDensity(SpacingDensity.compact);
      await store.writeFontId(FontId.inter);
      await store.writeLocale(AppLocale.pt);

      final double? zoomLevel = await store.readZoomLevel();
      final ({
        ThemeId darkThemeId,
        ThemeId lightThemeId,
        Brightness brightness,
      })?
      themeSelection = await store.readThemeSelection();
      final CornerStyle? cornerStyle = await store.readCornerStyle();
      final SpacingDensity? spacingDensity = await store.readSpacingDensity();
      final FontId? fontId = await store.readFontId();
      final AppLocale? locale = await store.readLocale();

      expect(zoomLevel, isA<double>());
      expect(zoomLevel, 125.0);
      expect(themeSelection, isNotNull);
      expect(themeSelection?.darkThemeId, ThemeId.oneDarkPro);
      expect(themeSelection?.lightThemeId, ThemeId.catppuccinLatte);
      expect(themeSelection?.brightness, Brightness.light);
      expect(cornerStyle, CornerStyle.square);
      expect(spacingDensity, SpacingDensity.compact);
      expect(fontId, FontId.inter);
      expect(locale, AppLocale.pt);
    });

    test('returns null for malformed preference data', () async {
      final File file = File('${tempDirectory.path}/app-preferences.json');
      await file.writeAsString('{not valid json');

      expect(await store.readZoomLevel(), isNull);

      await file.writeAsString('[1, 2, 3]');

      expect(await store.readZoomLevel(), isNull);
    });

    test('returns null for retired enum values', () async {
      final File file = File('${tempDirectory.path}/app-preferences.json');
      await file.writeAsString(
        '{'
        '"darkThemeId":"retired",'
        '"lightThemeId":"retired",'
        '"brightness":"retired",'
        '"cornerStyle":"retired",'
        '"spacingDensity":"retired",'
        '"fontId":"retired",'
        '"locale":"retired"'
        '}',
      );

      expect(await store.readThemeSelection(), isNull);
      expect(await store.readCornerStyle(), isNull);
      expect(await store.readSpacingDensity(), isNull);
      expect(await store.readFontId(), isNull);
      expect(await store.readLocale(), isNull);
    });
  });
}
