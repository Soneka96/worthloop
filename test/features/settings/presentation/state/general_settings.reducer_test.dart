// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.reducer.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';

void main() {
  group('generalSettingsReducer processes GeneralSettingsLoadedAction', () {
    test(
      'GeneralSettingsLoadedAction replaces every field with the persisted values',
      () {
        final GeneralSettingsState state = GeneralSettingsState.initial();

        final GeneralSettingsState next = generalSettingsReducer(
          state,
          const GeneralSettingsLoadedAction(
            defaultSaveLocation: 'C:/App',
            pendingDataRoot: 'C:/NewApp',
          ),
        );

        expect(next.defaultSaveLocation, 'C:/App');
        expect(next.pendingDataRoot, 'C:/NewApp');
      },
    );

    test(
      'GeneralSettingsLoadedAction keeps the current toggle values when nothing was persisted for them',
      () {
        final GeneralSettingsState state = GeneralSettingsState.initial()
            .copyWith(defaultSaveLocation: 'location');

        final GeneralSettingsState next = generalSettingsReducer(
          state,
          const GeneralSettingsLoadedAction(
            defaultSaveLocation: null,
            pendingDataRoot: null,
          ),
        );

        expect(
          next.defaultSaveLocation,
          'location',
          reason:
              'state is already at its default/current value when the '
              'load fires, so a null read is a no-op, not a reset',
        );
      },
    );
  });

  group('generalSettingsReducer processes PendingDataRootUpdatedAction', () {
    test(
      'PendingDataRootUpdatedAction updates pendingDataRoot to the given value',
      () {
        final GeneralSettingsState state = GeneralSettingsState.initial();

        final GeneralSettingsState next = generalSettingsReducer(
          state,
          const PendingDataRootUpdatedAction('C:/NewApp'),
        );

        expect(next.pendingDataRoot, 'C:/NewApp');
      },
    );

    test(
      'PendingDataRootUpdatedAction clears pendingDataRoot when value = null',
      () {
        final GeneralSettingsState state = GeneralSettingsState.initial()
            .copyWith(pendingDataRoot: 'C:/NewApp');

        final GeneralSettingsState next = generalSettingsReducer(
          state,
          const PendingDataRootUpdatedAction(null),
        );

        expect(next.pendingDataRoot, isNull);
      },
    );
  });

  group('generalSettingsReducer processes unhandled actions', () {
    test('LoadGeneralSettingsAction modifies nothing', () {
      final GeneralSettingsState state = GeneralSettingsState.initial();

      final GeneralSettingsState next = generalSettingsReducer(
        state,
        const LoadGeneralSettingsAction(),
      );

      expect(next, state);
    });

    test('PickDefaultSaveLocationAction modifies nothing', () {
      final GeneralSettingsState state = GeneralSettingsState.initial();

      final GeneralSettingsState next = generalSettingsReducer(
        state,
        const PickDefaultSaveLocationAction('C:/App'),
      );

      expect(next, state);
    });
  });
}
