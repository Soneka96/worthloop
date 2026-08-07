// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';

void main() {
  group('RefreshSettingsState — initial', () {
    test('contains the hourly idle defaults', () {
      final RefreshSettingsState state = RefreshSettingsState.initial();

      expect(state.intervalMinutes, isA<int>());
      expect(state.intervalMinutes, 60);
      expect(state.browserRefreshEnabled, isA<bool>());
      expect(state.browserRefreshEnabled, isFalse);
      expect(state.priceAlertsEnabled, isA<bool>());
      expect(state.priceAlertsEnabled, isFalse);
      expect(state.isLoading, isA<bool>());
      expect(state.isLoading, isFalse);
      expect(state.isSaving, isA<bool>());
      expect(state.isSaving, isFalse);
      expect(state.error, isNull);
    });
  });

  group('RefreshSettingsState — copyWith', () {
    test('replaces every supplied field', () {
      final RefreshSettingsState state = RefreshSettingsState.initial()
          .copyWith(
            intervalMinutes: 180,
            browserRefreshEnabled: true,
            priceAlertsEnabled: true,
            isLoading: true,
            isSaving: true,
            error: const Some('failed'),
          );

      expect(state.intervalMinutes, isA<int>());
      expect(state.intervalMinutes, 180);
      expect(state.browserRefreshEnabled, isA<bool>());
      expect(state.browserRefreshEnabled, isTrue);
      expect(state.priceAlertsEnabled, isTrue);
      expect(state.isLoading, isA<bool>());
      expect(state.isLoading, isTrue);
      expect(state.isSaving, isA<bool>());
      expect(state.isSaving, isTrue);
      expect(state.error, isA<String>());
      expect(state.error, 'failed');
    });

    test('clears error with None', () {
      final RefreshSettingsState state = RefreshSettingsState.initial()
          .copyWith(error: const Some('failed'))
          .copyWith(error: const None());

      expect(state.error, isNull);
    });
  });
}
