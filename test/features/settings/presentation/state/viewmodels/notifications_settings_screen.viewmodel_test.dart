// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/notifications_settings_screen.viewmodel.dart';
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
    'NotificationsSettingsScreenViewModel constructor initializes all parameters correctly',
    () {
      test(
        'Method fromStore() constructs NotificationsSettingsScreenViewModel correctly',
        () {
          final NotificationsSettingsScreenViewModel viewmodel =
              NotificationsSettingsScreenViewModel.fromStore(store);

          expect(viewmodel.priceDropAlertsEnabled, isA<bool>());
          expect(viewmodel.priceDropAlertsEnabled, isFalse);
          expect(viewmodel.priceIncreaseAlertsEnabled, isA<bool>());
          expect(viewmodel.priceIncreaseAlertsEnabled, isFalse);
          expect(viewmodel.refreshCompletedAlertsEnabled, isA<bool>());
          expect(viewmodel.refreshCompletedAlertsEnabled, isFalse);
          expect(viewmodel.showRefreshProgress, isA<bool>());
          expect(viewmodel.showRefreshProgress, isFalse);
          expect(viewmodel.isBusy, isA<bool>());
          expect(viewmodel.isBusy, isFalse);
          expect(
            viewmodel.onPriceDropAlertsEnabledChanged,
            isA<void Function(bool)>(),
          );
          expect(
            viewmodel.onPriceIncreaseAlertsEnabledChanged,
            isA<void Function(bool)>(),
          );
          expect(
            viewmodel.onRefreshCompletedAlertsEnabledChanged,
            isA<void Function(bool)>(),
          );
          expect(
            viewmodel.onShowRefreshProgressChanged,
            isA<void Function(bool)>(),
          );
        },
      );

      test(
        'Method onPriceDropAlertsEnabledChanged dispatches SavePriceAlertsEnabledAction when called',
        () {
          final NotificationsSettingsScreenViewModel viewmodel =
              NotificationsSettingsScreenViewModel.fromStore(store);

          viewmodel.onPriceDropAlertsEnabledChanged(true);

          expect(dispatchedActions, [const SavePriceAlertsEnabledAction(true)]);
        },
      );

      test(
        'Method onPriceIncreaseAlertsEnabledChanged dispatches SavePriceIncreaseAlertsEnabledAction when called',
        () {
          final NotificationsSettingsScreenViewModel viewmodel =
              NotificationsSettingsScreenViewModel.fromStore(store);

          viewmodel.onPriceIncreaseAlertsEnabledChanged(true);

          expect(dispatchedActions, [
            const SavePriceIncreaseAlertsEnabledAction(true),
          ]);
        },
      );

      test(
        'Method onRefreshCompletedAlertsEnabledChanged dispatches SaveRefreshCompletedAlertsEnabledAction when called',
        () {
          final NotificationsSettingsScreenViewModel viewmodel =
              NotificationsSettingsScreenViewModel.fromStore(store);

          viewmodel.onRefreshCompletedAlertsEnabledChanged(true);

          expect(dispatchedActions, [
            const SaveRefreshCompletedAlertsEnabledAction(true),
          ]);
        },
      );

      test(
        'Method onShowRefreshProgressChanged dispatches SaveShowRefreshProgressAction when called',
        () {
          final NotificationsSettingsScreenViewModel viewmodel =
              NotificationsSettingsScreenViewModel.fromStore(store);

          viewmodel.onShowRefreshProgressChanged(true);

          expect(dispatchedActions, [
            const SaveShowRefreshProgressAction(true),
          ]);
        },
      );
    },
  );
}
