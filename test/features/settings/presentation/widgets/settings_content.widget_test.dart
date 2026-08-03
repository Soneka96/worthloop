// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/logs/presentation/screens/logs_settings.screen.dart';
import 'package:worth_loop/features/logs/presentation/state/viewmodels/logs_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/screens/appearance_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/settings_content.widget.dart';
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
    sl.registerFactoryParam<LogsScreenViewModel, Store<AppState>, void>(
      (store, _) => LogsScreenViewModel.fromStore(store),
    );

    store = Store<AppState>(appReducer, initialState: AppState.initial());
  });
  tearDown(() => sl.reset());

  Widget buildWidget(SettingsCategory category) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SettingsContent(category: category),
          ),
        ),
      ),
    );
  }

  group('SettingsContent contains widgets', () {
    testWidgets('shows GeneralSettingsScreen for the General category', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(SettingsCategory.general));

      expect(find.byType(GeneralSettingsScreen), findsOneWidget);
    });

    testWidgets('shows AppearanceSettingsScreen for the Appearance category', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(SettingsCategory.appearance));

      expect(find.byType(AppearanceSettingsScreen), findsOneWidget);
    });

    testWidgets('shows LogsSettingsScreen for the Logs category', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(SettingsCategory.logs));

      expect(find.byType(LogsSettingsScreen), findsOneWidget);
    });

    testWidgets('shows nothing for a category with no built-out section', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(SettingsCategory.editor));

      expect(find.byType(GeneralSettingsScreen), findsNothing);
      expect(find.byType(AppearanceSettingsScreen), findsNothing);
    });
  });
}
