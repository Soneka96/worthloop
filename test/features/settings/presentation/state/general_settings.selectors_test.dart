// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.selectors.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  group('Method defaultSaveLocationSelector() returns a String? instance', () {
    test(
      'Method defaultSaveLocationSelector() returns null when nothing has been set',
      () {
        final AppState state = AppState.initial();

        expect(
          GeneralSettingsSelectors.defaultSaveLocationSelector(state),
          isNull,
        );
      },
    );

    test(
      'Method defaultSaveLocationSelector() returns the persisted path when set',
      () {
        final AppState state = AppState.initial().copyWith(
          generalSettings: GeneralSettingsState.initial().copyWith(
            defaultSaveLocation: 'C:/App',
          ),
        );

        expect(
          GeneralSettingsSelectors.defaultSaveLocationSelector(state),
          'C:/App',
        );
      },
    );
  });

  group('Method pendingDataRootSelector() returns a String? instance', () {
    test(
      'Method pendingDataRootSelector() returns null when nothing is pending',
      () {
        final AppState state = AppState.initial();

        expect(GeneralSettingsSelectors.pendingDataRootSelector(state), isNull);
      },
    );

    test(
      'Method pendingDataRootSelector() returns the pending path when set',
      () {
        final AppState state = AppState.initial().copyWith(
          generalSettings: GeneralSettingsState.initial().copyWith(
            pendingDataRoot: 'C:/NewApp',
          ),
        );

        expect(
          GeneralSettingsSelectors.pendingDataRootSelector(state),
          'C:/NewApp',
        );
      },
    );
  });
}
