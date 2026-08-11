// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_change.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';
import 'package:worth_loop/shared/utils/product_price_alert_notification_coordinator.dart';

class MockLoadRefreshSettingsUseCase extends Mock
    implements LoadRefreshSettingsUseCase {}

class MockAndroidPriceAlertNotificationService extends Mock
    implements AndroidPriceAlertNotificationService {}

void main() {
  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  late Directory directory;
  late MockLoadRefreshSettingsUseCase loadSettings;
  late MockAndroidPriceAlertNotificationService notifications;
  late ProductPriceAlertNotificationCoordinator coordinator;

  final ProductPriceChange drop = ProductPriceChange(
    product: Product(
      id: 'product-1',
      name: 'Headphones',
      sources: const [],
      lastUpdatedAt: DateTime(2026, 1, 1),
      bestPriceChangedAt: DateTime(2026, 1, 2),
    ),
    previousBestPrice: const Money(minorUnits: 12000, currencyCode: 'EUR'),
    currentBestPrice: const Money(minorUnits: 9900, currencyCode: 'EUR'),
    direction: PriceChangeDirection.drop,
  );

  final ProductPriceChange increase = ProductPriceChange(
    product: Product(
      id: 'product-1',
      name: 'Headphones',
      sources: const [],
      lastUpdatedAt: DateTime(2026, 1, 1),
      bestPriceChangedAt: DateTime(2026, 1, 2),
    ),
    previousBestPrice: const Money(minorUnits: 9900, currencyCode: 'EUR'),
    currentBestPrice: const Money(minorUnits: 12000, currencyCode: 'EUR'),
    direction: PriceChangeDirection.increase,
  );

  setUp(() {
    directory = Directory.systemTemp.createTempSync('price_alert_test');
    loadSettings = MockLoadRefreshSettingsUseCase();
    notifications = MockAndroidPriceAlertNotificationService();
    coordinator = ProductPriceAlertNotificationCoordinator(
      loadSettings,
      AppPreferencesStore(directory: directory),
      notifications,
    );
    when(() => loadSettings(any())).thenAnswer(
      (_) async => const Right(
        RefreshSettings(
          intervalMinutes: 60,
          priceDropAlertsEnabled: true,
          priceIncreaseAlertsEnabled: true,
        ),
      ),
    );
  });

  tearDown(() => directory.deleteSync(recursive: true));

  test('does not notify when loadSettings() fails', () async {
    const DatabaseFailure failure = DatabaseFailure('failed');
    when(
      () => loadSettings(any()),
    ).thenAnswer((_) async => const Left(failure));

    await coordinator.notify(drop);

    verifyNever(
      () => notifications.showPriceDrop(
        productId: any(named: 'productId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    );
  });

  test('does not notify a price drop when price-drop alerts are disabled', () async {
    when(() => loadSettings(any())).thenAnswer(
      (_) async => const Right(
        RefreshSettings(intervalMinutes: 60, priceIncreaseAlertsEnabled: true),
      ),
    );

    await coordinator.notify(drop);

    verifyNever(
      () => notifications.showPriceDrop(
        productId: any(named: 'productId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    );
  });

  test(
    'does not notify a price increase when price-increase alerts are disabled',
    () async {
      when(() => loadSettings(any())).thenAnswer(
        (_) async => const Right(
          RefreshSettings(intervalMinutes: 60, priceDropAlertsEnabled: true),
        ),
      );

      await coordinator.notify(increase);

      verifyNever(
        () => notifications.showPriceDrop(
          productId: any(named: 'productId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      );
    },
  );

  test('notifies a price drop when price-drop alerts are enabled', () async {
    when(
      () => notifications.showPriceDrop(
        productId: any(named: 'productId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => true);

    await coordinator.notify(drop);

    verify(
      () => notifications.showPriceDrop(
        productId: 'product-1',
        title: 'Headphones is cheaper',
        body: 'Now 99.00 EUR, down from 120.00 EUR.',
      ),
    ).called(1);
  });

  test(
    'notifies a price increase with distinct copy when price-increase alerts are enabled',
    () async {
      when(
        () => notifications.showPriceDrop(
          productId: any(named: 'productId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => true);

      await coordinator.notify(increase);

      verify(
        () => notifications.showPriceDrop(
          productId: 'product-1',
          title: 'Headphones got more expensive',
          body: 'Now 120.00 EUR, up from 99.00 EUR.',
        ),
      ).called(1);
    },
  );

  test('notifies once and deduplicates the same price event', () async {
    when(
      () => notifications.showPriceDrop(
        productId: any(named: 'productId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => true);

    await coordinator.notify(drop);
    await coordinator.notify(drop);

    verify(
      () => notifications.showPriceDrop(
        productId: 'product-1',
        title: 'Headphones is cheaper',
        body: 'Now 99.00 EUR, down from 120.00 EUR.',
      ),
    ).called(1);
  });

  test(
    'treats a drop and an increase for the same product as distinct events',
    () async {
      when(
        () => notifications.showPriceDrop(
          productId: any(named: 'productId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => true);

      await coordinator.notify(drop);
      await coordinator.notify(increase);

      verify(
        () => notifications.showPriceDrop(
          productId: any(named: 'productId'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        ),
      ).called(2);
    },
  );

  test('does not mark an event delivered when Android rejects it', () async {
    when(
      () => notifications.showPriceDrop(
        productId: any(named: 'productId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => false);

    await coordinator.notify(drop);
    await coordinator.notify(drop);

    verify(
      () => notifications.showPriceDrop(
        productId: 'product-1',
        title: any(named: 'title'),
        body: any(named: 'body'),
      ),
    ).called(2);
  });
}
