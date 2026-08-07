// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String channelName = 'worth_loop.test/price_alert_notifications';
  late MethodChannel channel;
  late AndroidPriceAlertNotificationService service;

  setUp(() {
    channel = const MethodChannel(channelName);
    service = AndroidPriceAlertNotificationService(methodChannel: channel);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('AndroidPriceAlertNotificationService behaves correctly', () {
    test('areNotificationsEnabled returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'areNotificationsEnabled');
            return true;
          });

      expect(await service.areNotificationsEnabled(), isTrue);
    });

    test('requestPermission returns the native result', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'requestPermission');
            return true;
          });

      expect(await service.requestPermission(), isTrue);
    });

    test('returns false when native returns false or null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async => null);

      expect(await service.areNotificationsEnabled(), isFalse);
      expect(await service.requestPermission(), isFalse);
      expect(
        await service.showPriceDrop(
          productId: 'product-1',
          title: 'Product dropped',
          body: 'Now €99',
        ),
        isFalse,
      );
    });

    test('showPriceDrop forwards the notification payload', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            expect(call.method, 'showPriceDrop');
            expect(call.arguments, {
              'productId': 'product-1',
              'title': 'Product dropped',
              'body': 'Now €99',
            });
            return true;
          });

      expect(
        await service.showPriceDrop(
          productId: 'product-1',
          title: 'Product dropped',
          body: 'Now €99',
        ),
        isTrue,
      );
    });

    test('returns false when the native bridge is unavailable', () async {
      expect(await service.areNotificationsEnabled(), isFalse);
      expect(await service.requestPermission(), isFalse);
      expect(
        await service.showPriceDrop(
          productId: 'product-1',
          title: 'Product dropped',
          body: 'Now €99',
        ),
        isFalse,
      );
    });

    test(
      'returns false when the native bridge throws PlatformException',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              channel,
              (MethodCall call) async =>
                  throw PlatformException(code: 'unavailable'),
            );

        expect(await service.areNotificationsEnabled(), isFalse);
        expect(await service.requestPermission(), isFalse);
        expect(
          await service.showPriceDrop(
            productId: 'product-1',
            title: 'Product dropped',
            body: 'Now €99',
          ),
          isFalse,
        );
      },
    );
  });
}
