// Dart imports:
import 'dart:io';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/preferences/general_settings_snapshot.dart';

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
    test(
      'Method readZoomLevel() returns null when no file exists yet',
      () async {
        final double? result = await store.readZoomLevel();

        expect(result, isNull);
      },
    );

    test(
      'Method readZoomLevel() returns the written value when writeZoomLevel() was called first',
      () async {
        await store.writeZoomLevel(125);

        final double? result = await store.readZoomLevel();

        expect(result, isA<double>());
        expect(result, 125.0);
      },
    );

    test(
      'Method readZoomLevel() returns null when the persisted file contains invalid JSON',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString('{not valid json');

        final double? result = await store.readZoomLevel();

        expect(result, isNull);
      },
    );

    test(
      'Method readZoomLevel() returns null when the persisted file contains a JSON value that is not an object',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString('[1, 2, 3]');

        final double? result = await store.readZoomLevel();

        expect(result, isNull);
      },
    );

    test(
      'Method readWindowSize() returns null when no file exists yet',
      () async {
        final Size? result = await store.readWindowSize();

        expect(result, isNull);
      },
    );

    test(
      'Method readWindowSize() returns the written value when writeWindowSize() was called first',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        final Size? result = await store.readWindowSize();

        expect(result, isA<Size>());
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method writeZoomLevel() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeZoomLevel(88);

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method readWindowPosition() returns null when no file exists yet',
      () async {
        final Offset? result = await store.readWindowPosition();

        expect(result, isNull);
      },
    );

    test(
      'Method readWindowPosition() returns the written value when writeWindowPosition() was called first',
      () async {
        await store.writeWindowPosition(const Offset(120, 80));

        final Offset? result = await store.readWindowPosition();

        expect(result, isA<Offset>());
        expect(result, const Offset(120, 80));
      },
    );

    test(
      'Method writeWindowPosition() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeWindowPosition(const Offset(120, 80));

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method readThemeSelection() returns null when no file exists yet',
      () async {
        final ({
          ThemeId darkThemeId,
          ThemeId lightThemeId,
          Brightness brightness,
        })?
        result = await store.readThemeSelection();

        expect(result, isNull);
      },
    );

    test(
      'Method readThemeSelection() returns the written value when writeThemeSelection() was called first',
      () async {
        await store.writeThemeSelection(
          darkThemeId: ThemeId.oneDarkPro,
          lightThemeId: ThemeId.catppuccinLatte,
          brightness: Brightness.light,
        );

        final ({
          ThemeId darkThemeId,
          ThemeId lightThemeId,
          Brightness brightness,
        })?
        result = await store.readThemeSelection();
        if (result == null) {
          fail('Expected a theme selection to be returned');
        }

        expect(result.darkThemeId, ThemeId.oneDarkPro);
        expect(result.lightThemeId, ThemeId.catppuccinLatte);
        expect(result.brightness, Brightness.light);
      },
    );

    test(
      'Method readThemeSelection() returns null when a persisted ThemeId no longer matches a known enum value',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString(
          '{"darkThemeId": "retired", "lightThemeId": "catppuccinLatte", "brightness": "light"}',
        );

        final ({
          ThemeId darkThemeId,
          ThemeId lightThemeId,
          Brightness brightness,
        })?
        result = await store.readThemeSelection();

        expect(result, isNull);
      },
    );

    test(
      'Method writeThemeSelection() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeThemeSelection(
          darkThemeId: ThemeId.dracula,
          lightThemeId: ThemeId.catppuccinLatte,
          brightness: Brightness.dark,
        );

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method readCornerStyle() returns null when no file exists yet',
      () async {
        final CornerStyle? result = await store.readCornerStyle();

        expect(result, isNull);
      },
    );

    test(
      'Method readCornerStyle() returns the written value when writeCornerStyle() was called first',
      () async {
        await store.writeCornerStyle(CornerStyle.square);

        final CornerStyle? result = await store.readCornerStyle();

        expect(result, isA<CornerStyle>());
        expect(result, CornerStyle.square);
      },
    );

    test(
      'Method readCornerStyle() returns null when a persisted CornerStyle no longer matches a known enum value',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString('{"cornerStyle": "retired"}');

        final CornerStyle? result = await store.readCornerStyle();

        expect(result, isNull);
      },
    );

    test(
      'Method writeCornerStyle() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeCornerStyle(CornerStyle.square);

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method readSpacingDensity() returns null when no file exists yet',
      () async {
        final SpacingDensity? result = await store.readSpacingDensity();

        expect(result, isNull);
      },
    );

    test(
      'Method readSpacingDensity() returns the written value when writeSpacingDensity() was called first',
      () async {
        await store.writeSpacingDensity(SpacingDensity.compact);

        final SpacingDensity? result = await store.readSpacingDensity();

        expect(result, isA<SpacingDensity>());
        expect(result, SpacingDensity.compact);
      },
    );

    test(
      'Method readSpacingDensity() returns null when a persisted value no longer matches a known SpacingDensity member',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString('{"spacingDensity": "retired"}');

        final SpacingDensity? result = await store.readSpacingDensity();

        expect(result, isNull);
      },
    );

    test('Method readFontId() returns null when no file exists yet', () async {
      final FontId? result = await store.readFontId();

      expect(result, isNull);
    });

    test(
      'Method readFontId() returns the written value when writeFontId() was called first',
      () async {
        await store.writeFontId(FontId.inter);

        final FontId? result = await store.readFontId();

        expect(result, isA<FontId>());
        expect(result, FontId.inter);
      },
    );

    test(
      'Method readFontId() returns null when a persisted FontId no longer matches a known enum value',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString('{"fontId": "retired"}');

        final FontId? result = await store.readFontId();

        expect(result, isNull);
      },
    );

    test(
      'Method writeFontId() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeFontId(FontId.inter);

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test('Method readLocale() returns null when no file exists yet', () async {
      final AppLocale? result = await store.readLocale();

      expect(result, isNull);
    });

    test(
      'Method readLocale() returns the written value when writeLocale() was called first',
      () async {
        await store.writeLocale(AppLocale.pt);

        final AppLocale? result = await store.readLocale();

        expect(result, isA<AppLocale>());
        expect(result, AppLocale.pt);
      },
    );

    test(
      'Method readLocale() returns null when a persisted AppLocale no longer matches a known enum value',
      () async {
        final File file = File('${tempDirectory.path}/app-preferences.json');
        await file.writeAsString('{"locale": "retired"}');

        final AppLocale? result = await store.readLocale();

        expect(result, isNull);
      },
    );

    test(
      'Method writeLocale() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeLocale(AppLocale.pt);

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method readGeneralSettings() returns every field as null when no file exists yet',
      () async {
        final GeneralSettingsSnapshot result = await store
            .readGeneralSettings();

        expect(result.defaultSaveLocation, isNull);
        expect(result.pendingDataRoot, isNull);
      },
    );

    test(
      'Method readGeneralSettings() returns every written value in one read',
      () async {
        await store.writeDefaultSaveLocation('C:/App');
        await store.writePendingDataRoot('C:/NewApp');

        final GeneralSettingsSnapshot result = await store
            .readGeneralSettings();

        expect(result.defaultSaveLocation, 'C:/App');
        expect(result.pendingDataRoot, 'C:/NewApp');
      },
    );

    test(
      'Method writeDefaultSaveLocation() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writeDefaultSaveLocation('C:/App');

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );

    test(
      'Method readPendingDataRoot() returns null when no file exists yet',
      () async {
        final String? result = await store.readPendingDataRoot();

        expect(result, isNull);
      },
    );

    test(
      'Method readPendingDataRoot() returns the written value when writePendingDataRoot() was called first',
      () async {
        await store.writePendingDataRoot('D:/NewAppData');

        final String? result = await store.readPendingDataRoot();

        expect(result, isA<String>());
        expect(result, 'D:/NewAppData');
      },
    );

    test(
      'Method readPendingDataRoot() returns null when clearPendingDataRoot() was called after writePendingDataRoot()',
      () async {
        await store.writePendingDataRoot('D:/NewAppData');

        await store.clearPendingDataRoot();

        final String? result = await store.readPendingDataRoot();
        expect(result, isNull);
      },
    );

    test(
      'Method writePendingDataRoot() does not modify the persisted window size when one already exists',
      () async {
        await store.writeWindowSize(const Size(900, 640));

        await store.writePendingDataRoot('D:/NewAppData');

        final Size? result = await store.readWindowSize();
        expect(result, const Size(900, 640));
      },
    );
  });
}
