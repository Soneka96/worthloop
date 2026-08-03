// Flutter imports:
import 'package:flutter/material.dart';

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
import 'package:worth_loop/features/settings/presentation/widgets/general/default_save_location.section.dart';
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
  late List<dynamic> dispatchedActions;

  setUp(() {
    mockViewModel = MockGeneralSettingsScreenViewModel();

    when(() => mockViewModel.defaultSaveLocation).thenReturn(null);
    when(() => mockViewModel.pendingDataRoot).thenReturn(null);
    when(() => mockViewModel.onPickDefaultSaveLocation).thenReturn((_) {});
    when(() => mockViewModel.onRestartNow).thenReturn(() {});
    when(() => mockViewModel.onCheckForUpdates).thenReturn(() {});
    when(() => mockViewModel.onOpenPrivacyPolicy).thenReturn(() {});

    sl.registerFactoryParam<
      GeneralSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => mockViewModel);
    sl.registerLazySingleton<PackageInfo>(
      () => PackageInfo(
        appName: 'Clean Architecture Starter',
        packageName: 'com.soneka96.starter',
        version: '0.1.0',
        buildNumber: '1',
      ),
    );
    sl.registerLazySingleton<AppLanguage>(AppLanguage.new);

    dispatchedActions = [];
    store = Store<AppState>((AppState state, dynamic action) {
      dispatchedActions.add(action);
      return state;
    }, initialState: AppState.initial());
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
      'GeneralSettingsScreen contains DefaultSaveLocationSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(DefaultSaveLocationSection), findsOneWidget);
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
    testWidgets(
      "GeneralSettingsScreen's StoreConnector dispatches LoadGeneralSettingsAction on init",
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(dispatchedActions, contains(const LoadGeneralSettingsAction()));
      },
    );
  });
}
