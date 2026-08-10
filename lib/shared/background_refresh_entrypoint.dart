// Flutter imports:
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/background_refresh_loop.dart';
import 'package:worth_loop/shared/utils/background_refresh_runner.dart';
import 'package:worth_loop/shared/utils/product_source_refresh_engine.dart';

const MethodChannel _engineChannel = MethodChannel(
  'io.github.soneka96.worthloop/background_refresh_engine',
);

/// Runs the local refresh loop inside the foreground service's Flutter engine.
@pragma('vm:entry-point')
Future<void> backgroundRefreshEntrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await sl<IProductsRepository>().resetStaleSourceStatuses();

  sl<ProductSourceRefreshEngine>().onProgress = (
    int completed,
    int total,
  ) async {
    final Either<Failure, RefreshSettings> settingsResult =
        await sl<LoadRefreshSettingsUseCase>()(NoParams());
    final bool showProgress = settingsResult.fold(
      (_) => false,
      (RefreshSettings settings) => settings.showRefreshProgress,
    );
    if (!showProgress) {
      return;
    }
    await _notifyEngine(
      'updateProgress',
      arguments: {'completed': completed, 'total': total},
    );
  };

  final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
    loadSettings: () => sl<LoadRefreshSettingsUseCase>()(NoParams()),
    refreshAllProducts: () => sl<RefreshAllProductsUseCase>()(NoParams()),
  );

  Future<Duration?> runScheduledRefresh({required bool force}) {
    return runner.runOnce(
      force: force,
      onRefreshStarted: () => _notifyEngine('refreshStarted'),
      onRefreshOutcome: (bool succeeded) async {
        final Either<Failure, RefreshSettings> settingsResult =
            await sl<LoadRefreshSettingsUseCase>()(NoParams());
        final bool showResult = settingsResult.fold(
          (_) => false,
          (RefreshSettings settings) => settings.refreshCompletedAlertsEnabled,
        );
        await _notifyEngine(
          succeeded ? 'refreshCompleted' : 'refreshFailed',
          arguments: {'showResult': showResult},
        );
      },
    );
  }

  final BackgroundRefreshLoop loop = BackgroundRefreshLoop(
    runOnce: () => runScheduledRefresh(force: false),
    runManualOnce: () => runScheduledRefresh(force: true),
  );

  _engineChannel.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'enqueueSources') {
      final Object? arguments = call.arguments;
      final Map<Object?, Object?> payload = arguments is Map
          ? arguments
          : const {};
      await sl<IProductsRepository>().enqueueSourceRefresh(
        _sourceIdsFrom(payload['sourceIds']),
        bypassCooldown: payload['bypassCooldown'] == true,
      );
    }
  });

  try {
    final Object? pending = await _engineChannel.invokeMethod<Object?>(
      'consumePendingSourceIds',
    );
    final List<String> sourceIds = _sourceIdsFrom(pending);
    if (sourceIds.isNotEmpty) {
      await sl<IProductsRepository>().enqueueSourceRefresh(sourceIds);
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
      await _engineChannel.invokeMethod<void>('stopService');
    } on MissingPluginException {
      // Nothing to stop when the entrypoint is running without the native host.
    } on PlatformException {
      // Native cleanup is best effort after the refresh loop finishes.
    }
  }
}

Future<void> _notifyEngine(String method, {Object? arguments}) async {
  try {
    await _engineChannel.invokeMethod<void>(method, arguments);
  } on MissingPluginException {
    // Notifications are best effort when running without the native host.
  } on PlatformException {
    // Notification failures must not stop product refreshes.
  }
}

List<String> _sourceIdsFrom(Object? arguments) =>
    arguments is List ? arguments.whereType<String>().toList() : const [];
