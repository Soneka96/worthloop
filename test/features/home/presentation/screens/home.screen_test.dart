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
import 'package:worth_loop/features/home/presentation/widgets/add_product_dialog.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_product.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../products/fixtures/money.fixture.dart';
import '../../../products/fixtures/product.fixture.dart';
import '../../../products/fixtures/product_source.fixture.dart';

class MockHomeScreenViewModel extends Mock implements HomeScreenViewModel {}

void main() {
  late List<dynamic> dispatchedActions;
  late MockHomeScreenViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    dispatchedActions = [];
    mockViewModel = MockHomeScreenViewModel();
    when(() => mockViewModel.products).thenReturn([
      buildProduct(
        sources: [
          buildProductSource(
            currentPrice: buildMoney(minorUnits: 49999),
            isAvailable: true,
          ),
        ],
      ),
    ]);
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.isRefreshingAll).thenReturn(false);
    when(() => mockViewModel.refreshCompletedCount).thenReturn(0);
    when(() => mockViewModel.refreshTotalCount).thenReturn(0);
    when(
      () => mockViewModel.latestUpdatedAt,
    ).thenReturn(DateTime(2026, 8, 7, 21, 51));
    when(() => mockViewModel.isCreatingProduct).thenReturn(false);
    when(() => mockViewModel.productCreationError).thenReturn(null);
    when(() => mockViewModel.createdProductId).thenReturn(null);
    when(() => mockViewModel.sourceRefreshStatuses).thenReturn({});
    when(() => mockViewModel.onRefreshAll).thenReturn(() {});
    when(() => mockViewModel.onOpenSettings).thenReturn(() {});
    when(() => mockViewModel.onOpenProduct).thenReturn((_) {});
    when(() => mockViewModel.onCreateProduct).thenReturn((_) {});

    sl.registerFactoryParam<HomeScreenViewModel, Store<AppState>, void>(
      (store, _) => mockViewModel,
    );

    store = Store<AppState>((AppState state, dynamic action) {
      dispatchedActions.add(action);
      return state;
    }, initialState: AppState.initial());
  });

  tearDown(() async {
    await sl.reset();
    reset(mockViewModel);
  });

  Widget buildWidget({
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) => TranslationProvider(
    child: StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child ?? const SizedBox.shrink(),
        ),
        home: const HomeScreen(),
      ),
    ),
  );

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

  group('HomeScreen contains widgets', () {
    testWidgets(
      'HomeScreen contains a "home-settings-button" IconButton with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byKey(const Key('home-settings-button')), findsOneWidget);
      },
    );

    testWidgets('HomeScreen uses pull-to-refresh without a permanent button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byKey(const Key('home-refresh-all-button')), findsNothing);
    });

    testWidgets('HomeScreen keeps the list pullable when content is short', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      final CustomScrollView scrollView = tester.widget(
        find.byType(CustomScrollView),
      );

      expect(scrollView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets(
      'HomeScreen displays compact refresh progress from the viewmodel',
      (WidgetTester tester) async {
        when(() => mockViewModel.isRefreshingAll).thenReturn(true);
        when(() => mockViewModel.refreshCompletedCount).thenReturn(18);
        when(() => mockViewModel.refreshTotalCount).thenReturn(42);

        await tester.pumpWidget(buildWidget());

        expect(
          find.text(t.home.refreshProgress(completed: 18, total: 42)),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'HomeScreen contains a TrackedProductWidget with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(TrackedProductWidget), findsOneWidget);
        expect(find.text('WorthLoop'), findsOneWidget);
      },
    );

    testWidgets(
      'HomeScreen contains a "home-search-field" TextField with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byKey(const Key('home-search-field')), findsOneWidget);
      },
    );

    testWidgets('HomeScreen uses a lazy product list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      final SliverList listView = tester.widget(find.byType(SliverList).last);

      expect(listView.delegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets(
      'HomeScreen contains a CircularProgressIndicator with the correct parameters when isLoading = true',
      (WidgetTester tester) async {
        when(() => mockViewModel.products).thenReturn([]);
        when(() => mockViewModel.isLoading).thenReturn(true);

        await tester.pumpWidget(buildWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'HomeScreen contains a TrackedProductsEmptyWidget with the correct parameters when products is empty',
      (WidgetTester tester) async {
        when(() => mockViewModel.products).thenReturn([]);

        await tester.pumpWidget(buildWidget());

        expect(find.byType(TrackedProductsEmptyWidget), findsOneWidget);
      },
    );

    testWidgets(
      'HomeScreen contains a "home-add-product-button" FloatingActionButton with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('home-add-product-button')),
          findsOneWidget,
        );
      },
    );
  });

  group("HomeScreen's elements behavior", () {
    testWidgets(
      'HomeScreen contains a "home-settings-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        bool opened = false;
        when(() => mockViewModel.onOpenSettings).thenReturn(() {
          opened = true;
        });

        await tester.pumpWidget(buildWidget());
        await tester.tap(find.byKey(const Key('home-settings-button')));

        expect(opened, isA<bool>());
        expect(opened, isTrue);
      },
    );

    testWidgets('HomeScreen triggers refresh from RefreshIndicator', (
      WidgetTester tester,
    ) async {
      bool refreshed = false;
      when(() => mockViewModel.onRefreshAll).thenReturn(() {
        refreshed = true;
      });

      await tester.pumpWidget(buildWidget());
      final RefreshIndicator indicator = tester.widget(
        find.byType(RefreshIndicator),
      );
      await indicator.onRefresh();

      expect(refreshed, isTrue);
    });

    testWidgets(
      'HomeScreen contains a TrackedProductWidget with the correct behavior',
      (WidgetTester tester) async {
        when(
          () => mockViewModel.onOpenProduct,
        ).thenReturn((String productId) => print('opened $productId'));

        await tester.pumpWidget(buildWidget());

        await expectLater(
          () => tester.tap(find.byKey(const Key('tracked-product-product-1'))),
          prints('opened product-1\n'),
        );
      },
    );

    testWidgets(
      'HomeScreen contains a "home-add-product-button" FloatingActionButton with the correct behavior',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('home-add-product-button')));
        await tester.pumpAndSettle();

        expect(find.byType(AddProductDialog), findsOneWidget);
      },
    );
  });

  group(
    "HomeScreen's StoreConnector dispatches LoadProductsAction on init",
    () {
      testWidgets('HomeScreen dispatches LoadProductsAction on init', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildWidget());

        expect(dispatchedActions, contains(const LoadProductsAction()));
      });
    },
  );

  group("HomeScreen's translations", () {
    testWidgets('HomeScreen displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.home.subtitle), findsOneWidget);
        expect(
          find.textContaining(t.home.trackedProducts(count: 1)),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });

  group('HomeScreen meets the accessibility recommended guidelines', () {
    testWidgets('HomeScreen meets WCAG contrast guidelines', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(buildWidget());
        await expectLater(tester, meetsGuideline(textContrastGuideline));

        await tester.pumpWidget(buildWidget(themeMode: ThemeMode.dark));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        handle.dispose();
      }
    });

    testWidgets('HomeScreen all tap targets meet minimum 48dp size', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('HomeScreen all interactive elements have semantic labels', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildWidget());

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('HomeScreen renders without overflow at 150% text scale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(textScaler: const TextScaler.linear(1.5)),
      );

      final double scaledValue = MediaQuery.textScalerOf(
        tester.element(find.byType(HomeScreen)),
      ).scale(10);
      expect(scaledValue, isA<double>());
      expect(scaledValue, 15);
      expect(tester.takeException(), isNull);
    });

    testWidgets('HomeScreen renders without overflow at 200% text scale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(textScaler: const TextScaler.linear(2.0)),
      );

      final double scaledValue = MediaQuery.textScalerOf(
        tester.element(find.byType(HomeScreen)),
      ).scale(10);
      expect(scaledValue, isA<double>());
      expect(scaledValue, 20);
      expect(tester.takeException(), isNull);
    });

    testWidgets('HomeScreen Tab key traverses all focusable elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      const Key settingsKey = Key('home-settings-button');
      const Key searchKey = Key('home-search-field');
      const Key productKey = Key('tracked-product-product-1');
      const Key addProductKey = Key('home-add-product-button');

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final bool settingsFocused = hasPrimaryFocusWithin(
        tester,
        find.byKey(settingsKey),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final bool searchFocused = hasPrimaryFocusWithin(
        tester,
        find.byKey(searchKey),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final bool productFocused = hasPrimaryFocusWithin(
        tester,
        find.byKey(productKey),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final bool addProductFocused = hasPrimaryFocusWithin(
        tester,
        find.byKey(addProductKey),
      );

      expect(settingsFocused, isA<bool>());
      expect(settingsFocused, isTrue);
      expect(searchFocused, isA<bool>());
      expect(searchFocused, isTrue);
      expect(productFocused, isA<bool>());
      expect(productFocused, isTrue);
      expect(addProductFocused, isA<bool>());
      expect(addProductFocused, isTrue);
    });
  });
}
