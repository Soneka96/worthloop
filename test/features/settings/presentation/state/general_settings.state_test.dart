// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';

void main() {
  group('GeneralSettingsState — initial', () {
    test(
      'GeneralSettingsState.initial returns the default toggles and no save location',
      () {
        final GeneralSettingsState state = GeneralSettingsState.initial();

        expect(state.defaultSaveLocation, isNull);
        expect(state.pendingDataRoot, isNull);
      },
    );
  });

  group('GeneralSettingsState — copyWith', () {
    test(
      'GeneralSettingsState copyWith preserves fields that are not passed',
      () {
        final GeneralSettingsState state = GeneralSettingsState.initial()
            .copyWith(defaultSaveLocation: 'C:/App');

        final GeneralSettingsState next = state.copyWith(
          pendingDataRoot: 'C:/App1',
        );

        expect(next.defaultSaveLocation, 'C:/App');
        expect(next.pendingDataRoot, 'C:/App1');
      },
    );

    test('GeneralSettingsState copyWith updates pendingDataRoot', () {
      final GeneralSettingsState state = GeneralSettingsState.initial();

      final GeneralSettingsState next = state.copyWith(
        pendingDataRoot: 'C:/NewApp',
      );

      expect(next.pendingDataRoot, 'C:/NewApp');
    });
  });
}
