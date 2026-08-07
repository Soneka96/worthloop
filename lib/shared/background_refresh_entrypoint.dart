// Flutter imports:
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
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

  final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
    runOnce: runner.runOnce,
    runManualOnce: () => runner.runOnce(force: true),
  );
  const MethodChannel engineChannel = MethodChannel(
    'io.github.soneka96.worthloop/background_refresh_engine',
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
