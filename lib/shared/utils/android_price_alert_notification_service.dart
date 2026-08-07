// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/services.dart';

/// Bridges price-alert notifications to Android's notification manager.
class AndroidPriceAlertNotificationService {
  static const MethodChannel _channel = MethodChannel(
    'io.github.soneka96.worthloop/price_alert_notifications',
  );

  final MethodChannel _methodChannel;

  /// Creates a notification bridge, optionally with a test channel.
  AndroidPriceAlertNotificationService({MethodChannel? methodChannel})
    : _methodChannel = methodChannel ?? _channel;

  /// Returns whether Android currently allows WorthLoop notifications.
  Future<bool> areNotificationsEnabled() async {
    try {
      return await _methodChannel.invokeMethod<bool>(
            'areNotificationsEnabled',
          ) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Opens Android's notification permission prompt when needed.
  Future<bool> requestPermission() async {
    try {
      return await _methodChannel.invokeMethod<bool>('requestPermission') ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Consumes the product ID that launched the app from a price alert.
  Future<String?> getInitialPriceAlertProductId() async {
    try {
      return await _methodChannel.invokeMethod<String>(
        'getInitialPriceAlertProductId',
      );
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Listens for taps on price alerts while the app is already open.
  void listenForPriceAlertTaps(
    FutureOr<void> Function(String productId) onTap,
  ) {
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'priceAlertTapped' && call.arguments is String) {
        await onTap(call.arguments as String);
      }
    });
  }

  /// Shows a notification for a newly lower product price.
  Future<bool> showPriceDrop({
    required String productId,
    required String title,
    required String body,
  }) async {
    try {
      return await _methodChannel.invokeMethod<bool>('showPriceDrop', {
            'productId': productId,
            'title': title,
            'body': body,
          }) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
