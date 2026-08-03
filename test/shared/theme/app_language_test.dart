// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_language.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  setUpAll(() {
    registerFallbackValue(AppLocale.en);
  });

  group('AppLanguage behaves correctly', () {
    late AppLanguage appLanguage;

    setUp(() {
      appLanguage = AppLanguage();
    });

    test('locale returns AppLocale.en by default', () {
      expect(appLanguage.locale, isA<AppLocale>());
      expect(appLanguage.locale, AppLocale.en);
    });

    test('setLocale updates locale when locale = AppLocale.pt', () {
      appLanguage.setLocale(AppLocale.pt);

      expect(appLanguage.locale, AppLocale.pt);
    });

    test('setLocale notifies listeners when the locale changes', () {
      int callCount = 0;
      appLanguage.addListener(() => callCount++);

      appLanguage.setLocale(AppLocale.pt);

      expect(callCount, 1);
    });

    test(
      'setLocale does not notify listeners when the locale is unchanged',
      () {
        int callCount = 0;
        appLanguage.addListener(() => callCount++);

        appLanguage.setLocale(AppLocale.en);

        expect(callCount, 0);
      },
    );
  });

  group('AppLanguage persists through AppPreferencesStore', () {
    late MockAppPreferencesStore mockPreferencesStore;
    late AppLanguage appLanguage;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
      when(
        () => mockPreferencesStore.writeLocale(any()),
      ).thenAnswer((_) async {});
      appLanguage = AppLanguage(preferencesStore: mockPreferencesStore);
    });

    test(
      'setLocale calls AppPreferencesStore.writeLocale() when the locale changes',
      () async {
        appLanguage.setLocale(AppLocale.pt);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockPreferencesStore.writeLocale(AppLocale.pt)).called(1);
      },
    );

    test(
      'setLocale does not call AppPreferencesStore.writeLocale() when the locale is unchanged',
      () async {
        appLanguage.setLocale(AppLocale.en);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockPreferencesStore.writeLocale(any()));
      },
    );
  });

  group('AppLanguage constructs correctly', () {
    late MockAppPreferencesStore mockPreferencesStore;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
    });

    test(
      'Method restore() returns AppLanguage with the constructor default when AppPreferencesStore.readLocale() returns null',
      () async {
        when(
          () => mockPreferencesStore.readLocale(),
        ).thenAnswer((_) async => null);

        final AppLanguage result = await AppLanguage.restore(
          mockPreferencesStore,
        );

        expect(result.locale, AppLocale.en);
      },
    );

    test(
      'Method restore() returns AppLanguage with the persisted selection when AppPreferencesStore.readLocale() returns a value',
      () async {
        when(
          () => mockPreferencesStore.readLocale(),
        ).thenAnswer((_) async => AppLocale.pt);

        final AppLanguage result = await AppLanguage.restore(
          mockPreferencesStore,
        );

        expect(result.locale, AppLocale.pt);
      },
    );
  });
}
