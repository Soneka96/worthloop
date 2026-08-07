// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.selectors.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  group('Method intervalMinutesSelector() returns an int instance', () {
    test('intervalMinutesSelector() returns intervalMinutes', () {
      final AppState state = AppState.initial().copyWith(
        refreshSettings: RefreshSettingsState.initial().copyWith(
          intervalMinutes: 180,
        ),
      );

      expect(
        RefreshSettingsSelectors.intervalMinutesSelector(state),
        isA<int>(),
      );
      expect(RefreshSettingsSelectors.intervalMinutesSelector(state), 180);
    });
  });

  group('Method isBusySelector() returns a bool instance', () {
    test('isBusySelector() returns true when isLoading = true', () {
      final AppState state = AppState.initial().copyWith(
        refreshSettings: RefreshSettingsState.initial().copyWith(
          isLoading: true,
        ),
      );

      expect(RefreshSettingsSelectors.isBusySelector(state), isA<bool>());
      expect(RefreshSettingsSelectors.isBusySelector(state), isTrue);
    });

    test('isBusySelector() returns true when isSaving = true', () {
      final AppState state = AppState.initial().copyWith(
        refreshSettings: RefreshSettingsState.initial().copyWith(
          isSaving: true,
        ),
      );

      expect(RefreshSettingsSelectors.isBusySelector(state), isA<bool>());
      expect(RefreshSettingsSelectors.isBusySelector(state), isTrue);
    });

    test('isBusySelector() returns false when settings are idle', () {
      expect(
        RefreshSettingsSelectors.isBusySelector(AppState.initial()),
        isA<bool>(),
      );
      expect(
        RefreshSettingsSelectors.isBusySelector(AppState.initial()),
        isFalse,
      );
    });
  });

  group('Method browserRefreshEnabledSelector() returns a bool instance', () {
    test('browserRefreshEnabledSelector() returns the preference', () {
      final AppState state = AppState.initial().copyWith(
        refreshSettings: RefreshSettingsState.initial().copyWith(
          browserRefreshEnabled: true,
        ),
      );

      expect(
        RefreshSettingsSelectors.browserRefreshEnabledSelector(state),
        isA<bool>(),
      );
      expect(
        RefreshSettingsSelectors.browserRefreshEnabledSelector(state),
        isTrue,
      );
    });
  });

  group('Method priceAlertsEnabledSelector() returns a bool instance', () {
    test('priceAlertsEnabledSelector() returns the preference', () {
      final AppState state = AppState.initial().copyWith(
        refreshSettings: RefreshSettingsState.initial().copyWith(
          priceAlertsEnabled: true,
        ),
      );

      expect(
        RefreshSettingsSelectors.priceAlertsEnabledSelector(state),
        isA<bool>(),
      );
      expect(
        RefreshSettingsSelectors.priceAlertsEnabledSelector(state),
        isTrue,
      );
    });
  });
}
