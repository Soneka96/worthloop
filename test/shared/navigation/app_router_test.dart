// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/screens/product_details.screen.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/screens/app_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/navigation/app_router.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';

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
    sl.registerLazySingleton<AppLanguage>(AppLanguage.new);
    sl.registerLazySingleton<PackageInfo>(
      () => PackageInfo(
        appName: 'WorthLoop Test',
        packageName: 'io.github.soneka96.worthloop',
        version: '0.0.0-test',
        buildNumber: '0',
      ),
    );
    sl.registerFactoryParam<HomeScreenViewModel, Store<AppState>, void>(
      (store, _) => HomeScreenViewModel.fromStore(store),
    );
    sl.registerFactoryParam<ProductDetailsViewModel, Store<AppState>, String>(
      (store, productId) => ProductDetailsViewModel.fromStore(store, productId),
    );
    sl.registerFactoryParam<
      GeneralSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => GeneralSettingsScreenViewModel.fromStore(store));
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

    testWidgets('GoRouter navigates to the ProductDetailsScreen', (
      tester,
    ) async {
      final GoRouter router = createRouter();

      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: store,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      router.go(AppRoutes.productDetailsPath('product-1'));
      await tester.pumpAndSettle();

      final ProductDetailsScreen screen = tester.widget(
        find.byType(ProductDetailsScreen),
      );
      expect(screen.productId, isA<String>());
      expect(screen.productId, 'product-1');
    });
  });
}
