// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Handles General settings actions.
class GeneralSettingsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case CheckForUpdatesAction _:
        _checkForUpdates();
      case OpenPrivacyPolicyAction _:
        _openPrivacyPolicy();
    }
  }

  /// Handles [CheckForUpdatesAction].
  void _checkForUpdates() {
    sl<LoggerService>().i(
      t.settings.general.updates.notImplemented,
      showPopup: true,
    );
  }

  /// Handles [OpenPrivacyPolicyAction].
  void _openPrivacyPolicy() {
    sl<LoggerService>().i(
      t.settings.general.about.notImplemented,
      showPopup: true,
    );
  }
}
