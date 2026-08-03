// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/screens/github_explorer.screen.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/viewmodels/github_explorer_screen.viewmodel.dart';
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/screens/app_settings.screen.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/navigation/app_router.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/window_route_watcher.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';
import 'package:worth_loop/shared/window/window_controller.dart';

class MockWindowController extends Mock implements WindowController {}

void main() {
  late Store<AppState> store;

  setUp(() {
    store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );

    sl.registerLazySingleton<AppTheme>(AppTheme.new);
    sl.registerLazySingleton<AppShape>(AppShape.new);
    sl.registerLazySingleton<AppSpacing>(AppSpacing.new);
    sl.registerLazySingleton<AppZoom>(AppZoom.new);
    sl.registerLazySingleton<AppFont>(AppFont.new);
    sl.registerFactoryParam<
      GithubExplorerScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => GithubExplorerScreenViewModel.fromStore(store));
    sl.registerFactoryParam<HomeScreenViewModel, Store<AppState>, void>(
      (store, _) => HomeScreenViewModel.fromStore(store),
    );
  });

  tearDown(() => sl.reset());

  group('GoRouter instantiates the correct screen', () {
    testWidgets('GoRouter starts at the HomeScreen', (tester) async {
      final GoRouter router = createRouter();

      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: store,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('GoRouter navigates to the GithubExplorerScreen', (
      tester,
    ) async {
      final GoRouter router = createRouter();

      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: store,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      router.go(AppRoutes.githubExplorer);
      await tester.pumpAndSettle();

      expect(find.byType(GithubExplorerScreen), findsOneWidget);
    });

    testWidgets('GoRouter navigates to the AppSettingsScreen', (tester) async {
      final GoRouter router = createRouter();

      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: store,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      router.go(AppRoutes.appSettings);
      await tester.pumpAndSettle();

      expect(find.byType(AppSettingsScreen), findsOneWidget);
    });
  });

  group("GoRouter's window-lock watcher behaves correctly", () {
    testWidgets(
      'WindowRouteWatcher calls lockHome() when GoRouter starts at AppRoutes.home',
      (tester) async {
        final MockWindowController mockWindowController =
            MockWindowController();
        when(() => mockWindowController.lockHome()).thenAnswer((_) async {});
        when(
          () => mockWindowController.unlockAndRestore(),
        ).thenAnswer((_) async {});

        final GoRouter router = createRouter();
        WindowRouteWatcher(mockWindowController).attachTo(router);

        await tester.pumpWidget(
          StoreProvider<AppState>(
            store: store,
            child: MaterialApp.router(routerConfig: router),
          ),
        );

        verify(() => mockWindowController.lockHome()).called(greaterThan(0));
        verifyNever(() => mockWindowController.unlockAndRestore());
      },
    );

    testWidgets(
      'WindowRouteWatcher calls unlockAndRestore() when GoRouter navigates to AppRoutes.appSettings',
      (tester) async {
        final MockWindowController mockWindowController =
            MockWindowController();
        when(() => mockWindowController.lockHome()).thenAnswer((_) async {});
        when(
          () => mockWindowController.unlockAndRestore(),
        ).thenAnswer((_) async {});

        final GoRouter router = createRouter();
        WindowRouteWatcher(mockWindowController).attachTo(router);

        await tester.pumpWidget(
          StoreProvider<AppState>(
            store: store,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        router.push(AppRoutes.appSettings);
        await tester.pumpAndSettle();

        verify(
          () => mockWindowController.unlockAndRestore(),
        ).called(greaterThan(0));
      },
    );

    testWidgets(
      'WindowRouteWatcher calls lockHome() when GoRouter pops back to AppRoutes.home from AppRoutes.appSettings',
      (tester) async {
        final MockWindowController mockWindowController =
            MockWindowController();
        when(() => mockWindowController.lockHome()).thenAnswer((_) async {});
        when(
          () => mockWindowController.unlockAndRestore(),
        ).thenAnswer((_) async {});

        final GoRouter router = createRouter();
        WindowRouteWatcher(mockWindowController).attachTo(router);

        await tester.pumpWidget(
          StoreProvider<AppState>(
            store: store,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        router.push(AppRoutes.appSettings);
        await tester.pumpAndSettle();
        clearInteractions(mockWindowController);

        router.pop();
        await tester.pumpAndSettle();

        verify(() => mockWindowController.lockHome()).called(greaterThan(0));
      },
    );
  });
}
