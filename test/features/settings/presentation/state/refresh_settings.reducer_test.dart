// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.reducer.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';
import '../../fixtures/refresh_settings.fixture.dart';

void main() {
  group(
    'RefreshSettingsReducer processes LoadRefreshSettingsAction correctly',
    () {
      test('LoadRefreshSettingsAction modifies isLoading and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(error: const Some('failed'));

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const LoadRefreshSettingsAction(),
        );

        expect(state.isLoading, isFalse, reason: 'previous value');
        expect(reducedState.isLoading, isTrue, reason: 'new value');
        expect(reducedState.error, isNull);
      });
    },
  );

  group(
    'RefreshSettingsReducer processes RefreshSettingsLoadedAction correctly',
    () {
      test(
        'RefreshSettingsLoadedAction modifies intervalMinutes and isLoading',
        () {
          final RefreshSettingsState state = RefreshSettingsState.initial()
              .copyWith(isLoading: true);

          final RefreshSettingsState reducedState = refreshSettingsReducer(
            state,
            RefreshSettingsLoadedAction(
              buildRefreshSettings(intervalMinutes: 180),
            ),
          );

          expect(state.intervalMinutes, 60, reason: 'previous value');
          expect(reducedState.intervalMinutes, 180, reason: 'new value');
          expect(
            state.browserRefreshEnabled,
            isFalse,
            reason: 'previous value',
          );
          expect(
            reducedState.browserRefreshEnabled,
            isFalse,
            reason: 'new value',
          );
          expect(state.isLoading, isTrue, reason: 'previous value');
          expect(reducedState.isLoading, isFalse, reason: 'new value');
        },
      );
    },
  );

  group(
    'RefreshSettingsReducer processes RefreshSettingsLoadFailedAction correctly',
    () {
      test('RefreshSettingsLoadFailedAction modifies isLoading and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(isLoading: true);

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const RefreshSettingsLoadFailedAction('failed'),
        );

        expect(state.isLoading, isTrue, reason: 'previous value');
        expect(reducedState.isLoading, isFalse, reason: 'new value');
        expect(reducedState.error, 'failed');
      });
    },
  );

  group(
    'RefreshSettingsReducer processes SaveRefreshIntervalAction correctly',
    () {
      test('SaveRefreshIntervalAction modifies isSaving and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(error: const Some('failed'));

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const SaveRefreshIntervalAction(180),
        );

        expect(state.isSaving, isFalse, reason: 'previous value');
        expect(reducedState.isSaving, isTrue, reason: 'new value');
        expect(reducedState.error, isNull);
      });
    },
  );

  group(
    'RefreshSettingsReducer processes RefreshIntervalSavedAction correctly',
    () {
      test(
        'RefreshIntervalSavedAction modifies intervalMinutes and isSaving',
        () {
          final RefreshSettingsState state = RefreshSettingsState.initial()
              .copyWith(isSaving: true);

          final RefreshSettingsState reducedState = refreshSettingsReducer(
            state,
            const RefreshIntervalSavedAction(180),
          );

          expect(state.intervalMinutes, 60, reason: 'previous value');
          expect(reducedState.intervalMinutes, 180, reason: 'new value');
          expect(state.isSaving, isTrue, reason: 'previous value');
          expect(reducedState.isSaving, isFalse, reason: 'new value');
        },
      );
    },
  );

  group(
    'RefreshSettingsReducer processes RefreshIntervalSaveFailedAction correctly',
    () {
      test('RefreshIntervalSaveFailedAction modifies isSaving and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(isSaving: true);

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const RefreshIntervalSaveFailedAction('failed'),
        );

        expect(state.isSaving, isTrue, reason: 'previous value');
        expect(reducedState.isSaving, isFalse, reason: 'new value');
        expect(reducedState.error, 'failed');
      });
    },
  );

  group('RefreshSettingsReducer processes unhandled actions correctly', () {
    test('Object modifies nothing', () {
      final RefreshSettingsState state = RefreshSettingsState.initial();

      expect(refreshSettingsReducer(state, Object()), state);
    });
  });

  group(
    'RefreshSettingsReducer processes SavePriceAlertsEnabledAction correctly',
    () {
      test('SavePriceAlertsEnabledAction modifies isSaving and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(error: const Some('failed'));

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const SavePriceAlertsEnabledAction(true),
        );

        expect(state.isSaving, isFalse, reason: 'previous value');
        expect(reducedState.isSaving, isTrue, reason: 'new value');
        expect(reducedState.error, isNull);
      });
    },
  );

  group(
    'RefreshSettingsReducer processes PriceAlertsEnabledSavedAction correctly',
    () {
      test(
        'PriceAlertsEnabledSavedAction modifies the preference and isSaving',
        () {
          final RefreshSettingsState state = RefreshSettingsState.initial()
              .copyWith(isSaving: true);

          final RefreshSettingsState reducedState = refreshSettingsReducer(
            state,
            const PriceAlertsEnabledSavedAction(true),
          );

          expect(state.priceAlertsEnabled, isFalse, reason: 'previous value');
          expect(reducedState.priceAlertsEnabled, isTrue, reason: 'new value');
          expect(state.isSaving, isTrue, reason: 'previous value');
          expect(reducedState.isSaving, isFalse, reason: 'new value');
        },
      );
    },
  );

  group(
    'RefreshSettingsReducer processes PriceAlertsSaveFailedAction correctly',
    () {
      test('PriceAlertsSaveFailedAction modifies isSaving and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(isSaving: true);

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const PriceAlertsSaveFailedAction('failed'),
        );

        expect(state.isSaving, isTrue, reason: 'previous value');
        expect(reducedState.isSaving, isFalse, reason: 'new value');
        expect(reducedState.error, 'failed');
      });
    },
  );

  group(
    'RefreshSettingsReducer processes SaveBrowserRefreshEnabledAction correctly',
    () {
      test('SaveBrowserRefreshEnabledAction modifies isSaving and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(error: const Some('failed'));

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const SaveBrowserRefreshEnabledAction(true),
        );

        expect(state.isSaving, isFalse, reason: 'previous value');
        expect(reducedState.isSaving, isTrue, reason: 'new value');
        expect(reducedState.error, isNull);
      });
    },
  );

  group(
    'RefreshSettingsReducer processes BrowserRefreshEnabledSavedAction correctly',
    () {
      test(
        'BrowserRefreshEnabledSavedAction modifies the preference and isSaving',
        () {
          final RefreshSettingsState state = RefreshSettingsState.initial()
              .copyWith(isSaving: true);

          final RefreshSettingsState reducedState = refreshSettingsReducer(
            state,
            const BrowserRefreshEnabledSavedAction(true),
          );

          expect(
            state.browserRefreshEnabled,
            isFalse,
            reason: 'previous value',
          );
          expect(
            reducedState.browserRefreshEnabled,
            isTrue,
            reason: 'new value',
          );
          expect(state.isSaving, isTrue, reason: 'previous value');
          expect(reducedState.isSaving, isFalse, reason: 'new value');
        },
      );
    },
  );

  group(
    'RefreshSettingsReducer processes BrowserRefreshSaveFailedAction correctly',
    () {
      test('BrowserRefreshSaveFailedAction modifies isSaving and error', () {
        final RefreshSettingsState state = RefreshSettingsState.initial()
            .copyWith(isSaving: true);

        final RefreshSettingsState reducedState = refreshSettingsReducer(
          state,
          const BrowserRefreshSaveFailedAction('failed'),
        );

        expect(state.isSaving, isTrue, reason: 'previous value');
        expect(reducedState.isSaving, isFalse, reason: 'new value');
        expect(reducedState.error, 'failed');
      });
    },
  );
}
