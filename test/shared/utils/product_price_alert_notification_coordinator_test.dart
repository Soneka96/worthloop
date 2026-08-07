// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_price_drop.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
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

  final ProductPriceDrop drop = ProductPriceDrop(
    product: Product(
      id: 'product-1',
      name: 'Headphones',
      sources: const [],
      lastUpdatedAt: DateTime(2026, 1, 1),
      bestPriceChangedAt: DateTime(2026, 1, 2),
    ),
    previousBestPrice: const Money(minorUnits: 12000, currencyCode: 'EUR'),
    currentBestPrice: const Money(minorUnits: 9900, currencyCode: 'EUR'),
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
        RefreshSettings(intervalMinutes: 60, priceAlertsEnabled: true),
      ),
    );
  });

  tearDown(() => directory.deleteSync(recursive: true));

  test('does not notify when price alerts are disabled', () async {
    when(() => loadSettings(any())).thenAnswer(
      (_) async => const Right(RefreshSettings(intervalMinutes: 60)),
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
