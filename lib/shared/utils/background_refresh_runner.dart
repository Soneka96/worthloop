// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';
import 'package:worth_loop/shared/failures/failures.dart';

/// Executes one local background-refresh cycle and chooses the next delay.
class BackgroundRefreshRunner {
  final Future<Either<Failure, RefreshSettings>> Function() _loadSettings;
  final Future<Either<Failure, List<Product>>> Function({
    ProductPriceDropListener? onPriceDrop,
  })
  _refreshAllProducts;
  final ProductPriceDropListener? _onPriceDrop;

  /// Creates a runner backed by settings and product-refresh callbacks.
  BackgroundRefreshRunner({
    required Future<Either<Failure, RefreshSettings>> Function() loadSettings,
    required Future<Either<Failure, List<Product>>> Function({
      ProductPriceDropListener? onPriceDrop,
    })
    refreshAllProducts,
    ProductPriceDropListener? onPriceDrop,
  }) : _loadSettings = loadSettings,
       _refreshAllProducts = refreshAllProducts,
       _onPriceDrop = onPriceDrop;

  /// Runs one cycle, returning `null` when the service should stop.
  Future<Duration?> runOnce() async {
    final Either<Failure, RefreshSettings> settingsResult =
        await _loadSettings();
    return settingsResult.fold(
      (_) async {
        await _refreshAllProducts(onPriceDrop: _onPriceDrop);
        return const Duration(minutes: RefreshIntervalConstants.hourly);
      },
      (RefreshSettings settings) async {
        if (!settings.browserRefreshEnabled) {
          return null;
        }
        await _refreshAllProducts(onPriceDrop: _onPriceDrop);
        final int intervalMinutes = settings.intervalMinutes < 1
            ? RefreshIntervalConstants.hourly
            : settings.intervalMinutes;
        return Duration(minutes: intervalMinutes);
      },
    );
  }
}
