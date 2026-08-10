// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_price_drop.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';

/// Turns persisted price-drop events into user notifications.
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

  /// Notifies once for each distinct best-price change, when enabled.
  Future<void> notify(ProductPriceDrop drop) async {
    final settingsResult = await _loadSettings(NoParams());
    final bool enabled = settingsResult.fold(
      (_) => false,
      (settings) => settings.priceDropAlertsEnabled,
    );
    if (!enabled) return;
    final String eventKey = _eventKey(drop);
    if (_inFlight.contains(eventKey)) {
      return;
    }
    _inFlight.add(eventKey);
    try {
      final bool claimed;
      try {
        claimed = await _preferences.claimPriceAlertEvent(
          drop.product.id,
          eventKey,
        );
      } catch (_) {
        return;
      }
      if (!claimed) return;
      final bool shown = await _notifications.showPriceDrop(
        productId: drop.product.id,
        title: t.settings.general.priceAlerts.notificationTitle(
          name: drop.product.name,
        ),
        body: t.settings.general.priceAlerts.notificationBody(
          current: _format(drop.currentBestPrice),
          previous: _format(drop.previousBestPrice),
        ),
      );
      if (!shown) {
        try {
          await _preferences.releasePriceAlertEvent(drop.product.id, eventKey);
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

  String _eventKey(ProductPriceDrop drop) => [
    drop.product.id,
    drop.product.bestPriceChangedAt?.toIso8601String() ?? '',
    drop.currentBestPrice.currencyCode,
    drop.currentBestPrice.minorUnits,
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
