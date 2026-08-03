// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/state/logs.state.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {
  group('AppState — initial', () {
    test('AppState.initial includes the default GeneralSettingsState', () {
      final AppState state = AppState.initial();

      expect(state.generalSettings, GeneralSettingsState.initial());
    });

    test('AppState.initial includes the default LogsState', () {
      final AppState state = AppState.initial();

      expect(state.logs, LogsState.initial());
    });
  });

  group('AppState — copyWith', () {
    test('AppState copyWith replaces generalSettings when passed', () {
      final AppState state = AppState.initial();
      final GeneralSettingsState updatedGeneralSettings =
          GeneralSettingsState.initial().copyWith(
            defaultSaveLocation: 'C:/App',
          );

      final AppState next = state.copyWith(
        generalSettings: updatedGeneralSettings,
      );

      expect(next.generalSettings, updatedGeneralSettings);
    });

    test('AppState copyWith preserves generalSettings when omitted', () {
      final AppState state = AppState.initial();

      final AppState next = state.copyWith();

      expect(next.generalSettings, state.generalSettings);
    });

    test('AppState copyWith replaces logs when passed', () {
      final AppState state = AppState.initial();
      final LogsState updatedLogs = LogsState.initial().copyWith(
        folderPath: 'C:/App/logs',
      );

      final AppState next = state.copyWith(logs: updatedLogs);

      expect(next.logs, updatedLogs);
    });

    test('AppState copyWith preserves logs when omitted', () {
      final AppState state = AppState.initial();

      final AppState next = state.copyWith();

      expect(next.logs, state.logs);
    });
  });
}
