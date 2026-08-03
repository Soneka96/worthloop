// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_spacing_presets.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

void main() {
  setUpAll(() {
    registerFallbackValue(SpacingDensity.none);
  });

  group('AppSpacing behaves correctly', () {
    test(
      'restore returns AppSpacing with comfortable density when nothing is persisted',
      () async {
        final MockAppPreferencesStore store = MockAppPreferencesStore();
        when(() => store.readSpacingDensity()).thenAnswer((_) async => null);

        final AppSpacing spacing = await AppSpacing.restore(store);

        expect(spacing.density, SpacingDensity.comfortable);
      },
    );

    test(
      'restore returns AppSpacing with persisted density when readSpacingDensity returns compact',
      () async {
        final MockAppPreferencesStore store = MockAppPreferencesStore();
        when(
          () => store.readSpacingDensity(),
        ).thenAnswer((_) async => SpacingDensity.compact);

        final AppSpacing spacing = await AppSpacing.restore(store);

        expect(spacing.density, SpacingDensity.compact);
      },
    );

    test('setDensity updates density and calls notifyListeners', () {
      final AppSpacing spacing = AppSpacing();
      int notifyCount = 0;
      spacing.addListener(() => notifyCount++);

      spacing.setDensity(SpacingDensity.compact);

      expect(spacing.density, SpacingDensity.compact);
      expect(notifyCount, 1);
    });

    test(
      'setDensity does not call notifyListeners when density is already comfortable',
      () {
        final AppSpacing spacing = AppSpacing();
        int notifyCount = 0;
        spacing.addListener(() => notifyCount++);

        spacing.setDensity(SpacingDensity.comfortable);

        expect(notifyCount, 0);
      },
    );

    test(
      'visualDensity returns VisualDensity.standard when density = comfortable',
      () {
        final AppSpacing spacing = AppSpacing();

        expect(spacing.visualDensity, VisualDensity.standard);
      },
    );

    test(
      'visualDensity returns VisualDensity.compact when density = compact',
      () {
        final AppSpacing spacing = AppSpacing(density: SpacingDensity.compact);

        expect(spacing.visualDensity, VisualDensity.compact);
      },
    );

    test(
      'spacingValues returns Spacing-equivalent gaps when density = comfortable',
      () {
        final AppSpacing spacing = AppSpacing();

        expect(
          spacing.spacingValues,
          spacingValuePresets[SpacingDensity.comfortable],
        );
      },
    );

    test('spacingValues returns tighter gaps when density = compact', () {
      final AppSpacing spacing = AppSpacing(density: SpacingDensity.compact);

      expect(
        spacing.spacingValues,
        spacingValuePresets[SpacingDensity.compact],
      );
      expect(
        spacing.spacingValues.md,
        lessThan(AppSpacingThemeExtension.comfortable.md),
        reason: 'compact should read as tighter than comfortable',
      );
    });
  });

  group('AppSpacing persists through AppPreferencesStore', () {
    late MockAppPreferencesStore mockPreferencesStore;
    late AppSpacing spacing;

    setUp(() {
      mockPreferencesStore = MockAppPreferencesStore();
      when(
        () => mockPreferencesStore.writeSpacingDensity(any()),
      ).thenAnswer((_) async {});
      spacing = AppSpacing(preferencesStore: mockPreferencesStore);
    });

    test(
      'setDensity calls AppPreferencesStore.writeSpacingDensity() when the density changes',
      () async {
        spacing.setDensity(SpacingDensity.compact);
        await Future<void>.delayed(Duration.zero);

        verify(
          () =>
              mockPreferencesStore.writeSpacingDensity(SpacingDensity.compact),
        ).called(1);
      },
    );

    test(
      'setDensity does not call AppPreferencesStore.writeSpacingDensity() when the density is unchanged',
      () async {
        spacing.setDensity(SpacingDensity.comfortable);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockPreferencesStore.writeSpacingDensity(any()));
      },
    );
  });
}
