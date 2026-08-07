// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_drop.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/background_refresh_runner.dart';

void main() {
  final Product product = Product(
    id: 'product-1',
    name: 'Product',
    sources: [],
    lastUpdatedAt: DateTime(2026, 1, 1),
  );

  group('BackgroundRefreshRunner behaves correctly', () {
    test('refreshes enabled settings and returns their interval', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Right(
          RefreshSettings(intervalMinutes: 180, browserRefreshEnabled: true),
        ),
        refreshAllProducts: ({onPriceDrop}) async {
          refreshCalls++;
          return Right(<Product>[product]);
        },
      );

      final Duration? nextDelay = await runner.runOnce();

      expect(nextDelay, const Duration(minutes: 180));
      expect(refreshCalls, 1);
    });

    test('reports whether the refresh use case succeeded', () async {
      bool? succeeded;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Right(
          RefreshSettings(intervalMinutes: 60, browserRefreshEnabled: true),
        ),
        refreshAllProducts: ({onPriceDrop}) async =>
            const Left(DatabaseFailure('fetch failed')),
      );

      await runner.runOnce(
        onRefreshOutcome: (bool value) async => succeeded = value,
      );

      expect(succeeded, isFalse);
    });

    test('stops without refreshing when browser refresh is disabled', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async =>
            const Right(RefreshSettings(intervalMinutes: 60)),
        refreshAllProducts: ({onPriceDrop}) async {
          refreshCalls++;
          return Right(<Product>[product]);
        },
      );

      final Duration? nextDelay = await runner.runOnce();

      expect(nextDelay, isNull);
      expect(refreshCalls, 0);
    });

    test('forced refresh ignores the automatic refresh setting once', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async =>
            const Right(RefreshSettings(intervalMinutes: 60)),
        refreshAllProducts: ({onPriceDrop}) async {
          refreshCalls++;
          return Right(<Product>[product]);
        },
      );

      final Duration? nextDelay = await runner.runOnce(force: true);

      expect(nextDelay, const Duration(minutes: 60));
      expect(refreshCalls, 1);
    });

    test('uses the hourly retry interval when settings cannot load', () async {
      int refreshCalls = 0;
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Left(DatabaseFailure('failed')),
        refreshAllProducts: ({onPriceDrop}) async {
          refreshCalls++;
          return Right(<Product>[product]);
        },
      );

      final Duration? nextDelay = await runner.runOnce();

      expect(
        nextDelay,
        const Duration(minutes: RefreshIntervalConstants.hourly),
      );
      expect(refreshCalls, 1);
    });

    test(
      'uses the hourly interval when settings contain an invalid interval',
      () async {
        final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
          loadSettings: () async => const Right(
            RefreshSettings(intervalMinutes: 0, browserRefreshEnabled: true),
          ),
          refreshAllProducts: ({onPriceDrop}) async =>
              Right(<Product>[product]),
        );

        expect(
          await runner.runOnce(),
          const Duration(minutes: RefreshIntervalConstants.hourly),
        );
      },
    );

    test('forwards the price-drop listener to refreshes', () async {
      ProductPriceDrop? receivedDrop;
      final ProductPriceDrop drop = ProductPriceDrop(
        product: product,
        previousBestPrice: const Money(minorUnits: 200, currencyCode: 'EUR'),
        currentBestPrice: const Money(minorUnits: 100, currencyCode: 'EUR'),
      );
      final BackgroundRefreshRunner runner = BackgroundRefreshRunner(
        loadSettings: () async => const Right(
          RefreshSettings(intervalMinutes: 60, browserRefreshEnabled: true),
        ),
        refreshAllProducts: ({onPriceDrop}) async {
          await onPriceDrop?.call(drop);
          return Right(<Product>[product]);
        },
        onPriceDrop: (ProductPriceDrop value) async => receivedDrop = value,
      );

      await runner.runOnce();

      expect(receivedDrop, drop);
    });
  });
}
