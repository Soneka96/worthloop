// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String channelName = 'worth_loop.test/background_refresh';
  late MethodChannel channel;
  late AndroidBackgroundRefreshService service;

  setUp(() {
    channel = const MethodChannel(channelName);
    service = AndroidBackgroundRefreshService(methodChannel: channel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('AndroidBackgroundRefreshService behaves correctly', () {
    test('start returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'start');
            return true;
          });

      expect(await service.start(), isTrue);
    });

    test('stop returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'stop');
            return true;
          });

      expect(await service.stop(), isTrue);
    });

    test('requestRefresh returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'requestRefresh');
            return true;
          });

      expect(await service.requestRefresh(), isTrue);
    });

    test('isRunning returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'isRunning');
            return true;
          });

      expect(await service.isRunning(), isTrue);
    });

    test('returns false when the native bridge is unavailable', () async {
      expect(await service.start(), isFalse);
      expect(await service.stop(), isFalse);
      expect(await service.requestRefresh(), isFalse);
      expect(await service.isRunning(), isFalse);
    });
  });
}
