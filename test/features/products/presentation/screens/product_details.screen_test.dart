// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/screens/product_details.screen.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/illustrative_price_notice.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/store_price.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/store_price.fixture.dart';

class MockProductDetailsViewModel extends Mock
    implements ProductDetailsViewModel {}

void main() {
  late List<dynamic> dispatchedActions;
  late MockProductDetailsViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    dispatchedActions = [];
    mockViewModel = MockProductDetailsViewModel();
    when(() => mockViewModel.product).thenReturn(
      buildProduct(
        storePrices: [
          buildStorePrice(
            storeName: 'Expensive',
            currentPrice: buildMoney(minorUnits: 59999),
          ),
          buildStorePrice(
            storeName: 'Unavailable',
            currentPrice: buildMoney(minorUnits: 19999),
            isAvailable: false,
          ),
          buildStorePrice(
            storeName: 'Cheapest',
            currentPrice: buildMoney(minorUnits: 39999),
          ),
        ],
      ),
    );
    when(() => mockViewModel.isRefreshing).thenReturn(false);
    when(() => mockViewModel.onRefresh).thenReturn(() {});
    when(() => mockViewModel.onGoBack).thenReturn(() {});

    sl.registerFactoryParam<ProductDetailsViewModel, Store<AppState>, String>(
      (store, productId) => mockViewModel,
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
        home: const ProductDetailsScreen(productId: 'product-1'),
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

  group('ProductDetailsScreen contains widgets', () {
    testWidgets(
      'ProductDetailsScreen contains product and offer data with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Example Product'), findsOneWidget);
        expect(find.text('399.99 €'), findsWidgets);
        expect(find.byType(IllustrativePriceNotice), findsOneWidget);
        expect(find.text(t.home.sampleDataNotice), findsOneWidget);
        expect(find.byType(StorePriceWidget), findsNWidgets(3));
        expect(find.text(t.productDetails.availableOffers), findsOneWidget);
        expect(find.text(t.productDetails.unavailableOffers), findsOneWidget);
        expect(
          find.text(t.productDetails.unavailableDescription),
          findsOneWidget,
        );
      },
    );

    testWidgets('ProductDetailsScreen uses a lazy offer list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      final ListView listView = tester.widget(find.byType(ListView));

      expect(listView.childrenDelegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets(
      'ProductDetailsScreen contains offers sorted with available prices first',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        final List<StorePriceWidget> offers = tester
            .widgetList<StorePriceWidget>(find.byType(StorePriceWidget))
            .toList(growable: false);

        expect(offers.map((offer) => offer.storePrice.storeName).toList(), [
          'Cheapest',
          'Expensive',
          'Unavailable',
        ]);
      },
    );

    testWidgets(
      'ProductDetailsScreen contains product-not-found copy with the correct parameters when product == null',
      (WidgetTester tester) async {
        when(() => mockViewModel.product).thenReturn(null);

        await tester.pumpWidget(buildWidget());

        expect(find.text('Product not found'), findsOneWidget);
        expect(find.byType(IllustrativePriceNotice), findsNothing);
        expect(find.byType(StorePriceWidget), findsNothing);
      },
    );

    testWidgets('ProductDetailsScreen explains when no offers exist', (
      WidgetTester tester,
    ) async {
      when(() => mockViewModel.product).thenReturn(buildProduct());

      await tester.pumpWidget(buildWidget());

      expect(find.text(t.productDetails.noOffers), findsOneWidget);
      expect(find.byType(StorePriceWidget), findsNothing);
    });
  });

  group("ProductDetailsScreen's elements behavior", () {
    testWidgets(
      'ProductDetailsScreen contains a "product-details-refresh-button" FilledButton with the correct behavior',
      (WidgetTester tester) async {
        when(
          () => mockViewModel.onRefresh,
        ).thenReturn(() => print('refresh called'));

        await tester.pumpWidget(buildWidget());

        await expectLater(
          () => tester.tap(
            find.byKey(const Key('product-details-refresh-button')),
          ),
          prints('refresh called\n'),
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a "product-details-back-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        when(
          () => mockViewModel.onGoBack,
        ).thenReturn(() => print('back called'));

        await tester.pumpWidget(buildWidget());

        await expectLater(
          () =>
              tester.tap(find.byKey(const Key('product-details-back-button'))),
          prints('back called\n'),
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a disabled "product-details-refresh-button" FilledButton when isRefreshing = true',
      (WidgetTester tester) async {
        when(() => mockViewModel.isRefreshing).thenReturn(true);

        await tester.pumpWidget(buildWidget());
        final FilledButton button = tester.widget(
          find.byKey(const Key('product-details-refresh-button')),
        );

        expect(button.onPressed, isNull);
        expect(find.text(t.productDetails.refreshing), findsOneWidget);
      },
    );

    testWidgets(
      'ProductDetailsScreen does not call onRefresh when isRefreshing = true',
      (WidgetTester tester) async {
        when(() => mockViewModel.isRefreshing).thenReturn(true);
        when(
          () => mockViewModel.onRefresh,
        ).thenReturn(() => print('refresh called'));

        await tester.pumpWidget(buildWidget());

        await expectLater(
          () => tester.tap(
            find.byKey(const Key('product-details-refresh-button')),
          ),
          prints(isEmpty),
        );
      },
    );
  });

  group(
    "ProductDetailsScreen's StoreConnector dispatches LoadProductSourcesAction on init",
    () {
      testWidgets(
        'ProductDetailsScreen dispatches LoadProductSourcesAction on init',
        (WidgetTester tester) async {
          await tester.pumpWidget(buildWidget());

          expect(
            dispatchedActions,
            contains(const LoadProductSourcesAction('product-1')),
          );
        },
      );
    },
  );

  group("ProductDetailsScreen's translations", () {
    testWidgets('ProductDetailsScreen displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.bestPrice), findsOneWidget);
        expect(find.text(t.home.sampleDataNotice), findsOneWidget);
        expect(find.text(t.productDetails.refresh), findsOneWidget);
        expect(find.text(t.productDetails.available), findsNWidgets(2));
        expect(find.text(t.productDetails.availableOffers), findsOneWidget);
        expect(find.text(t.productDetails.unavailableOffers), findsOneWidget);
        expect(
          find.text(t.productDetails.unavailableDescription),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });

  group(
    'ProductDetailsScreen meets the accessibility recommended guidelines',
    () {
      testWidgets('ProductDetailsScreen meets WCAG contrast guidelines', (
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

      testWidgets(
        'ProductDetailsScreen all tap targets meet minimum 48dp size',
        (WidgetTester tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'ProductDetailsScreen all interactive elements have semantic labels',
        (WidgetTester tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'ProductDetailsScreen renders without overflow at 150% text scale',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            buildWidget(textScaler: const TextScaler.linear(1.5)),
          );

          final double scaledValue = MediaQuery.textScalerOf(
            tester.element(find.byType(ProductDetailsScreen)),
          ).scale(10);
          expect(scaledValue, isA<double>());
          expect(scaledValue, 15);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'ProductDetailsScreen renders without overflow at 200% text scale',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            buildWidget(textScaler: const TextScaler.linear(2.0)),
          );

          final double scaledValue = MediaQuery.textScalerOf(
            tester.element(find.byType(ProductDetailsScreen)),
          ).scale(10);
          expect(scaledValue, isA<double>());
          expect(scaledValue, 20);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'ProductDetailsScreen Tab key traverses all focusable elements',
        (WidgetTester tester) async {
          await tester.pumpWidget(buildWidget());

          const Key backKey = Key('product-details-back-button');
          const Key refreshKey = Key('product-details-refresh-button');

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool backFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(backKey),
          );

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool refreshFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(refreshKey),
          );

          expect(backFocused, isA<bool>());
          expect(backFocused, isTrue);
          expect(refreshFocused, isA<bool>());
          expect(refreshFocused, isTrue);
        },
      );
    },
  );
}
