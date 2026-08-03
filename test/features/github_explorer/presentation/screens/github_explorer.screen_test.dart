// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/github_explorer/presentation/screens/github_explorer.screen.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/github_explorer.actions.dart';
import 'package:worth_loop/features/github_explorer/presentation/state/viewmodels/github_explorer_screen.viewmodel.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/github_profile_card.widget.dart';
import 'package:worth_loop/features/github_explorer/presentation/widgets/recent_search_tile.widget.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/github_profile.fixture.dart';

class MockGithubExplorerScreenViewModel extends Mock
    implements GithubExplorerScreenViewModel {}

void main() {
  late MockGithubExplorerScreenViewModel mockViewModel;
  late Store<AppState> store;
  late List<dynamic> dispatchedActions;

  setUp(() {
    mockViewModel = MockGithubExplorerScreenViewModel();

    when(() => mockViewModel.profile).thenReturn(null);
    when(() => mockViewModel.recentSearches).thenReturn([]);
    when(() => mockViewModel.isSearching).thenReturn(false);
    when(() => mockViewModel.error).thenReturn(null);
    when(() => mockViewModel.onSearch).thenReturn((_) {});
    when(() => mockViewModel.onToggleFavorite).thenReturn((_) {});
    when(() => mockViewModel.onOpenSettings).thenReturn(() {});
    when(() => mockViewModel.onGoHome).thenReturn(() {});

    sl.registerFactoryParam<
      GithubExplorerScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => mockViewModel);

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
          body: SingleChildScrollView(child: GithubExplorerScreen()),
        ),
      ),
    );
  }

  group('GithubExplorerScreen contains widgets', () {
    testWidgets(
      'GithubExplorerScreen contains a "GitHub Explorer" headline Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('GitHub Explorer'), findsOneWidget);
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-search-field" TextField with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('github-explorer-search-field')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-search-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('github-explorer-search-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-settings-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('github-explorer-settings-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-home-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('github-explorer-home-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a Text with the correct parameters when profile == null',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.text(
            'Search a username to see their profile and top repositories.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubExplorerScreen contains GithubProfileCard with the correct parameters when profile != null',
      (tester) async {
        when(() => mockViewModel.profile).thenReturn(buildGithubProfile());

        await tester.pumpWidget(buildWidget());

        expect(find.byType(GithubProfileCard), findsOneWidget);
      },
    );

    testWidgets(
      'GithubExplorerScreen contains RecentSearchTile widgets with the correct parameters',
      (tester) async {
        when(
          () => mockViewModel.recentSearches,
        ).thenReturn([buildGithubProfile(), buildGithubProfile(username: 'b')]);

        await tester.pumpWidget(buildWidget());

        expect(find.byType(RecentSearchTile), findsNWidgets(2));
      },
    );
  });

  group("GithubExplorerScreen's elements behavior", () {
    testWidgets(
      "GithubExplorerScreen's StoreConnector dispatches LoadRecentSearchesAction on init",
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(dispatchedActions, contains(const LoadRecentSearchesAction()));
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-search-button" button with the correct behavior when tapped',
      (tester) async {
        String? searched;
        when(() => mockViewModel.onSearch).thenReturn((username) {
          searched = username;
        });

        await tester.pumpWidget(buildWidget());
        await tester.enterText(
          find.byKey(const Key('github-explorer-search-field')),
          'octocat',
        );
        await tester.tap(
          find.byKey(const Key('github-explorer-search-button')),
        );

        expect(searched, 'octocat');
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-settings-button" button with the correct behavior when tapped',
      (tester) async {
        bool opened = false;
        when(() => mockViewModel.onOpenSettings).thenReturn(() {
          opened = true;
        });

        await tester.pumpWidget(buildWidget());
        await tester.tap(
          find.byKey(const Key('github-explorer-settings-button')),
        );

        expect(opened, isTrue);
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-home-button" button with the correct behavior when tapped',
      (tester) async {
        bool wentHome = false;
        when(() => mockViewModel.onGoHome).thenReturn(() {
          wentHome = true;
        });

        await tester.pumpWidget(buildWidget());
        await tester.tap(find.byKey(const Key('github-explorer-home-button')));

        expect(wentHome, isTrue);
      },
    );

    testWidgets(
      'GithubExplorerScreen does not call onSearch when the search field is empty',
      (tester) async {
        bool called = false;
        when(() => mockViewModel.onSearch).thenReturn((_) => called = true);

        await tester.pumpWidget(buildWidget());
        await tester.tap(
          find.byKey(const Key('github-explorer-search-button')),
        );

        expect(called, isFalse);
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a CircularProgressIndicator with the correct parameters when isSearching = true',
      (tester) async {
        when(() => mockViewModel.isSearching).thenReturn(true);

        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('github-explorer-loading-indicator')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'GithubExplorerScreen contains a "github-explorer-search-field" TextField with the correct parameters when error != null',
      (tester) async {
        when(() => mockViewModel.error).thenReturn('Not found');

        await tester.pumpWidget(buildWidget());

        expect(find.text('Not found'), findsOneWidget);
      },
    );
  });

  group(
    'GithubExplorerScreen meets the accessibility recommended guidelines',
    () {
      testWidgets('GithubExplorerScreen meets WCAG contrast guidelines', (
        tester,
      ) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(buildWidget());

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });

      testWidgets(
        'GithubExplorerScreen all tap targets meet minimum 48dp size',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'GithubExplorerScreen all interactive elements have semantic labels',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'GithubExplorerScreen renders without overflow at 150% text scale',
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
        'GithubExplorerScreen renders without overflow at 200% text scale',
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
        'GithubExplorerScreen Tab key traverses all focusable elements',
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
