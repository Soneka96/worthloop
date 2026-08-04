// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/app_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_language.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_spacing.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/theme/app_zoom.dart';

class MockGeneralSettingsScreenViewModel extends Mock
    implements GeneralSettingsScreenViewModel {}

void main() {
  late MockGeneralSettingsScreenViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    mockViewModel = MockGeneralSettingsScreenViewModel();
    when(() => mockViewModel.refreshIntervalMinutes).thenReturn(60);
    when(() => mockViewModel.isRefreshIntervalBusy).thenReturn(false);
    when(() => mockViewModel.onCheckForUpdates).thenReturn(() {});
    when(() => mockViewModel.onOpenPrivacyPolicy).thenReturn(() {});
    when(() => mockViewModel.onRefreshIntervalSelected).thenReturn((_) {});

    sl.registerLazySingleton<AppTheme>(AppTheme.new);
    sl.registerLazySingleton<AppShape>(AppShape.new);
    sl.registerLazySingleton<AppSpacing>(AppSpacing.new);
    sl.registerLazySingleton<AppZoom>(AppZoom.new);
    sl.registerLazySingleton<AppFont>(AppFont.new);
    sl.registerLazySingleton<AppLanguage>(AppLanguage.new);
    sl.registerLazySingleton<PackageInfo>(
      () => PackageInfo(
        appName: 'WorthLoop Test',
        packageName: 'io.github.soneka96.worthloop.test',
        version: '0.0.0-test',
        buildNumber: '0',
      ),
    );
    sl.registerFactoryParam<
      GeneralSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => mockViewModel);

    store = Store<AppState>(appReducer, initialState: AppState.initial());
  });
  tearDown(() async {
    await sl.reset();
    reset(mockViewModel);
  });

  Widget buildWidget({
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child ?? const SizedBox.shrink(),
        ),
        home: const AppSettingsScreen(),
      ),
    );
  }

  bool hasPrimaryFocusWithin(WidgetTester tester, Finder finder) {
    final BuildContext? focusContext =
        FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) {
      return false;
    }

    final Element target = tester.element(finder);
    if (focusContext == target) {
      return true;
    }

    bool found = false;
    (focusContext as Element).visitAncestorElements((Element ancestor) {
      found = ancestor == target;
      return !found;
    });
    return found;
  }

  group('AppSettingsScreen contains widgets', () {
    testWidgets(
      'AppSettingsScreen contains an AppBar with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
      },
    );

    testWidgets(
      'AppSettingsScreen contains a "settings-category-selector" SegmentedButton with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final SegmentedButton<SettingsCategory> selector = tester.widget(
          find.byKey(const Key('settings-category-selector')),
        );

        expect(selector.segments.length, isA<int>());
        expect(selector.segments.length, 2);
      },
    );

    testWidgets(
      'AppSettingsScreen contains GeneralSettingsScreen with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(GeneralSettingsScreen), findsOneWidget);
      },
    );

    testWidgets('AppSettingsScreen contains only mobile settings categories', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Profile'), findsNothing);
      expect(find.text('Editor'), findsNothing);
      expect(find.text('Logs'), findsNothing);
    });
  });

  group("AppSettingsScreen's elements behavior", () {
    testWidgets(
      'AppSettingsScreen shows AppearanceSettingsScreen when the Appearance category is tapped',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.text('Appearance'));
        await tester.pump();

        expect(find.byType(AppearanceSettingsScreen), findsOneWidget);
      },
    );
  });

  group('AppSettingsScreen meets the accessibility recommended guidelines', () {
    testWidgets('AppSettingsScreen meets WCAG contrast guidelines', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(buildWidget());
        await expectLater(tester, meetsGuideline(textContrastGuideline));

        await tester.pumpWidget(buildWidget(themeMode: ThemeMode.dark));
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });

    testWidgets('AppSettingsScreen all tap targets meet minimum 48dp size', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets(
      'AppSettingsScreen all interactive elements have semantic labels',
      (tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(buildWidget());

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
    );

    testWidgets(
      'AppSettingsScreen renders without overflow at 150% text scale',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(textScaler: const TextScaler.linear(1.5)),
        );

        final double scaledValue = MediaQuery.textScalerOf(
          tester.element(find.byType(AppSettingsScreen)),
        ).scale(10);
        expect(scaledValue, isA<double>());
        expect(scaledValue, 15);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'AppSettingsScreen renders without overflow at 200% text scale',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(textScaler: const TextScaler.linear(2.0)),
        );

        final double scaledValue = MediaQuery.textScalerOf(
          tester.element(find.byType(AppSettingsScreen)),
        ).scale(10);
        expect(scaledValue, isA<double>());
        expect(scaledValue, 20);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('AppSettingsScreen Tab key traverses all focusable elements', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      const List<Key> focusOrder = [
        Key('settings-category-selector'),
        Key('settings-category-selector'),
        Key('language-picker-dropdown'),
        Key('refresh-interval-dropdown'),
        Key('general-settings-check-for-updates-button'),
        Key('general-settings-privacy-policy-button'),
      ];

      for (final Key key in focusOrder) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final bool isFocused = hasPrimaryFocusWithin(tester, find.byKey(key));
        expect(isFocused, isA<bool>());
        expect(isFocused, isTrue, reason: '$key should receive focus');
      }
    });
  });
}
