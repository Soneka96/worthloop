// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/android_background_capabilities_service.dart';
import 'package:worth_loop/shared/utils/background_capability_snapshot.value-object.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String channelName = 'worth_loop.test/background_capabilities';
  late MethodChannel channel;
  late AndroidBackgroundCapabilitiesService service;

  setUp(() {
    channel = const MethodChannel(channelName);
    service = AndroidBackgroundCapabilitiesService(methodChannel: channel);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('AndroidBackgroundCapabilitiesService behaves correctly', () {
    test('read returns the native capability snapshot', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'read');
            return <String, Object?>{
              'isSupported': true,
              'manufacturer': 'Example',
              'model': 'Example One',
              'androidSdk': 35,
              'isIgnoringBatteryOptimizations': true,
              'standbyBucket': 10,
            };
          });

      final snapshot = await service.read();

      expect(snapshot.isSupported, isTrue);
      expect(snapshot.manufacturer, 'Example');
      expect(snapshot.model, 'Example One');
      expect(snapshot.androidSdk, 35);
      expect(snapshot.isIgnoringBatteryOptimizations, isTrue);
      expect(snapshot.standbyBucket, 10);
    });

    test(
      'read returns unsupported when the native bridge is unavailable',
      () async {
        final snapshot = await service.read();

        expect(snapshot, const BackgroundCapabilitySnapshot.unsupported());
      },
    );

    test('openBatterySettings returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'openBatterySettings');
            return true;
          });

      expect(await service.openBatterySettings(), isTrue);
    });

    test(
      'openBatterySettings returns false when the native bridge is unavailable',
      () async {
        expect(await service.openBatterySettings(), isFalse);
      },
    );
  });
}
