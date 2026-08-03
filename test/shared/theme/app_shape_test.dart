// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  setUpAll(() {
    registerFallbackValue(CornerStyle.none);
  });

  group('AppShape behaves correctly', () {
    late AppShape appShape;

    setUp(() {
      appShape = AppShape();
    });

    test('cornerStyle returns CornerStyle.rounded by default', () {
      expect(appShape.cornerStyle, isA<CornerStyle>());
      expect(appShape.cornerStyle, CornerStyle.rounded);
    });

    test(
      'cornerRadius returns cornerRadiusPresets[CornerStyle.rounded] by default',
      () {
        expect(appShape.cornerRadius, cornerRadiusPresets[CornerStyle.rounded]);
      },
    );

    test(
      'setCornerStyle updates cornerStyle when cornerStyle = CornerStyle.square',
      () {
        appShape.setCornerStyle(CornerStyle.square);

        expect(appShape.cornerStyle, CornerStyle.square);
      },
    );

    test(
      'setCornerStyle updates cornerRadius to cornerRadiusPresets[CornerStyle.square] when cornerStyle = CornerStyle.square',
      () {
        appShape.setCornerStyle(CornerStyle.square);

        expect(appShape.cornerRadius, cornerRadiusPresets[CornerStyle.square]);
      },
    );

    test('setCornerStyle notifies listeners when the style changes', () {
      int callCount = 0;
      appShape.addListener(() => callCount++);

      appShape.setCornerStyle(CornerStyle.square);

      expect(callCount, 1);
    });

    test(
      'setCornerStyle does not notify listeners when the style is unchanged',
      () {
        int callCount = 0;
        appShape.addListener(() => callCount++);

        appShape.setCornerStyle(CornerStyle.rounded);

        expect(callCount, 0);
      },
    );
  });

  group('AppShape persists through AppPreferencesStore', () {
    late MockAppPreferencesStore mockPreferencesStore;
    late AppShape appShape;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
      when(
        () => mockPreferencesStore.writeCornerStyle(any()),
      ).thenAnswer((_) async {});
      appShape = AppShape(preferencesStore: mockPreferencesStore);
    });

    test(
      'setCornerStyle calls AppPreferencesStore.writeCornerStyle() when the style changes',
      () async {
        appShape.setCornerStyle(CornerStyle.square);
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockPreferencesStore.writeCornerStyle(CornerStyle.square),
        ).called(1);
      },
    );

    test(
      'setCornerStyle does not call AppPreferencesStore.writeCornerStyle() when the style is unchanged',
      () async {
        appShape.setCornerStyle(CornerStyle.rounded);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockPreferencesStore.writeCornerStyle(any()));
      },
    );
  });

  group('AppShape constructs correctly', () {
    late MockAppPreferencesStore mockPreferencesStore;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
    });

    test(
      'Method restore() returns AppShape with the constructor default when AppPreferencesStore.readCornerStyle() returns null',
      () async {
        when(
          () => mockPreferencesStore.readCornerStyle(),
        ).thenAnswer((_) async => null);

        final AppShape result = await AppShape.restore(mockPreferencesStore);

        expect(result.cornerStyle, CornerStyle.rounded);
      },
    );

    test(
      'Method restore() returns AppShape with the persisted selection when AppPreferencesStore.readCornerStyle() returns a value',
      () async {
        when(
          () => mockPreferencesStore.readCornerStyle(),
        ).thenAnswer((_) async => CornerStyle.square);

        final AppShape result = await AppShape.restore(mockPreferencesStore);

        expect(result.cornerStyle, CornerStyle.square);
      },
    );
  });
}
