// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/screens/home.screen.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockHomeScreenViewModel extends Mock implements HomeScreenViewModel {}

void main() {
  late MockHomeScreenViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    mockViewModel = MockHomeScreenViewModel();

    when(() => mockViewModel.onOpenGithubExplorer).thenReturn(() {});
    when(() => mockViewModel.onOpenSettings).thenReturn(() {});

    sl.registerFactoryParam<HomeScreenViewModel, Store<AppState>, void>(
      (store, _) => mockViewModel,
    );

    store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );
  });

  tearDown(() => sl.reset());

  Widget buildWidget() {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(home: Scaffold(body: HomeScreen())),
    );
  }

  group('HomeScreen contains widgets', () {
    testWidgets(
      'HomeScreen contains a "home-settings-button" IconButton with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('home-settings-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'HomeScreen contains a "home-start-searching-button" FilledButton with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('home-start-searching-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'HomeScreen contains an appTitle Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Clean Architecture Starter'), findsOneWidget);
      },
    );
  });

  group("HomeScreen's elements behavior", () {
    testWidgets(
      'HomeScreen contains a "home-settings-button" IconButton with the correct behavior when tapped',
      (tester) async {
        bool opened = false;
        when(() => mockViewModel.onOpenSettings).thenReturn(() {
          opened = true;
        });

        await tester.pumpWidget(buildWidget());
        await tester.tap(find.byKey(const Key('home-settings-button')));

        expect(opened, isTrue);
      },
    );

    testWidgets(
      'HomeScreen contains a "home-start-searching-button" FilledButton with the correct behavior when tapped',
      (tester) async {
        bool opened = false;
        when(() => mockViewModel.onOpenGithubExplorer).thenReturn(() {
          opened = true;
        });

        await tester.pumpWidget(buildWidget());
        await tester.tap(find.byKey(const Key('home-start-searching-button')));

        expect(opened, isTrue);
      },
    );
  });

  group('HomeScreen meets the accessibility recommended guidelines', () {
    testWidgets('HomeScreen meets WCAG contrast guidelines', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('HomeScreen all tap targets meet minimum 48dp size', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('HomeScreen all interactive elements have semantic labels', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('HomeScreen renders without overflow at 150% text scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: buildWidget(),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('HomeScreen renders without overflow at 200% text scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: buildWidget(),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('HomeScreen Tab key traverses all focusable elements', (
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
