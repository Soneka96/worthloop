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
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/about.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/language.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/refresh_interval.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/updates.section.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_language.dart';

class MockGeneralSettingsScreenViewModel extends Mock
    implements GeneralSettingsScreenViewModel {}

void main() {
  late MockGeneralSettingsScreenViewModel mockViewModel;
  late Store<AppState> store;
  late List<dynamic> dispatchedActions;

  setUp(() {
    mockViewModel = MockGeneralSettingsScreenViewModel();
    dispatchedActions = [];

    when(() => mockViewModel.refreshIntervalMinutes).thenReturn(60);
    when(() => mockViewModel.isRefreshIntervalBusy).thenReturn(false);
    when(() => mockViewModel.onCheckForUpdates).thenReturn(() {});
    when(() => mockViewModel.onOpenPrivacyPolicy).thenReturn(() {});
    when(() => mockViewModel.onRefreshIntervalSelected).thenReturn((_) {});

    sl.registerFactoryParam<
      GeneralSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => mockViewModel);
    sl.registerLazySingleton<PackageInfo>(
      () => PackageInfo(
        appName: 'WorthLoop Test',
        packageName: 'io.github.soneka96.worthloop.test',
        version: '0.0.0-test',
        buildNumber: '0',
      ),
    );
    sl.registerLazySingleton<AppLanguage>(AppLanguage.new);

    store = Store<AppState>((AppState state, dynamic action) {
      dispatchedActions.add(action);
      return state;
    }, initialState: AppState.initial());
  });

  tearDown(() => sl.reset());

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
        home: const Scaffold(
          body: SingleChildScrollView(child: GeneralSettingsScreen()),
        ),
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

  group('GeneralSettingsScreen contains widgets', () {
    testWidgets(
      'GeneralSettingsScreen contains a "General" headline Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('General'), findsOneWidget);
      },
    );

    testWidgets(
      'GeneralSettingsScreen contains LanguageSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(LanguageSection), findsOneWidget);
      },
    );

    testWidgets(
      'GeneralSettingsScreen contains UpdatesSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(UpdatesSection), findsOneWidget);
      },
    );

    testWidgets(
      'GeneralSettingsScreen contains RefreshIntervalSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(RefreshIntervalSection), findsOneWidget);
      },
    );

    testWidgets(
      'GeneralSettingsScreen contains AboutSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(AboutSection), findsOneWidget);
      },
    );
  });

  group(
    "GeneralSettingsScreen's StoreConnector dispatches LoadRefreshSettingsAction on init",
    () {
      testWidgets(
        'GeneralSettingsScreen dispatches LoadRefreshSettingsAction on init',
        (tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            dispatchedActions,
            contains(const LoadRefreshSettingsAction()),
          );
        },
      );
    },
  );

  group("GeneralSettingsScreen's elements behavior", () {
    testWidgets('GeneralSettingsScreen calls onCheckForUpdates when tapped', (
      tester,
    ) async {
      when(
        () => mockViewModel.onCheckForUpdates,
      ).thenReturn(() => print('onCheckForUpdates called'));
      await tester.pumpWidget(buildWidget());

      await expectLater(
        () => tester.tap(
          find.byKey(const Key('general-settings-check-for-updates-button')),
        ),
        prints('onCheckForUpdates called\n'),
      );
    });

    testWidgets('GeneralSettingsScreen calls onOpenPrivacyPolicy when tapped', (
      tester,
    ) async {
      when(
        () => mockViewModel.onOpenPrivacyPolicy,
      ).thenReturn(() => print('onOpenPrivacyPolicy called'));
      await tester.pumpWidget(buildWidget());

      await expectLater(
        () => tester.tap(
          find.byKey(const Key('general-settings-privacy-policy-button')),
        ),
        prints('onOpenPrivacyPolicy called\n'),
      );
    });
  });

  group(
    'GeneralSettingsScreen meets the accessibility recommended guidelines',
    () {
      testWidgets('GeneralSettingsScreen meets WCAG contrast guidelines', (
        tester,
      ) async {
        when(() => mockViewModel.isRefreshIntervalBusy).thenReturn(true);
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

      testWidgets(
        'GeneralSettingsScreen all tap targets meet minimum 48dp size',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'GeneralSettingsScreen all interactive elements have semantic labels',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'GeneralSettingsScreen renders without overflow at 150% text scale',
        (tester) async {
          await tester.pumpWidget(
            buildWidget(textScaler: const TextScaler.linear(1.5)),
          );

          final double scaledValue = MediaQuery.textScalerOf(
            tester.element(find.byType(GeneralSettingsScreen)),
          ).scale(10);
          expect(scaledValue, isA<double>());
          expect(scaledValue, 15);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'GeneralSettingsScreen renders without overflow at 200% text scale',
        (tester) async {
          await tester.pumpWidget(
            buildWidget(textScaler: const TextScaler.linear(2.0)),
          );

          final double scaledValue = MediaQuery.textScalerOf(
            tester.element(find.byType(GeneralSettingsScreen)),
          ).scale(10);
          expect(scaledValue, isA<double>());
          expect(scaledValue, 20);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'GeneralSettingsScreen Tab key traverses all focusable elements',
        (tester) async {
          await tester.pumpWidget(buildWidget());

          const List<Key> focusOrder = [
            Key('language-picker-dropdown'),
            Key('refresh-interval-dropdown'),
            Key('general-settings-check-for-updates-button'),
            Key('general-settings-privacy-policy-button'),
          ];

          for (final Key key in focusOrder) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
            final bool isFocused = hasPrimaryFocusWithin(
              tester,
              find.byKey(key),
            );
            expect(isFocused, isA<bool>());
            expect(isFocused, isTrue, reason: '$key should receive focus');
          }
        },
      );
    },
  );
}
