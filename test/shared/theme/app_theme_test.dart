// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_theme_presets.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeId.none);
    registerFallbackValue(Brightness.dark);
  });

  group('AppTheme behaves correctly', () {
    late AppTheme appTheme;

    setUp(() {
      appTheme = AppTheme();
    });

    test('brightness returns Brightness.dark by default', () {
      expect(appTheme.brightness, isA<Brightness>());
      expect(appTheme.brightness, Brightness.dark);
    });

    test('darkThemeId returns ThemeId.defaultDark by default', () {
      expect(appTheme.darkThemeId, isA<ThemeId>());
      expect(appTheme.darkThemeId, ThemeId.defaultDark);
    });

    test('lightThemeId returns ThemeId.defaultLight by default', () {
      expect(appTheme.lightThemeId, isA<ThemeId>());
      expect(appTheme.lightThemeId, ThemeId.defaultLight);
    });

    test(
      'colorScheme returns themePresets[ThemeId.defaultDark] by default',
      () {
        expect(appTheme.colorScheme, themePresets[ThemeId.defaultDark]);
      },
    );

    test('setTheme updates darkThemeId when themeId = ThemeId.oneDarkPro', () {
      appTheme.setTheme(ThemeId.oneDarkPro);

      expect(appTheme.darkThemeId, ThemeId.oneDarkPro);
    });

    test(
      'setTheme does not modify lightThemeId when themeId = ThemeId.oneDarkPro',
      () {
        appTheme.setTheme(ThemeId.oneDarkPro);

        expect(appTheme.lightThemeId, ThemeId.defaultLight);
      },
    );

    test(
      'setTheme does not modify brightness when themeId = ThemeId.oneDarkPro',
      () {
        appTheme.setTheme(ThemeId.oneDarkPro);

        expect(appTheme.brightness, Brightness.dark);
      },
    );

    test(
      'setTheme updates lightThemeId when themeId = ThemeId.catppuccinLatte while brightness = Brightness.dark',
      () {
        appTheme.setTheme(ThemeId.catppuccinLatte);

        expect(appTheme.lightThemeId, ThemeId.catppuccinLatte);
      },
    );

    test(
      'setTheme does not modify colorScheme when themeId belongs to a brightness that is not currently visible',
      () {
        appTheme.setTheme(ThemeId.catppuccinLatte);

        expect(appTheme.colorScheme, themePresets[ThemeId.defaultDark]);
      },
    );

    test('setTheme notifies listeners when called', () {
      int callCount = 0;
      appTheme.addListener(() => callCount++);

      appTheme.setTheme(ThemeId.oneDarkPro);

      expect(callCount, 1);
    });

    test('setBrightness updates brightness when called', () {
      appTheme.setBrightness(Brightness.light);

      expect(appTheme.brightness, Brightness.light);
    });

    test(
      'setBrightness updates colorScheme to the light slot when brightness = Brightness.light',
      () {
        appTheme.setBrightness(Brightness.light);

        expect(appTheme.colorScheme, themePresets[ThemeId.defaultLight]);
      },
    );

    test('setBrightness does not modify darkThemeId when called', () {
      appTheme.setBrightness(Brightness.light);

      expect(appTheme.darkThemeId, ThemeId.defaultDark);
    });

    test('setBrightness does not modify lightThemeId when called', () {
      appTheme.setBrightness(Brightness.light);

      expect(appTheme.lightThemeId, ThemeId.defaultLight);
    });

    test('setBrightness notifies listeners when called', () {
      int callCount = 0;
      appTheme.addListener(() => callCount++);

      appTheme.setBrightness(Brightness.light);

      expect(callCount, 1);
    });
  });

  group('AppTheme persists through AppPreferencesStore', () {
    late MockAppPreferencesStore mockPreferencesStore;
    late AppTheme appTheme;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
      when(
        () => mockPreferencesStore.writeThemeSelection(
          darkThemeId: any(named: 'darkThemeId'),
          lightThemeId: any(named: 'lightThemeId'),
          brightness: any(named: 'brightness'),
        ),
      ).thenAnswer((_) async {});
      appTheme = AppTheme(preferencesStore: mockPreferencesStore);
    });

    test(
      'setTheme calls AppPreferencesStore.writeThemeSelection() when called',
      () async {
        appTheme.setTheme(ThemeId.oneDarkPro);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockPreferencesStore.writeThemeSelection(
            darkThemeId: ThemeId.oneDarkPro,
            lightThemeId: ThemeId.defaultLight,
            brightness: Brightness.dark,
          ),
        ).called(1);
      },
    );

    test(
      'setBrightness calls AppPreferencesStore.writeThemeSelection() when called',
      () async {
        appTheme.setBrightness(Brightness.light);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockPreferencesStore.writeThemeSelection(
            darkThemeId: ThemeId.defaultDark,
            lightThemeId: ThemeId.defaultLight,
            brightness: Brightness.light,
          ),
        ).called(1);
      },
    );
  });

  group('AppTheme constructs correctly', () {
    late MockAppPreferencesStore mockPreferencesStore;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
    });

    test(
      'Method restore() returns AppTheme with the constructor defaults when AppPreferencesStore.readThemeSelection() returns null',
      () async {
        when(
          () => mockPreferencesStore.readThemeSelection(),
        ).thenAnswer((_) async => null);

        final AppTheme result = await AppTheme.restore(mockPreferencesStore);

        expect(result.darkThemeId, ThemeId.defaultDark);
        expect(result.lightThemeId, ThemeId.defaultLight);
        expect(result.brightness, Brightness.dark);
      },
    );

    test(
      'Method restore() returns AppTheme with the persisted selection when AppPreferencesStore.readThemeSelection() returns a value',
      () async {
        when(() => mockPreferencesStore.readThemeSelection()).thenAnswer(
          (_) async => (
            darkThemeId: ThemeId.oneDarkPro,
            lightThemeId: ThemeId.catppuccinLatte,
            brightness: Brightness.light,
          ),
        );

        final AppTheme result = await AppTheme.restore(mockPreferencesStore);

        expect(result.darkThemeId, ThemeId.oneDarkPro);
        expect(result.lightThemeId, ThemeId.catppuccinLatte);
        expect(result.brightness, Brightness.light);
      },
    );
  });
}
