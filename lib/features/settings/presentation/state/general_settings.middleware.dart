// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_browser_refresh_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_interval.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_browser_refresh_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
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
      case LoadRefreshSettingsAction _:
        _loadRefreshSettings(store, action);
      case SaveRefreshIntervalAction _:
        _saveRefreshInterval(store, action);
      case SaveBrowserRefreshEnabledAction _:
        _saveBrowserRefreshEnabled(store, action);
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

  /// Handles [LoadRefreshSettingsAction].
  Future<void> _loadRefreshSettings(
    Store<AppState> store,
    LoadRefreshSettingsAction action,
  ) async {
    (await sl<LoadRefreshSettingsUseCase>()(NoParams())).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(RefreshSettingsLoadFailedAction(failure.message));
      },
      (RefreshSettings settings) {
        store.dispatch(RefreshSettingsLoadedAction(settings));
      },
    );
  }

  /// Handles [SaveRefreshIntervalAction].
  Future<void> _saveRefreshInterval(
    Store<AppState> store,
    SaveRefreshIntervalAction action,
  ) async {
    (await sl<SaveRefreshIntervalUseCase>()(
      SaveRefreshIntervalParams(intervalMinutes: action.intervalMinutes),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(RefreshIntervalSaveFailedAction(failure.message));
      },
      (RefreshSettings settings) {
        store.dispatch(RefreshIntervalSavedAction(settings.intervalMinutes));
      },
    );
  }

  /// Handles [SaveBrowserRefreshEnabledAction].
  Future<void> _saveBrowserRefreshEnabled(
    Store<AppState> store,
    SaveBrowserRefreshEnabledAction action,
  ) async {
    (await sl<SaveBrowserRefreshEnabledUseCase>()(
      SaveBrowserRefreshEnabledParams(enabled: action.enabled),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(BrowserRefreshSaveFailedAction(failure.message));
      },
      (RefreshSettings settings) {
        store.dispatch(
          BrowserRefreshEnabledSavedAction(settings.browserRefreshEnabled),
        );
      },
    );
  }
}
