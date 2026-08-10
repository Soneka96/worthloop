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

  /// Requests an immediate refresh from the background service.
  Future<bool> requestRefresh() async {
    try {
      return await _methodChannel.invokeMethod<bool>('requestRefresh') ?? false;
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

  /// Registers the background entrypoint's callback handle with native code.
  Future<bool> registerCallbackHandle(int handle) async {
    try {
      return await _methodChannel.invokeMethod<bool>(
            'registerCallbackHandle',
            handle,
          ) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Queues [sourceIds] onto the background service, starting it if it
  /// isn't already running.
  Future<bool> enqueueSources(List<String> sourceIds) async {
    try {
      return await _methodChannel.invokeMethod<bool>(
            'enqueueSources',
            sourceIds,
          ) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
