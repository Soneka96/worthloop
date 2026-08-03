// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/notifications/notification_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('local_notifier');
  late List<MethodCall> log;
  late NotificationGateway gateway;

  setUp(() async {
    log = [];
    gateway = NotificationGateway();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          log.add(call);
          if (call.method == 'setup') {
            return true;
          }
          return null;
        });
    await gateway.setup('Clean Architecture Starter');
    log.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('NotificationGateway behaves correctly', () {
    test(
      'Method setup() invokes the "setup" channel method with appName',
      () async {
        await gateway.setup('Clean Architecture Starter');

        expect(log.single.method, 'setup');
        expect(log.single.arguments['appName'], 'Clean Architecture Starter');
      },
    );

    test(
      'Method show() invokes the "notify" channel method with the given title, body, and actions',
      () async {
        await gateway.show(
          title: 'Restart pending',
          body: 'A restart is needed.',
          actionLabels: const ['Restart now'],
        );

        expect(log.single.method, 'notify');
        expect(log.single.arguments['title'], 'Restart pending');
        expect(log.single.arguments['body'], 'A restart is needed.');
        expect(log.single.arguments['actions'], [
          {'type': 'button', 'text': 'Restart now'},
        ]);
      },
    );

    test('Method show() returns a non-empty identifier', () async {
      final String identifier = await gateway.show(title: 'Restart pending');

      expect(identifier, isA<String>());
      expect(identifier, isNotEmpty);
    });

    test(
      'Method show() invokes onClick when the platform reports a click on the notification',
      () async {
        bool clicked = false;
        final String identifier = await gateway.show(
          title: 'Restart pending',
          onClick: () => clicked = true,
        );

        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage(
              'local_notifier',
              const StandardMethodCodec().encodeMethodCall(
                MethodCall('onLocalNotificationClick', {
                  'notificationId': identifier,
                }),
              ),
              (_) {},
            );

        expect(clicked, isTrue);
      },
    );

    test(
      'Method close() invokes the "close" channel method for an identifier returned by show()',
      () async {
        final String identifier = await gateway.show(title: 'Restart pending');
        log.clear();

        await gateway.close(identifier);

        expect(log.single.method, 'close');
      },
    );

    test(
      'Method close() does not invoke the channel when the identifier was never shown',
      () async {
        await gateway.close('unknown-identifier');

        expect(log, isEmpty);
      },
    );
  });
}
