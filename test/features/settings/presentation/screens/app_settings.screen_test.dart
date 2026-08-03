// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/app_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.reducer.dart';
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
    sl.registerLazySingleton<AppTheme>(AppTheme.new);
    sl.registerLazySingleton<AppShape>(AppShape.new);
    sl.registerLazySingleton<AppSpacing>(AppSpacing.new);
    sl.registerLazySingleton<AppZoom>(AppZoom.new);
    sl.registerLazySingleton<AppFont>(AppFont.new);
    sl.registerLazySingleton<AppLanguage>(AppLanguage.new);
    sl.registerLazySingleton<PackageInfo>(
      () => PackageInfo(
        appName: 'Clean Architecture Starter',
        packageName: 'com.soneka96.starter',
        version: '0.1.0',
        buildNumber: '1',
      ),
    );
    sl.registerFactoryParam<
      GeneralSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => GeneralSettingsScreenViewModel.fromStore(store));

    store = Store<AppState>(appReducer, initialState: AppState.initial());
  });
  tearDown(() => sl.reset());

  Widget buildWidget() {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(home: AppSettingsScreen()),
    );
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
      'AppSettingsScreen contains a "settings-category-general" ListTile with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ListTile tile = tester.widget(
          find.byKey(const Key('settings-category-general')),
        );

        expect(tile.enabled, true);
        expect(tile.selected, false);
      },
    );

    testWidgets(
      'AppSettingsScreen contains a "settings-category-appearance" ListTile with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final ListTile tile = tester.widget(
          find.byKey(const Key('settings-category-appearance')),
        );

        expect(tile.enabled, true);
        expect(tile.selected, true);
      },
    );

    testWidgets(
      'AppSettingsScreen contains AppearanceSettingsScreen with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(AppearanceSettingsScreen), findsOneWidget);
      },
    );
  });

  group("AppSettingsScreen's elements behavior", () {
    testWidgets(
      'AppSettingsScreen does not change the displayed content when a disabled category is tapped',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('settings-category-editor')));
        await tester.pump();

        expect(find.byType(AppearanceSettingsScreen), findsOneWidget);
      },
    );

    testWidgets(
      'AppSettingsScreen shows GeneralSettingsScreen when the General category is tapped',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('settings-category-general')));
        await tester.pump();

        expect(find.byType(GeneralSettingsScreen), findsOneWidget);
      },
    );
  });

  group('AppSettingsScreen meets the accessibility recommended guidelines', () {
    testWidgets('AppSettingsScreen meets WCAG contrast guidelines', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
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
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: buildWidget(),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'AppSettingsScreen renders without overflow at 200% text scale',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: buildWidget(),
          ),
        );

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('AppSettingsScreen Tab key traverses all focusable elements', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      final int focusableCount = tester
          .widgetList(find.byWidgetPredicate((widget) => widget is Focus))
          .length;
      for (int i = 0; i < focusableCount; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }

      expect(FocusManager.instance.primaryFocus, isNotNull);
    });
  });
}
