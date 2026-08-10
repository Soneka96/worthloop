// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_browser_refresh_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_refresh_interval.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_browser_refresh_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/params/save_price_alerts_enabled.params.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/android_background_capabilities_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';

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
      case SavePriceAlertsEnabledAction _:
        _savePriceAlertsEnabled(store, action);
      case OpenBackgroundRestrictionsAction _:
        _openBackgroundRestrictions();
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
        _syncBackgroundRefreshService(settings.browserRefreshEnabled);
        store.dispatch(
          BrowserRefreshEnabledSavedAction(settings.browserRefreshEnabled),
        );
      },
    );
  }

  /// Handles [SavePriceAlertsEnabledAction].
  Future<void> _savePriceAlertsEnabled(
    Store<AppState> store,
    SavePriceAlertsEnabledAction action,
  ) async {
    if (action.enabled) {
      final bool granted = await sl<AndroidPriceAlertNotificationService>()
          .requestPermission();
      if (!granted) {
        sl<LoggerService>().w(
          t.settings.general.priceAlerts.permissionDenied,
          showPopup: true,
        );
        return;
      }
    }
    (await sl<SavePriceAlertsEnabledUseCase>()(
      SavePriceAlertsEnabledParams(enabled: action.enabled),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(PriceAlertsSaveFailedAction(failure.message));
      },
      (RefreshSettings settings) {
        store.dispatch(
          PriceAlertsEnabledSavedAction(settings.priceDropAlertsEnabled),
        );
      },
    );
  }

  /// Opens Android's battery settings for the browser-refresh repair action.
  Future<void> _openBackgroundRestrictions() async {
    await sl<AndroidBackgroundCapabilitiesService>().openBatterySettings();
  }

  /// Starts or stops the user-visible background refresh host.
  Future<void> _syncBackgroundRefreshService(bool enabled) async {
    final bool started = enabled
        ? await sl<AndroidBackgroundRefreshService>().start()
        : await sl<AndroidBackgroundRefreshService>().stop();
    if (enabled && !started) {
      sl<LoggerService>().w(
        'Background browser refresh could not start yet',
        showPopup: true,
      );
    }
  }
}
