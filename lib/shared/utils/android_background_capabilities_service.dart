// Flutter imports:
import 'package:flutter/services.dart';

// Project imports:
import 'package:worth_loop/shared/utils/background_capability_snapshot.value-object.dart';

/// Reads Android background-execution state and opens its battery settings.
class AndroidBackgroundCapabilitiesService {
  static const MethodChannel _channel = MethodChannel(
    'io.github.soneka96.worthloop/background_capabilities',
  );

  final MethodChannel _methodChannel;

  /// Creates a capability service, optionally with a test channel.
  AndroidBackgroundCapabilitiesService({MethodChannel? methodChannel})
    : _methodChannel = methodChannel ?? _channel;

  /// Reads the current Android background-execution state.
  Future<BackgroundCapabilitySnapshot> read() async {
    try {
      final Map<Object?, Object?>? values = await _methodChannel.invokeMethod(
        'read',
      );
      if (values == null) {
        return const BackgroundCapabilitySnapshot.unsupported();
      }
      return BackgroundCapabilitySnapshot(
        isSupported: values['isSupported'] as bool? ?? false,
        manufacturer: values['manufacturer'] as String? ?? '',
        model: values['model'] as String? ?? '',
        androidSdk: values['androidSdk'] as int?,
        isIgnoringBatteryOptimizations:
            values['isIgnoringBatteryOptimizations'] as bool? ?? false,
        standbyBucket: values['standbyBucket'] as int?,
      );
    } on MissingPluginException {
      return const BackgroundCapabilitySnapshot.unsupported();
    } on PlatformException {
      return const BackgroundCapabilitySnapshot.unsupported();
    }
  }

  /// Opens Android's battery-optimization settings screen.
  Future<bool> openBatterySettings() async {
    try {
      return await _methodChannel.invokeMethod<bool>('openBatterySettings') ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
