// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_font.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  setUpAll(() {
    registerFallbackValue(FontId.none);
  });

  group('AppFont behaves correctly', () {
    late AppFont appFont;

    setUp(() {
      appFont = AppFont();
    });

    test('fontId returns FontId.systemDefault by default', () {
      expect(appFont.fontId, isA<FontId>());
      expect(appFont.fontId, FontId.systemDefault);
    });

    test('setFont updates fontId when fontId = FontId.inter', () {
      appFont.setFont(FontId.inter);

      expect(appFont.fontId, FontId.inter);
    });

    test('setFont notifies listeners when the font changes', () {
      int callCount = 0;
      appFont.addListener(() => callCount++);

      appFont.setFont(FontId.inter);

      expect(callCount, 1);
    });

    test('setFont does not notify listeners when the font is unchanged', () {
      int callCount = 0;
      appFont.addListener(() => callCount++);

      appFont.setFont(FontId.systemDefault);

      expect(callCount, 0);
    });
  });

  group('AppFont persists through AppPreferencesStore', () {
    late MockAppPreferencesStore mockPreferencesStore;
    late AppFont appFont;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
      when(
        () => mockPreferencesStore.writeFontId(any()),
      ).thenAnswer((_) async {});
      appFont = AppFont(preferencesStore: mockPreferencesStore);
    });

    test(
      'setFont calls AppPreferencesStore.writeFontId() when the font changes',
      () async {
        appFont.setFont(FontId.jetBrainsMono);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockPreferencesStore.writeFontId(FontId.jetBrainsMono),
        ).called(1);
      },
    );

    test(
      'setFont does not call AppPreferencesStore.writeFontId() when the font is unchanged',
      () async {
        appFont.setFont(FontId.systemDefault);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockPreferencesStore.writeFontId(any()));
      },
    );
  });

  group('AppFont constructs correctly', () {
    late MockAppPreferencesStore mockPreferencesStore;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
    });

    test(
      'Method restore() returns AppFont with the constructor default when AppPreferencesStore.readFontId() returns null',
      () async {
        when(
          () => mockPreferencesStore.readFontId(),
        ).thenAnswer((_) async => null);

        final AppFont result = await AppFont.restore(mockPreferencesStore);

        expect(result.fontId, FontId.systemDefault);
      },
    );

    test(
      'Method restore() returns AppFont with the persisted selection when AppPreferencesStore.readFontId() returns a value',
      () async {
        when(
          () => mockPreferencesStore.readFontId(),
        ).thenAnswer((_) async => FontId.inter);

        final AppFont result = await AppFont.restore(mockPreferencesStore);

        expect(result.fontId, FontId.inter);
      },
    );
  });
}
