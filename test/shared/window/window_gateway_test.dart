// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:worth_loop/shared/window/window_gateway.dart';

class FakeWindowListener with WindowListener {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel windowManagerChannel = MethodChannel('window_manager');
  const MethodChannel screenRetrieverChannel = MethodChannel(
    'dev.leanflutter.plugins/screen_retriever',
  );
  late List<MethodCall> log;
  late WindowGateway gateway;

  setUp(() {
    log = [];
    gateway = WindowGateway();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(windowManagerChannel, (
          MethodCall call,
        ) async {
          log.add(call);
          switch (call.method) {
            case 'getBounds':
              return {'x': 10.0, 'y': 20.0, 'width': 800.0, 'height': 600.0};
            case 'isMinimized':
              return true;
            case 'isPreventClose':
              return true;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(windowManagerChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(screenRetrieverChannel, null);
  });

  group('WindowGateway behaves correctly', () {
    test(
      'Method setResizable() invokes the "setResizable" channel method with isResizable',
      () async {
        await gateway.setResizable(false);

        expect(log.single.method, 'setResizable');
        expect(log.single.arguments['isResizable'], isFalse);
      },
    );

    test(
      'Method setMaximizable() invokes the "setMaximizable" channel method with isMaximizable',
      () async {
        await gateway.setMaximizable(false);

        expect(log.single.method, 'setMaximizable');
        expect(log.single.arguments['isMaximizable'], isFalse);
      },
    );

    test(
      'Method setMinimumSize() invokes the "setMinimumSize" channel method with width and height',
      () async {
        await gateway.setMinimumSize(const Size(200, 200));

        expect(log.single.method, 'setMinimumSize');
        expect(log.single.arguments['width'], 200.0);
        expect(log.single.arguments['height'], 200.0);
      },
    );

    test(
      'Method getSize() returns a Size built from the "getBounds" channel response',
      () async {
        final Size result = await gateway.getSize();

        expect(result, isA<Size>());
        expect(result, const Size(800, 600));
      },
    );

    test(
      "Method getContentSize() returns the current view's physicalSize divided by devicePixelRatio",
      () {
        final FlutterView view = PlatformDispatcher.instance.views.first;

        final Size result = gateway.getContentSize();

        expect(result, isA<Size>());
        expect(result, view.physicalSize / view.devicePixelRatio);
      },
    );

    test(
      'Method getPosition() returns an Offset built from the "getBounds" channel response',
      () async {
        final Offset result = await gateway.getPosition();

        expect(result, isA<Offset>());
        expect(result, const Offset(10, 20));
      },
    );

    test(
      "Method setBounds() invokes the \"setBounds\" channel method with the bounds' x, y, width, and height",
      () async {
        await gateway.setBounds(const Rect.fromLTWH(1, 2, 300, 400));

        expect(log.single.method, 'setBounds');
        expect(log.single.arguments['x'], 1.0);
        expect(log.single.arguments['y'], 2.0);
        expect(log.single.arguments['width'], 300.0);
        expect(log.single.arguments['height'], 400.0);
      },
    );

    test(
      'Method getCenteredPosition() returns the position that centers size on the primary display',
      () async {
        const Map<String, dynamic> displayJson = {
          'id': '1',
          'size': {'width': 1920.0, 'height': 1080.0},
          'visiblePosition': {'dx': 0.0, 'dy': 0.0},
          'visibleSize': {'width': 1920.0, 'height': 1040.0},
          'scaleFactor': 1,
        };
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(screenRetrieverChannel, (
              MethodCall call,
            ) async {
              switch (call.method) {
                case 'getCursorScreenPoint':
                  return {'dx': 960.0, 'dy': 520.0};
                case 'getPrimaryDisplay':
                  return displayJson;
                case 'getAllDisplays':
                  return {
                    'displays': [displayJson],
                  };
                default:
                  return null;
              }
            });

        final Offset result = await gateway.getCenteredPosition(
          const Size(400, 300),
        );

        expect(result, isA<Offset>());
        expect(result, const Offset(760, 370));
      },
    );

    test('Method maximize() invokes the "maximize" channel method', () async {
      await gateway.maximize();

      expect(log.single.method, 'maximize');
    });

    test(
      'Method isMinimized() returns the "isMinimized" channel response',
      () async {
        final bool result = await gateway.isMinimized();

        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );

    test(
      'Method isPreventClose() returns the "isPreventClose" channel response',
      () async {
        final bool result = await gateway.isPreventClose();

        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );

    test(
      'Method setPreventClose() invokes the "setPreventClose" channel method with isPreventClose',
      () async {
        await gateway.setPreventClose(true);

        expect(log.single.method, 'setPreventClose');
        expect(log.single.arguments['isPreventClose'], isTrue);
      },
    );

    test('Method hide() invokes the "hide" channel method', () async {
      await gateway.hide();

      expect(log.single.method, 'hide');
    });

    test('Method close() invokes the "close" channel method', () async {
      await gateway.close();

      expect(log.single.method, 'close');
    });

    test('Method destroy() invokes the "destroy" channel method', () async {
      await gateway.destroy();

      expect(log.single.method, 'destroy');
    });

    test('Method addListener() registers listener with windowManager', () {
      final FakeWindowListener listener = FakeWindowListener();

      gateway.addListener(listener);

      expect(windowManager.listeners, contains(listener));
      windowManager.removeListener(listener);
    });

    test('Method removeListener() unregisters listener from windowManager', () {
      final FakeWindowListener listener = FakeWindowListener();
      windowManager.addListener(listener);

      gateway.removeListener(listener);

      expect(windowManager.listeners, isNot(contains(listener)));
    });
  });
}
