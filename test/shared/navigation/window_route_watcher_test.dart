// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/navigation/window_route_watcher.dart';
import 'package:worth_loop/shared/window/window_controller.dart';

class MockWindowController extends Mock implements WindowController {}

void main() {
  late MockWindowController mockWindowController;

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const SizedBox(),
        ),
        GoRoute(
          path: '/other',
          name: 'other',
          builder: (context, state) => const SizedBox(),
        ),
      ],
    );
  }

  setUp(() {
    mockWindowController = MockWindowController();
    when(() => mockWindowController.lockHome()).thenAnswer((_) async {});
    when(
      () => mockWindowController.unlockAndRestore(),
    ).thenAnswer((_) async {});
  });

  group('WindowRouteWatcher behaves correctly', () {
    testWidgets(
      'attachTo calls WindowController.lockHome() when the router is already at "/"',
      (tester) async {
        final GoRouter router = buildRouter();

        WindowRouteWatcher(mockWindowController).attachTo(router);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));

        verify(() => mockWindowController.lockHome()).called(greaterThan(0));
        verifyNever(() => mockWindowController.unlockAndRestore());
      },
    );

    testWidgets(
      'attachTo calls WindowController.unlockAndRestore() when the router navigates to "/other"',
      (tester) async {
        final GoRouter router = buildRouter();

        WindowRouteWatcher(mockWindowController).attachTo(router);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        router.go('/other');
        await tester.pumpAndSettle();

        verify(
          () => mockWindowController.unlockAndRestore(),
        ).called(greaterThan(0));
      },
    );

    testWidgets(
      'attachTo calls WindowController.unlockAndRestore() when the router pushes "/other"',
      (tester) async {
        final GoRouter router = buildRouter();

        WindowRouteWatcher(mockWindowController).attachTo(router);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        router.push('/other');
        await tester.pumpAndSettle();

        verify(
          () => mockWindowController.unlockAndRestore(),
        ).called(greaterThan(0));
      },
    );

    testWidgets(
      'attachTo calls WindowController.lockHome() when the router pops back to "/" from a pushed "/other"',
      (tester) async {
        final GoRouter router = buildRouter();

        WindowRouteWatcher(mockWindowController).attachTo(router);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        router.push('/other');
        await tester.pumpAndSettle();
        clearInteractions(mockWindowController);

        router.pop();
        await tester.pumpAndSettle();

        verify(() => mockWindowController.lockHome()).called(greaterThan(0));
      },
    );
  });
}
