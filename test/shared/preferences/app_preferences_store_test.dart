// Dart imports:
import 'dart:io';
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/preferences/background_refresh_progress.dart';

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

    test('persists distinct price-alert events per product', () async {
      expect(await store.claimPriceAlertEvent('product-1', 'event-1'), isTrue);

      expect(await store.claimPriceAlertEvent('product-1', 'event-1'), isFalse);
      expect(await store.claimPriceAlertEvent('product-1', 'event-2'), isTrue);
      expect(await store.claimPriceAlertEvent('product-2', 'event-1'), isTrue);
    });

    test('persists and consumes background refresh completion once', () async {
      expect(await store.consumeBackgroundRefreshCompletion(), isNull);

      await store.markBackgroundRefreshCompleted(succeeded: false);

      expect(await store.consumeBackgroundRefreshCompletion(), isFalse);
      expect(await store.consumeBackgroundRefreshCompletion(), isNull);
    });

    test('persists and reads background refresh progress separately', () async {
      expect(await store.readBackgroundRefreshProgress(), isNull);

      final DateTime startedAt = DateTime(2026, 8, 8, 12);
      await store.writeBackgroundRefreshProgress(
        BackgroundRefreshProgress(
          status: BackgroundRefreshStatus.running,
          totalSources: 5,
          completedSources: 2,
          currentSourceId: 'source-3',
          startedAt: startedAt,
          lastProgressAt: startedAt.add(const Duration(seconds: 8)),
          errorMessage: null,
        ),
      );

      final BackgroundRefreshProgress? progress = await store
          .readBackgroundRefreshProgress();
      expect(progress?.status, BackgroundRefreshStatus.running);
      expect(progress?.totalSources, 5);
      expect(progress?.completedSources, 2);
      expect(progress?.currentSourceId, 'source-3');
      expect(progress?.startedAt, startedAt);
    });

    test(
      'replaces stale progress fields without changing preferences',
      () async {
        await store.writeZoomLevel(125);
        final DateTime startedAt = DateTime(2026, 8, 8, 12);
        await store.writeBackgroundRefreshProgress(
          BackgroundRefreshProgress(
            status: BackgroundRefreshStatus.running,
            totalSources: 5,
            completedSources: 2,
            currentSourceId: 'source-3',
            startedAt: startedAt,
            lastProgressAt: startedAt,
            errorMessage: 'old error',
          ),
        );
        await store.writeBackgroundRefreshProgress(
          BackgroundRefreshProgress(
            status: BackgroundRefreshStatus.completed,
            totalSources: 5,
            completedSources: 5,
            currentSourceId: null,
            startedAt: startedAt,
            lastProgressAt: startedAt.add(const Duration(minutes: 1)),
            errorMessage: null,
          ),
        );

        final BackgroundRefreshProgress? progress = await store
            .readBackgroundRefreshProgress();
        expect(progress?.status, BackgroundRefreshStatus.completed);
        expect(progress?.completedSources, 5);
        expect(progress?.currentSourceId, isNull);
        expect(progress?.errorMessage, isNull);
        expect(await store.readZoomLevel(), 125.0);
      },
    );

    test('returns null for malformed background progress', () async {
      final File file = File(
        '${tempDirectory.path}/background-refresh-progress.json',
      );
      await file.writeAsString('{"status":"invalid"}');

      expect(await store.readBackgroundRefreshProgress(), isNull);

      await file.writeAsString('[]');
      expect(await store.readBackgroundRefreshProgress(), isNull);
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
