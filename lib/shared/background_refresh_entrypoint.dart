// Flutter imports:
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/utils/background_refresh_loop.dart';
import 'package:worth_loop/shared/utils/background_refresh_runner.dart';
import 'package:worth_loop/shared/utils/product_price_alert_notification_coordinator.dart';

/// Runs the local refresh loop inside the foreground service's Flutter engine.
@pragma('vm:entry-point')
Future<void> backgroundRefreshEntrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
    loadSettings: () => sl<LoadRefreshSettingsUseCase>()(NoParams()),
    refreshAllProducts: ({ProductPriceDropListener? onPriceDrop}) =>
        sl<RefreshAllProductsUseCase>()(NoParams(), onPriceDrop: onPriceDrop),
    onPriceDrop: sl<ProductPriceAlertNotificationCoordinator>().notify,
  );

  const MethodChannel engineChannel = MethodChannel(
    'io.github.soneka96.worthloop/background_refresh_engine',
  );
  Future<void> notifyRefreshStatus(String method) async {
    try {
      await engineChannel.invokeMethod<void>(method);
    } on MissingPluginException {
      // Notifications are best effort when running without the native host.
    } on PlatformException {
      // Notification failures must not stop product refreshes.
    }
  }

  Future<Duration?> runRefresh({required bool force}) async {
    bool? refreshSucceeded;
    Future<void> markCompletion(bool succeeded) async {
      try {
        await sl<AppPreferencesStore>().markBackgroundRefreshCompleted(
          succeeded: succeeded,
        );
      } catch (_) {
        // Reconciliation markers are best effort and must not stop a refresh.
      }
    }

    try {
      final Duration? nextDelay = await runner.runOnce(
        force: force,
        onRefreshStarted: () => notifyRefreshStatus('refreshStarted'),
        onRefreshOutcome: (bool succeeded) async {
          refreshSucceeded = succeeded;
        },
      );
      if (nextDelay != null) {
        await markCompletion(refreshSucceeded ?? false);
        await notifyRefreshStatus(
          refreshSucceeded == false ? 'refreshFailed' : 'refreshCompleted',
        );
      }
      return nextDelay;
    } catch (_) {
      await markCompletion(false);
      await notifyRefreshStatus('refreshFailed');
      rethrow;
    }
  }

  final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
    runOnce: () => runRefresh(force: false),
    runManualOnce: () => runRefresh(force: true),
  );
  engineChannel.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'refreshNow') {
      loop.requestRefresh();
    }
  });

  try {
    final bool hasPendingRefresh =
        await engineChannel.invokeMethod<bool>(
          'consumePendingRefreshRequest',
        ) ??
        false;
    if (hasPendingRefresh) {
      loop.requestRefresh();
    }
  } on MissingPluginException {
    // The entrypoint can still perform scheduled refreshes on unsupported hosts.
  } on PlatformException {
    // The entrypoint can still perform scheduled refreshes if the bridge fails.
  }

  try {
    await loop.run();
  } finally {
    try {
      await engineChannel.invokeMethod<void>('stopService');
    } on MissingPluginException {
      // Nothing to stop when the entrypoint is running without the native host.
    } on PlatformException {
      // Native cleanup is best effort after the refresh loop finishes.
    }
  }
}
