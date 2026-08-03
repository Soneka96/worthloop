// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/notifications/system_notification_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/utils/Iapp_relaunch.gateway.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';
import 'package:worth_loop/shared/window/window_controller.dart';

/// Handles General settings actions. Added to [CreateStore]'s middleware
/// list — see `lib/shared/state/create_store.dart`. [AppPreferencesStore],
/// [AppDataRootService], [SystemNotificationService], [IAppRelaunchGateway],
/// and [IWindowGateway] have no business rule of their own, so they're
/// resolved via [sl] and called directly here rather than through a
/// usecase/repository/datasource — see `ai/context/architecture.md`'s
/// "Services" section.
class GeneralSettingsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case LoadGeneralSettingsAction _:
        _loadGeneralSettings(store, action);
      case PickDefaultSaveLocationAction _:
        _pickDefaultSaveLocation(store, action);
      case RestartNowAction _:
        _restartNow();
      case CheckForUpdatesAction _:
        _checkForUpdates();
      case OpenPrivacyPolicyAction _:
        _openPrivacyPolicy();
    }
  }

  /// Handles [LoadGeneralSettingsAction]. Dispatches
  /// [GeneralSettingsLoadedAction] with whatever's persisted, `null` for
  /// anything that isn't.
  Future<void> _loadGeneralSettings(
    Store<AppState> store,
    LoadGeneralSettingsAction action,
  ) async {
    final settings = await sl<AppPreferencesStore>().readGeneralSettings();
    store.dispatch(
      GeneralSettingsLoadedAction(
        defaultSaveLocation: settings.defaultSaveLocation,
        pendingDataRoot: settings.pendingDataRoot,
      ),
    );
  }
  
  /// Handles [PickDefaultSaveLocationAction]. Validates the newly browsed
  /// folder via [AppDataRootService.requestMove], dispatches
  /// [PendingDataRootUpdatedAction] with the result, and either notifies
  /// about the pending restart or shows a popup that the folder won't
  /// change.
  Future<void> _pickDefaultSaveLocation(
    Store<AppState> store,
    PickDefaultSaveLocationAction action,
  ) async {
    await (await sl<AppDataRootService>().requestMove(action.path)).fold(
      (failure) async {
        sl<LoggerService>().e(failure.message, showPopup: true);
      },
      (_) async {
        final String? pendingDataRoot = await sl<AppPreferencesStore>()
            .readPendingDataRoot();
        store.dispatch(PendingDataRootUpdatedAction(pendingDataRoot));
        if (pendingDataRoot != null) {
          await sl<SystemNotificationService>().show(
            title: t
                .settings
                .general
                .defaultSaveLocation
                .restartNotification
                .title,
            body:
                t.settings.general.defaultSaveLocation.restartNotification.body,
            onClick: () => store.dispatch(const RestartNowAction()),
          );
        } else {
          sl<LoggerService>().i(
            t.settings.general.defaultSaveLocation.stayMessage,
            showPopup: true,
          );
        }
      },
    );
  }

  /// Handles [RestartNowAction]. Hides this window first, purely so the old
  /// window visually disappears before the new one appears — the process
  /// itself stays alive underneath. Then closes [AppDatabase], since its
  /// sqlite file must be released before a new instance starts, or that
  /// instance's own [AppDataRootService.applyPendingMoveIfNeeded] finds the
  /// file still locked. Only then spawns the new instance via
  /// [IAppRelaunchGateway] — spawning has to happen before this process
  /// actually ends, never after, since [IWindowGateway.close] may end it
  /// before a later line ever runs. Finally requests closing this one —
  /// [WindowController.onWindowClose] handles persisting geometry,
  /// dismissing the active notification, and exiting.
  Future<void> _restartNow() async {
    await sl<IWindowGateway>().hide();
    await sl<AppDatabase>().close();
    await sl<IAppRelaunchGateway>().relaunch();
    await sl<IWindowGateway>().close();
  }

  /// Handles [CheckForUpdatesAction]. Shows a popup — not implemented yet.
  void _checkForUpdates() {
    sl<LoggerService>().i(
      t.settings.general.updates.notImplemented,
      showPopup: true,
    );
  }

  /// Handles [OpenPrivacyPolicyAction]. Shows a popup — not implemented yet.
  void _openPrivacyPolicy() {
    sl<LoggerService>().i(
      t.settings.general.about.notImplemented,
      showPopup: true,
    );
  }
}
