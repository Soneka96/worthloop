// Flutter imports:
import 'package:flutter/services.dart';

/// Starts and stops WorthLoop's user-visible Android refresh host.
class AndroidBackgroundRefreshService {
  static const MethodChannel _channel = MethodChannel(
    'io.github.soneka96.worthloop/background_refresh',
  );

  final MethodChannel _methodChannel;

  /// Creates a refresh host bridge, optionally with a test channel.
  AndroidBackgroundRefreshService({MethodChannel? methodChannel})
    : _methodChannel = methodChannel ?? _channel;

  /// Starts the foreground service and returns whether Android accepted it.
  Future<bool> start() async {
    try {
      return await _methodChannel.invokeMethod<bool>('start') ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Stops the foreground service and returns whether Android accepted it.
  Future<bool> stop() async {
    try {
      return await _methodChannel.invokeMethod<bool>('stop') ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Returns whether the foreground service is currently running.
  Future<bool> isRunning() async {
    try {
      return await _methodChannel.invokeMethod<bool>('isRunning') ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
