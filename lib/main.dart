// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:redux/redux.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'i18n/strings.g.dart';
import 'injection_container.dart';
import 'shared/db/app_data_root_service.dart';
import 'shared/failures/failures.dart';
import 'shared/navigation/app_routes.dart';
import 'shared/notifications/system_notification_service.dart';
import 'shared/snugtoast/snugtoast_manager.dart';
import 'shared/snugtoast/snugtoast_wrapper.widget.dart';
import 'shared/state/app.state.dart';
import 'shared/state/create_store.dart';
import 'shared/theme/app_font.dart';
import 'shared/theme/app_font_presets.dart';
import 'shared/theme/app_language.dart';
import 'shared/theme/app_shape.dart';
import 'shared/theme/app_spacing.dart';
import 'shared/theme/app_spacing_theme_extension.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/app_theme_data.dart';
import 'shared/theme/app_zoom.dart';
import 'shared/utils/logger_service.dart';
import 'shared/window/window_controller.dart';

Future<void> main() async {
  // marionette_flutter's binding replaces WidgetsFlutterBinding in debug
  // builds only, so the MCP tooling never ships in a release build.
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await windowManager.ensureInitialized();
  await initDependencies();
  await sl<SystemNotificationService>().initialize();
  await (await sl<AppDataRootService>().applyPendingMoveIfNeeded()).fold((
    Failure failure,
  ) async {
    sl<LoggerService>().e(failure.message);
    await sl<SystemNotificationService>().show(
      title:
          t.settings.general.defaultSaveLocation.moveFailedNotification.title,
      body: t.settings.general.defaultSaveLocation.moveFailedNotification.body,
    );
  }, (_) async {});
  // Applied before runApp() rather than left to WindowRouteWatcher alone:
  // the native Windows runner shows the window right after Flutter's first
  // frame (flutter_window.cpp's SetNextFrameCallback), which happens before
  // WindowRouteWatcher's own (unawaited) lockHome() call resolves. Awaiting
  // it here, while the window is still hidden, means that first frame is
  // already laid out at the correct size — WindowRouteWatcher's later call
  // becomes a harmless no-op resize to the same value.
  await sl<WindowController>().lockHome();

  runApp(TranslationProvider(child: const App()));
}

/// Root application widget. Owns the Redux store and router instances.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Store<AppState> _store;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _store = CreateStore()();
    _router = sl<GoRouter>();
  }

  /// Computed fresh on every build rather than tracked as separate state
  /// updated via a router listener — a listener-driven copy raced against
  /// `MaterialApp.router`'s own internal rebuild on navigation (which swaps
  /// the actual routed `child`), so for one frame either the new screen
  /// could render at the old screen's zoom, or the old screen at the new
  /// screen's zoom, depending on ordering — overflowing whenever that
  /// mismatched zoom was the larger one. Reading `currentConfiguration`
  /// directly here, at the exact moment this rebuilds (which
  /// `MaterialApp.router` already guarantees happens on every route change,
  /// since it rebuilds this whole subtree with a new `child` then), can't
  /// desync from whatever screen is actually being built. An empty
  /// `configuration` counts as home too: this `AnimatedBuilder` is an
  /// ancestor of the internal `Router`, so on the very first build
  /// `currentConfiguration` is always still empty — the `Router` hasn't
  /// mounted and resolved `initialLocation` yet. Since that's hardcoded to
  /// [AppRoutes.home] with no redirect, "not yet resolved" only ever means
  /// "about to show home" here.
  ///
  /// The result also collapses this build method's `zoomLevel` to 100 on
  /// Home — that screen ignores the interactive Text Size slider entirely,
  /// since [HomeWindowSizeService] caches its window size per font/density
  /// combination only, with no zoom-level axis. It still follows the chosen
  /// font and [fontSizeFactorPresets]/[AppZoom.baselineBump]'s always-on
  /// corrections, same as every other screen.
  bool _computeIsHomeRoute() {
    final RouteMatchList configuration =
        _router.routerDelegate.currentConfiguration;

    return configuration.isEmpty ||
        configuration.last.matchedLocation == AppRoutes.home;
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: SnugToastWrapper(
        manager: sl<SnugToastManager>(),
        child: MaterialApp.router(
          title: t.appTitle,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          locale: sl<AppLanguage>().locale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => AnimatedBuilder(
            animation: Listenable.merge([
              sl<AppTheme>(),
              sl<AppShape>(),
              sl<AppSpacing>(),
              sl<AppZoom>(),
              sl<AppFont>(),
              sl<AppLanguage>(),
            ]),
            builder: (context, _) {
              final ColorScheme colorScheme = sl<AppTheme>().colorScheme;
              final double cornerRadius = sl<AppShape>().cornerRadius;
              final VisualDensity visualDensity =
                  sl<AppSpacing>().visualDensity;
              final AppSpacingThemeExtension spacingValues =
                  sl<AppSpacing>().spacingValues;
              final bool isHomeRoute = _computeIsHomeRoute();
              final double zoomLevel = isHomeRoute ? 100 : sl<AppZoom>().level;
              final double fontSizeFactor =
                  fontSizeFactorPresets[sl<AppFont>().fontId] ?? 1;
              final double fontAndBaselineScale =
                  fontSizeFactor * AppZoom.baselineBump;
              return Theme(
                data: buildAppThemeData(
                  colorScheme,
                  cornerRadius,
                  visualDensity: visualDensity,
                  spacingValues: spacingValues,
                  fontId: sl<AppFont>().fontId,
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(
                      (zoomLevel / 100) * fontAndBaselineScale,
                    ),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
