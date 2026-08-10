// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  late List<dynamic> dispatchedActions;
  late Store<AppState> store;

  setUp(() {
    dispatchedActions = [];

    store = Store<AppState>((AppState state, dynamic action) {
      dispatchedActions.add(action);
      return state;
    }, initialState: AppState.initial());
  });

  group(
    'GeneralSettingsScreenViewModel constructor initializes all parameters correctly',
    () {
      test(
        'Method fromStore() constructs GeneralSettingsScreenViewModel correctly',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          expect(viewmodel.refreshIntervalMinutes, isA<int>());
          expect(viewmodel.refreshIntervalMinutes, 60);
          expect(viewmodel.browserRefreshEnabled, isA<bool>());
          expect(viewmodel.browserRefreshEnabled, isFalse);
          expect(viewmodel.isRefreshIntervalBusy, isA<bool>());
          expect(viewmodel.isRefreshIntervalBusy, isFalse);
          expect(viewmodel.onCheckForUpdates, isA<Function()>());
          expect(viewmodel.onOpenPrivacyPolicy, isA<Function()>());
          expect(
            viewmodel.onRefreshIntervalSelected,
            isA<void Function(int)>(),
          );
          expect(
            viewmodel.onBrowserRefreshEnabledChanged,
            isA<void Function(bool)>(),
          );
          expect(viewmodel.onOpenBackgroundRestrictions, isA<Function()>());
        },
      );

      test(
        'Method onRefreshIntervalSelected dispatches SaveRefreshIntervalAction when called',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          viewmodel.onRefreshIntervalSelected(180);

          expect(dispatchedActions, [const SaveRefreshIntervalAction(180)]);
        },
      );

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
        'Method onBrowserRefreshEnabledChanged dispatches SaveBrowserRefreshEnabledAction when called',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          viewmodel.onBrowserRefreshEnabledChanged(true);

          expect(dispatchedActions, [
            const SaveBrowserRefreshEnabledAction(true),
          ]);
        },
      );

      test(
        'Method onOpenBackgroundRestrictions dispatches OpenBackgroundRestrictionsAction when called',
        () {
          final GeneralSettingsScreenViewModel viewmodel =
              GeneralSettingsScreenViewModel.fromStore(store);

          viewmodel.onOpenBackgroundRestrictions();

          expect(dispatchedActions, [const OpenBackgroundRestrictionsAction()]);
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
