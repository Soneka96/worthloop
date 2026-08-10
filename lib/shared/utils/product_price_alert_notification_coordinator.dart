// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_price_change.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/settings/domain/entities/refresh_settings.entity.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';

/// Turns persisted price-change events into user notifications.
class ProductPriceAlertNotificationCoordinator {
  final LoadRefreshSettingsUseCase _loadSettings;
  final AppPreferencesStore _preferences;
  final AndroidPriceAlertNotificationService _notifications;
  final Set<String> _inFlight = <String>{};

  ProductPriceAlertNotificationCoordinator(
    this._loadSettings,
    this._preferences,
    this._notifications,
  );

  /// Notifies once for each distinct best-price change, when enabled for
  /// that change's direction.
  Future<void> notify(ProductPriceChange change) async {
    final settingsResult = await _loadSettings(NoParams());
    final bool enabled = settingsResult.fold(
      (_) => false,
      (RefreshSettings settings) => switch (change.direction) {
        PriceChangeDirection.drop => settings.priceDropAlertsEnabled,
        PriceChangeDirection.increase => settings.priceIncreaseAlertsEnabled,
        PriceChangeDirection.none => false,
      },
    );
    if (!enabled) return;
    final String eventKey = _eventKey(change);
    if (_inFlight.contains(eventKey)) {
      return;
    }
    _inFlight.add(eventKey);
    try {
      final bool claimed;
      try {
        claimed = await _preferences.claimPriceAlertEvent(
          change.product.id,
          eventKey,
        );
      } catch (_) {
        return;
      }
      if (!claimed) return;
      final bool shown = await _notifications.showPriceDrop(
        productId: change.product.id,
        title: _title(change),
        body: _body(change),
      );
      if (!shown) {
        try {
          await _preferences.releasePriceAlertEvent(
            change.product.id,
            eventKey,
          );
        } catch (_) {
          // A failed notification must never fail the refresh.
        }
      }
    } catch (_) {
      // Notification delivery is best-effort and isolated from refreshes.
    } finally {
      _inFlight.remove(eventKey);
    }
  }

  String _title(ProductPriceChange change) => switch (change.direction) {
    PriceChangeDirection.increase =>
      t.settings.notifications.priceIncreaseAlerts.notificationTitle,
    PriceChangeDirection.drop || PriceChangeDirection.none =>
      t.settings.notifications.priceAlerts.notificationTitle,
  }(name: change.product.name);

  String _body(ProductPriceChange change) =>
      switch (change.direction) {
        PriceChangeDirection.increase =>
          t.settings.notifications.priceIncreaseAlerts.notificationBody,
        PriceChangeDirection.drop || PriceChangeDirection.none =>
          t.settings.notifications.priceAlerts.notificationBody,
      }(
        current: _format(change.currentBestPrice),
        previous: _format(change.previousBestPrice),
      );

  String _eventKey(ProductPriceChange change) => [
    change.product.id,
    change.direction.name,
    change.product.bestPriceChangedAt?.toIso8601String() ?? '',
    change.currentBestPrice.currencyCode,
    change.currentBestPrice.minorUnits,
  ].join('|');

  String _format(Money price) {
    final int scale = switch (price.currencyCode.toUpperCase()) {
      'BHD' || 'JOD' || 'KWD' || 'OMR' => 1000,
      'JPY' || 'KRW' => 1,
      _ => 100,
    };
    final int decimals = scale == 1
        ? 0
        : scale == 1000
        ? 3
        : 2;
    return '${(price.minorUnits / scale).toStringAsFixed(decimals)} ${price.currencyCode}';
  }
}
