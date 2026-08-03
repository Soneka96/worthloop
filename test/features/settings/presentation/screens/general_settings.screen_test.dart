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
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/about.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/language.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/general/updates.section.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_language.dart';

class MockGeneralSettingsScreenViewModel extends Mock
    implements GeneralSettingsScreenViewModel {}

void main() {
  late MockGeneralSettingsScreenViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    mockViewModel = MockGeneralSettingsScreenViewModel();

    when(() => mockViewModel.onCheckForUpdates).thenReturn(() {});
    when(() => mockViewModel.onOpenPrivacyPolicy).thenReturn(() {});

    sl.registerFactoryParam<
      GeneralSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => mockViewModel);
    sl.registerLazySingleton<PackageInfo>(
      () => PackageInfo(
        appName: 'WorthLoop',
        packageName: 'com.soneka96.starter',
        version: '0.1.0',
        buildNumber: '1',
      ),
    );
    sl.registerLazySingleton<AppLanguage>(AppLanguage.new);

    store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: GeneralSettingsScreen()),
        ),
      ),
    );
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
      'GeneralSettingsScreen contains AboutSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(AboutSection), findsOneWidget);
      },
    );
  });

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
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(buildWidget());

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
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
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: buildWidget(),
            ),
          );

          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'GeneralSettingsScreen renders without overflow at 200% text scale',
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

      testWidgets(
        'GeneralSettingsScreen Tab key traverses all focusable elements',
        (tester) async {
          await tester.pumpWidget(buildWidget());

          final int focusableCount = tester
              .widgetList(find.byWidgetPredicate((widget) => widget is Focus))
              .length;
          for (int i = 0; i < focusableCount; i++) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
          }

          expect(FocusManager.instance.primaryFocus, isNotNull);
        },
      );
    },
  );
}
