// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  late List<dynamic> dispatchedActions;
  late Store<AppState> store;

  setUp(() {
    dispatchedActions = [];

    store = Store<AppState>(
      (AppState state, dynamic action) {
        dispatchedActions.add(action);
        return state;
      },
      initialState: AppState.initial().copyWith(
        generalSettings: GeneralSettingsState.initial().copyWith(
          defaultSaveLocation: 'C:/App',
          pendingDataRoot: 'C:/NewApp',
        ),
      ),
    );
  });

  group(
    'GeneralSettingsScreenViewModel constructor initializes all parameters correctly',
    () {
      test(
        'Method fromStore() constructs GeneralSettingsScreenViewModel correctly',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          expect(viewmodel.defaultSaveLocation, 'C:/App');
          expect(viewmodel.pendingDataRoot, 'C:/NewApp');
        },
      );

      test(
        'Method onPickDefaultSaveLocation dispatches PickDefaultSaveLocationAction when called',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          viewmodel.onPickDefaultSaveLocation('C:/New Location');

          expect(dispatchedActions, [
            const PickDefaultSaveLocationAction('C:/New Location'),
          ]);
        },
      );

      test('Method onRestartNow dispatches RestartNowAction when called', () {
        final GeneralSettingsScreenViewModel viewmodel =
            GeneralSettingsScreenViewModel.fromStore(store);

        viewmodel.onRestartNow();

        expect(dispatchedActions, [const RestartNowAction()]);
      });

      test(
        'Method onCheckForUpdates dispatches CheckForUpdatesAction when called',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          viewmodel.onCheckForUpdates();

          expect(dispatchedActions, [const CheckForUpdatesAction()]);
        },
      );

      test(
        'Method onOpenPrivacyPolicy dispatches OpenPrivacyPolicyAction when called',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          viewmodel.onOpenPrivacyPolicy();

          expect(dispatchedActions, [const OpenPrivacyPolicyAction()]);
        },
      );
    },
  );
}
