// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'i18n/strings.g.dart';
import 'injection_container.dart';
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
import 'shared/widgets/app_launch_splash.widget.dart';
import 'shared/utils/android_price_alert_notification_service.dart';
import 'shared/navigation/app_routes.dart';
import 'shared/navigation/navigator_service.dart';

Future<void> main() async {
  // marionette_flutter's binding replaces WidgetsFlutterBinding in debug
  // builds only, so the MCP tooling never ships in a release build.
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await initDependencies();
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
  bool _showLaunchSplash = true;
  String? _pendingPriceAlertProductId;

  @override
  void initState() {
    super.initState();
    _store = CreateStore()();
    _router = sl<GoRouter>();
    final AndroidPriceAlertNotificationService notifications =
        sl<AndroidPriceAlertNotificationService>();
    notifications.listenForPriceAlertTaps(_handlePriceAlertTap);
    notifications.getInitialPriceAlertProductId().then((String? productId) {
      if (productId != null) _handlePriceAlertTap(productId);
    });
  }

  void _handlePriceAlertTap(String productId) {
    if (_showLaunchSplash) {
      _pendingPriceAlertProductId = productId;
      return;
    }
    sl<NavigatorService>().push(AppRoutes.productDetailsPath(productId));
  }

  void _finishLaunchSplash() {
    setState(() => _showLaunchSplash = false);
    final String? productId = _pendingPriceAlertProductId;
    _pendingPriceAlertProductId = null;
    if (productId != null) {
      sl<NavigatorService>().push(AppRoutes.productDetailsPath(productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showLaunchSplash) {
      return AppLaunchSplash(onFinished: _finishLaunchSplash);
    }

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
              final double zoomLevel = sl<AppZoom>().level;
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
                  child: SafeArea(
                    key: const Key('app-bottom-safe-area'),
                    top: false,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
