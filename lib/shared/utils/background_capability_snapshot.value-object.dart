// Package imports:
import 'package:equatable/equatable.dart';

/// Android background-execution capabilities relevant to refresh scheduling.
class BackgroundCapabilitySnapshot extends Equatable {
  /// Whether the native capability bridge is available.
  final bool isSupported;

  /// Device manufacturer reported by Android.
  final String manufacturer;

  /// Device model reported by Android.
  final String model;

  /// Android SDK level, or `null` when unavailable.
  final int? androidSdk;

  /// Whether Android has exempted WorthLoop from battery optimizations.
  final bool isIgnoringBatteryOptimizations;

  /// Android app standby bucket, or `null` on unsupported API levels.
  final int? standbyBucket;

  const BackgroundCapabilitySnapshot({
    required this.isSupported,
    required this.manufacturer,
    required this.model,
    required this.androidSdk,
    required this.isIgnoringBatteryOptimizations,
    required this.standbyBucket,
  });

  /// Returns a snapshot for platforms without the Android bridge.
  const BackgroundCapabilitySnapshot.unsupported()
    : isSupported = false,
      manufacturer = '',
      model = '',
      androidSdk = null,
      isIgnoringBatteryOptimizations = false,
      standbyBucket = null;

  @override
  List<Object?> get props => [
    isSupported,
    manufacturer,
    model,
    androidSdk,
    isIgnoringBatteryOptimizations,
    standbyBucket,
  ];
}
