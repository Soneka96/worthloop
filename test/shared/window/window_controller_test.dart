// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:worth_loop/shared/notifications/system_notification_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/window/Iwindow.gateway.dart';
import 'package:worth_loop/shared/window/home_window_size_service.dart';
import 'package:worth_loop/shared/window/window_controller.dart';

class MockIWindowGateway extends Mock implements IWindowGateway {}

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

class MockHomeWindowSizeService extends Mock implements HomeWindowSizeService {}

class MockSystemNotificationService extends Mock
    implements SystemNotificationService {}

class FakeWindowListener extends Fake implements WindowListener {}

void main() {
  setUpAll(() {
    registerFallbackValue(Size.zero);
    registerFallbackValue(Offset.zero);
    registerFallbackValue(Rect.zero);
    registerFallbackValue(FakeWindowListener());
  });

  group('WindowController behaves correctly', () {
    late MockIWindowGateway mockGateway;
    late MockAppPreferencesStore mockStore;
    late MockHomeWindowSizeService mockHomeWindowSizeService;
    late MockSystemNotificationService mockNotificationService;
    late WindowController controller;

    setUp(() {
      mockGateway = MockIWindowGateway();
      mockStore = MockAppPreferencesStore();
      mockHomeWindowSizeService = MockHomeWindowSizeService();
      mockNotificationService = MockSystemNotificationService();
      when(
        () => mockNotificationService.closeActive(),
      ).thenAnswer((_) async {});
      when(
        () => mockHomeWindowSizeService.homeSize,
      ).thenReturn(const Size(560, 420));
      when(() => mockGateway.setResizable(any())).thenAnswer((_) async {});
      when(() => mockGateway.setMaximizable(any())).thenAnswer((_) async {});
      when(() => mockGateway.setBounds(any())).thenAnswer((_) async {});
      when(
        () => mockGateway.getCenteredPosition(any()),
      ).thenAnswer((_) async => const Offset(190, 80));
      when(() => mockGateway.maximize()).thenAnswer((_) async {});
      when(() => mockGateway.isMinimized()).thenAnswer((_) async => false);
      when(() => mockGateway.isPreventClose()).thenAnswer((_) async => true);
      when(() => mockGateway.setPreventClose(any())).thenAnswer((_) async {});
      when(() => mockGateway.setMinimumSize(any())).thenAnswer((_) async {});
      when(
        () => mockGateway.getSize(),
      ).thenAnswer((_) async => const Size(1000, 700));
      when(
        () => mockGateway.getContentSize(),
      ).thenReturn(const Size(1000, 700));
      when(
        () => mockGateway.getPosition(),
      ).thenAnswer((_) async => const Offset(50, 60));
      when(() => mockGateway.destroy()).thenAnswer((_) async {});
      when(() => mockGateway.addListener(any())).thenReturn(null);
      when(() => mockStore.readWindowSize()).thenAnswer((_) async => null);
      when(() => mockStore.readWindowPosition()).thenAnswer((_) async => null);
      when(() => mockStore.writeWindowSize(any())).thenAnswer((_) async {});
      when(() => mockStore.writeWindowPosition(any())).thenAnswer((_) async {});
      controller = WindowController(
        mockGateway,
        mockStore,
        mockHomeWindowSizeService,
        mockNotificationService,
      );
    });

    test(
      'WindowController registers itself as a listener when constructed',
      () {
        verify(() => mockGateway.addListener(controller)).called(1);
      },
    );

    test('WindowController enables prevent-close when constructed', () {
      verify(() => mockGateway.setPreventClose(true)).called(1);
    });

    test('WindowController sets a 600x400 minimum size when constructed', () {
      verify(() => mockGateway.setMinimumSize(const Size(600, 400))).called(1);
    });

    test('lockHome calls IWindowGateway.setResizable() with false', () async {
      await controller.lockHome();

      verify(() => mockGateway.setResizable(false)).called(1);
    });

    test('lockHome calls IWindowGateway.setMaximizable() with false', () async {
      await controller.lockHome();

      verify(() => mockGateway.setMaximizable(false)).called(1);
    });

    test(
      'lockHome calls IWindowGateway.setBounds() centered around HomeWindowSizeService.homeSize, '
      'plus a 1px safety margin against window_manager\'s native rounding',
      () async {
        await controller.lockHome();

        verify(
          () => mockGateway.setBounds(const Rect.fromLTWH(190, 80, 561, 421)),
        ).called(1);
      },
    );

    test(
      'lockHome uses whatever size HomeWindowSizeService.homeSize currently reports',
      () async {
        when(
          () => mockHomeWindowSizeService.homeSize,
        ).thenReturn(const Size(640, 500));

        await controller.lockHome();

        verify(
          () => mockGateway.setBounds(const Rect.fromLTWH(190, 80, 641, 501)),
        ).called(1);
      },
    );

    test('lockHome adds the gap between getSize() (outer) and getContentSize() '
        '(Flutter\'s view) to homeSize before calling setBounds() — setBounds '
        'takes outer-rect dimensions, not content dimensions', () async {
      when(
        () => mockGateway.getSize(),
      ).thenAnswer((_) async => const Size(1000, 738));
      when(
        () => mockGateway.getContentSize(),
      ).thenReturn(const Size(1000, 700));

      await controller.lockHome();

      verify(
        () => mockGateway.setBounds(const Rect.fromLTWH(190, 80, 561, 459)),
      ).called(1);
    });

    test(
      'lockHome measures the frame overhead only once, reusing it on later calls',
      () async {
        await controller.lockHome();
        when(
          () => mockGateway.getSize(),
        ).thenAnswer((_) async => const Size(999999, 999999));

        await controller.lockHome();

        verify(
          () => mockGateway.setBounds(const Rect.fromLTWH(190, 80, 561, 421)),
        ).called(2);
      },
    );

    test(
      'lockHome does not persist anything on the very first call, before any non-Home geometry has ever been seen',
      () async {
        await controller.lockHome();

        verifyNever(() => mockStore.writeWindowSize(any()));
        verifyNever(() => mockStore.writeWindowPosition(any()));
      },
    );

    test(
      'lockHome persists the last known non-Home geometry before locking',
      () async {
        await controller.unlockAndRestore();
        controller.onWindowResized();
        await Future<void>.delayed(Duration.zero);

        await controller.lockHome();

        verify(
          () => mockStore.writeWindowSize(const Size(1000, 700)),
        ).called(1);
        verify(
          () => mockStore.writeWindowPosition(const Offset(50, 60)),
        ).called(1);
      },
    );

    test(
      'onWindowMaximize caches geometry, since it is a separate event from resize',
      () async {
        await controller.unlockAndRestore();
        when(
          () => mockGateway.getSize(),
        ).thenAnswer((_) async => const Size(1920, 1080));
        when(
          () => mockGateway.getPosition(),
        ).thenAnswer((_) async => Offset.zero);
        controller.onWindowMaximize();
        await Future<void>.delayed(Duration.zero);

        await controller.lockHome();

        verify(
          () => mockStore.writeWindowSize(const Size(1920, 1080)),
        ).called(1);
        verify(() => mockStore.writeWindowPosition(Offset.zero)).called(1);
      },
    );

    test(
      'onWindowUnmaximize caches geometry, since it is a separate event from resize',
      () async {
        await controller.unlockAndRestore();
        when(
          () => mockGateway.getSize(),
        ).thenAnswer((_) async => const Size(900, 600));
        when(
          () => mockGateway.getPosition(),
        ).thenAnswer((_) async => const Offset(20, 20));
        controller.onWindowUnmaximize();
        await Future<void>.delayed(Duration.zero);

        await controller.lockHome();

        verify(() => mockStore.writeWindowSize(const Size(900, 600))).called(1);
        verify(
          () => mockStore.writeWindowPosition(const Offset(20, 20)),
        ).called(1);
      },
    );

    test(
      'unlockAndRestore calls IWindowGateway.setBounds() with the persisted size and position when both exist',
      () async {
        when(
          () => mockStore.readWindowSize(),
        ).thenAnswer((_) async => const Size(1100, 750));
        when(
          () => mockStore.readWindowPosition(),
        ).thenAnswer((_) async => const Offset(40, 30));

        await controller.unlockAndRestore();

        verify(
          () => mockGateway.setBounds(const Rect.fromLTWH(40, 30, 1100, 750)),
        ).called(1);
      },
    );

    test(
      'unlockAndRestore calls IWindowGateway.maximize() when no size is persisted',
      () async {
        when(
          () => mockStore.readWindowPosition(),
        ).thenAnswer((_) async => const Offset(40, 30));

        await controller.unlockAndRestore();

        verify(() => mockGateway.maximize()).called(1);
        verifyNever(() => mockGateway.setBounds(any()));
      },
    );

    test(
      'unlockAndRestore calls IWindowGateway.maximize() when no position is persisted',
      () async {
        when(
          () => mockStore.readWindowSize(),
        ).thenAnswer((_) async => const Size(1100, 750));

        await controller.unlockAndRestore();

        verify(() => mockGateway.maximize()).called(1);
        verifyNever(() => mockGateway.setBounds(any()));
      },
    );

    test(
      'unlockAndRestore calls IWindowGateway.maximize() when the persisted size is a minimized-window sentinel, not the actual window size',
      () async {
        when(
          () => mockStore.readWindowSize(),
        ).thenAnswer((_) async => const Size(156, 35.2));
        when(
          () => mockStore.readWindowPosition(),
        ).thenAnswer((_) async => const Offset(-12800, -12800));

        await controller.unlockAndRestore();

        verify(() => mockGateway.maximize()).called(1);
        verifyNever(() => mockGateway.setBounds(any()));
      },
    );

    test(
      'unlockAndRestore calls IWindowGateway.setResizable() with true',
      () async {
        await controller.unlockAndRestore();

        verify(() => mockGateway.setResizable(true)).called(1);
      },
    );

    test(
      'unlockAndRestore calls IWindowGateway.setMaximizable() with true',
      () async {
        await controller.unlockAndRestore();

        verify(() => mockGateway.setMaximizable(true)).called(1);
      },
    );

    test(
      'onWindowClose persists the window size and position and destroys the window when isPreventClose returns true and Home is not active',
      () async {
        await controller.unlockAndRestore();

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockStore.writeWindowSize(const Size(1000, 700)),
        ).called(1);
        verify(
          () => mockStore.writeWindowPosition(const Offset(50, 60)),
        ).called(1);
        verify(() => mockGateway.destroy()).called(1);
      },
    );

    test(
      'onWindowClose does not persist the window size or position when Home is active',
      () async {
        await controller.lockHome();

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockStore.writeWindowSize(any()));
        verifyNever(() => mockStore.writeWindowPosition(any()));
        verify(() => mockGateway.destroy()).called(1);
      },
    );

    test(
      'onWindowClose persists the cached pre-minimize geometry, not a live query, when the window is minimized',
      () async {
        controller.onWindowResized();
        await Future<void>.delayed(Duration.zero);
        when(
          () => mockGateway.getSize(),
        ).thenAnswer((_) async => const Size(1, 1));
        when(
          () => mockGateway.getPosition(),
        ).thenAnswer((_) async => const Offset(1, 1));
        when(() => mockGateway.isMinimized()).thenAnswer((_) async => true);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verify(
          () => mockStore.writeWindowSize(const Size(1000, 700)),
        ).called(1);
        verify(
          () => mockStore.writeWindowPosition(const Offset(50, 60)),
        ).called(1);
      },
    );

    test(
      'onWindowClose does not persist anything when the window is minimized and no geometry was ever cached',
      () async {
        when(() => mockGateway.isMinimized()).thenAnswer((_) async => true);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockStore.writeWindowSize(any()));
        verifyNever(() => mockStore.writeWindowPosition(any()));
      },
    );

    test(
      'onWindowClose does not persist a live query that is a minimized-window sentinel despite isMinimized() reporting false',
      () async {
        when(
          () => mockGateway.getSize(),
        ).thenAnswer((_) async => const Size(156, 35.2));

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockStore.writeWindowSize(any()));
        verifyNever(() => mockStore.writeWindowPosition(any()));
      },
    );

    test(
      'onWindowResized does not cache a minimized-window sentinel size',
      () async {
        when(
          () => mockGateway.getSize(),
        ).thenAnswer((_) async => const Size(156, 35.2));
        controller.onWindowResized();
        await Future<void>.delayed(Duration.zero);
        when(() => mockGateway.isMinimized()).thenAnswer((_) async => true);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockStore.writeWindowSize(any()));
        verifyNever(() => mockStore.writeWindowPosition(any()));
      },
    );

    test(
      'onWindowResized does not cache geometry while Home is active',
      () async {
        await controller.lockHome();
        controller.onWindowResized();
        await Future<void>.delayed(Duration.zero);
        await controller.unlockAndRestore();
        when(() => mockGateway.isMinimized()).thenAnswer((_) async => true);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockStore.writeWindowSize(any()));
        verifyNever(() => mockStore.writeWindowPosition(any()));
      },
    );

    test(
      'onWindowClose does not persist the window size when isPreventClose returns false',
      () async {
        when(() => mockGateway.isPreventClose()).thenAnswer((_) async => false);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockStore.writeWindowSize(any()));
      },
    );

    test(
      'onWindowClose does not destroy the window when isPreventClose returns false',
      () async {
        when(() => mockGateway.isPreventClose()).thenAnswer((_) async => false);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockGateway.destroy());
      },
    );

    test(
      'onWindowClose calls SystemNotificationService.closeActive() when isPreventClose returns true',
      () async {
        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verify(() => mockNotificationService.closeActive()).called(1);
      },
    );

    test(
      'onWindowClose does not call SystemNotificationService.closeActive() when isPreventClose returns false',
      () async {
        when(() => mockGateway.isPreventClose()).thenAnswer((_) async => false);

        controller.onWindowClose();
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => mockNotificationService.closeActive());
      },
    );
  });
}
