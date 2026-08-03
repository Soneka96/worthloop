// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  group('AppZoom behaves correctly', () {
    late AppZoom appZoom;

    setUp(() {
      appZoom = AppZoom();
    });

    test('level returns 100 by default', () {
      expect(appZoom.level, isA<double>());
      expect(appZoom.level, 100.0);
    });

    test('setLevel updates level to 75 when target = 80', () {
      appZoom.setLevel(80);

      expect(appZoom.level, 75.0);
    });

    test('setLevel updates level to 100 when target = 95', () {
      appZoom.setLevel(95);

      expect(appZoom.level, 100.0);
    });

    test('setLevel notifies listeners when the nearest level changes', () {
      int callCount = 0;
      appZoom.addListener(() => callCount++);

      appZoom.setLevel(80);

      expect(callCount, 1);
    });

    test(
      'setLevel does not notify listeners when the nearest level is unchanged',
      () {
        int callCount = 0;
        appZoom.addListener(() => callCount++);

        appZoom.setLevel(97);

        expect(callCount, 0);
      },
    );
  });

  group('AppZoom persists through AppPreferencesStore', () {
    late MockAppPreferencesStore mockPreferencesStore;
    late AppZoom appZoom;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
      when(
        () => mockPreferencesStore.writeZoomLevel(any()),
      ).thenAnswer((_) async {});
      appZoom = AppZoom(preferencesStore: mockPreferencesStore);
    });

    test(
      'setLevel calls AppPreferencesStore.writeZoomLevel() when the level changes',
      () async {
        appZoom.setLevel(80);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockPreferencesStore.writeZoomLevel(75)).called(1);
      },
    );

    test(
      'setLevel does not call AppPreferencesStore.writeZoomLevel() when the level is unchanged',
      () async {
        appZoom.setLevel(97);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockPreferencesStore.writeZoomLevel(any()));
      },
    );
  });

  group('AppZoom constructs correctly', () {
    late MockAppPreferencesStore mockPreferencesStore;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
    });

    test(
      'Method restore() returns AppZoom with level 100 when AppPreferencesStore.readZoomLevel() returns null',
      () async {
        when(
          () => mockPreferencesStore.readZoomLevel(),
        ).thenAnswer((_) async => null);

        final AppZoom result = await AppZoom.restore(mockPreferencesStore);

        expect(result.level, 100.0);
      },
    );

    test(
      'Method restore() returns AppZoom with the persisted level when AppPreferencesStore.readZoomLevel() returns a value',
      () async {
        when(
          () => mockPreferencesStore.readZoomLevel(),
        ).thenAnswer((_) async => 125.0);

        final AppZoom result = await AppZoom.restore(mockPreferencesStore);

        expect(result.level, 125.0);
      },
    );
  });
}
