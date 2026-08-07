// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/background_refresh_runner.dart';

/// Runs the local refresh loop inside the foreground service's Flutter engine.
@pragma('vm:entry-point')
Future<void> backgroundRefreshEntrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
    loadSettings: () => sl<LoadRefreshSettingsUseCase>()(NoParams()),
    refreshAllProducts: () => sl<RefreshAllProductsUseCase>()(NoParams()),
  );

  while (true) {
    final Duration? nextDelay = await runner.runOnce();
    if (nextDelay == null) {
      return;
    }
    await Future<void>.delayed(nextDelay);
  }
}
