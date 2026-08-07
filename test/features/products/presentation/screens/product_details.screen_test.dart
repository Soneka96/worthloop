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
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/merchant_offer_row.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/rename_product_dialog.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

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
        sources: [
          buildProductSource(
            id: 'source-1',
            merchantDomain: 'expensive.example.com',
            currentPrice: buildMoney(minorUnits: 59999),
            isAvailable: true,
          ),
          buildProductSource(
            id: 'source-2',
            merchantDomain: 'unavailable.example.com',
            currentPrice: buildMoney(minorUnits: 19999),
            isAvailable: false,
          ),
          buildProductSource(
            id: 'source-3',
            merchantDomain: 'cheapest.example.com',
            currentPrice: buildMoney(minorUnits: 39999),
            isAvailable: true,
          ),
        ],
      ),
    );
    when(() => mockViewModel.isRefreshing).thenReturn(false);
    when(() => mockViewModel.isProductRefreshing).thenReturn(false);
    when(() => mockViewModel.areOtherSourcesRefreshing).thenReturn(false);
    when(() => mockViewModel.productRefreshCompletedCount).thenReturn(0);
    when(() => mockViewModel.productRefreshTotalCount).thenReturn(0);
    when(() => mockViewModel.sourceRefreshStatuses).thenReturn(const {});
    when(() => mockViewModel.refreshCompletedCount).thenReturn(0);
    when(() => mockViewModel.refreshTotalCount).thenReturn(0);
    when(() => mockViewModel.isAddingSource).thenReturn(false);
    when(() => mockViewModel.addSourceError).thenReturn(null);
    when(() => mockViewModel.editingSourceId).thenReturn(null);
    when(() => mockViewModel.editSourceError).thenReturn(null);
    when(() => mockViewModel.deletingSourceIds).thenReturn(const {});
    when(() => mockViewModel.deleteSourceError).thenReturn(null);
    when(() => mockViewModel.isRenamingProduct).thenReturn(false);
    when(() => mockViewModel.renameProductError).thenReturn(null);
    when(() => mockViewModel.isDeletingProduct).thenReturn(false);
    when(() => mockViewModel.deleteProductError).thenReturn(null);
    when(() => mockViewModel.onRefresh).thenReturn(() {});
    when(() => mockViewModel.onRefreshSource).thenReturn((_) {});
    when(() => mockViewModel.onGoBack).thenReturn(() {});
    when(() => mockViewModel.onAddSource).thenReturn((_) {});
    when(() => mockViewModel.onEditSource).thenReturn((_, _) {});
    when(() => mockViewModel.onDeleteSource).thenReturn((_) {});
    when(() => mockViewModel.onOpenOffer).thenReturn((_) {});
    when(() => mockViewModel.onRenameProduct).thenReturn((_) {});
    when(() => mockViewModel.onDeleteProduct).thenReturn(() {});

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

  /// Pumps [ProductDetailsScreen] on a large surface so the offer section is
  /// available to the widget and accessibility checks.
  Future<void> pumpScreen(
    WidgetTester tester, {
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      buildWidget(themeMode: themeMode, textScaler: textScaler),
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

  group('ProductDetailsScreen contains widgets', () {
    testWidgets(
      'ProductDetailsScreen contains product and merchant offer data with the correct parameters',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(find.text('Example Product'), findsOneWidget);
        expect(find.byType(MerchantOfferRow), findsNWidgets(3));
        expect(find.textContaining('399.99'), findsOneWidget);
        expect(find.text(t.productDetails.available), findsNWidgets(2));
        expect(find.text(t.productDetails.unavailable), findsOneWidget);
      },
    );

    testWidgets('ProductDetailsScreen shows the source count in the AppBar', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);
      expect(
        find.textContaining(t.productDetails.sourcesTitle),
        findsOneWidget,
      );
    });

    testWidgets(
      'ProductDetailsScreen contains a RefreshIndicator for pull-to-refresh',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(find.byType(RefreshIndicator), findsOneWidget);
        expect(find.text(t.productDetails.refreshing), findsNothing);
        expect(find.textContaining('sources checked'), findsNothing);
      },
    );

    testWidgets('ProductDetailsScreen uses a lazy offer list', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);

      final SliverList sliverList = tester.widget(find.byType(SliverList).last);

      expect(sliverList.delegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets(
      'ProductDetailsScreen marks the lowest available merchant offer as the best price',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        final MerchantOfferRow bestRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-3',
          ),
        );
        final MerchantOfferRow otherRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-1',
          ),
        );
        expect(bestRow.isBestPrice, isA<bool>());
        expect(bestRow.isBestPrice, isTrue);
        expect(otherRow.isBestPrice, isA<bool>());
        expect(otherRow.isBestPrice, isFalse);
      },
    );

    testWidgets(
      'ProductDetailsScreen contains product-not-found copy with the correct parameters when product == null',
      (WidgetTester tester) async {
        when(() => mockViewModel.product).thenReturn(null);

        await pumpScreen(tester);

        expect(find.text('Product not found'), findsOneWidget);
        expect(find.byType(MerchantOfferRow), findsNothing);
      },
    );

    testWidgets('ProductDetailsScreen explains when no offers exist', (
      WidgetTester tester,
    ) async {
      when(() => mockViewModel.product).thenReturn(buildProduct());

      await pumpScreen(tester);

      expect(find.text(t.productDetails.noOffers), findsNothing);
      expect(find.byType(ProductSourcesEmptyWidget), findsOneWidget);
      expect(find.byType(MerchantOfferRow), findsNothing);
    });

    testWidgets(
      'ProductDetailsScreen contains a product-details-add-source-fab',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(
          find.byKey(const Key('product-details-add-source-fab')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a ProductSourcesEmptyWidget with the correct parameters when product.sources is empty',
      (WidgetTester tester) async {
        when(() => mockViewModel.product).thenReturn(buildProduct());

        await pumpScreen(tester);

        expect(find.byType(ProductSourcesEmptyWidget), findsOneWidget);
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a MerchantOfferRow per product source with the correct parameters when product.sources is not empty',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(
          find.byKey(const Key('merchant-offer-source-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('merchant-offer-source-2')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a "product-details-rename-button" IconButton and a "product-details-delete-button" IconButton with the correct parameters',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(
          find.byKey(const Key('product-details-rename-button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-details-delete-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen does not contain rename or delete buttons when product == null',
      (WidgetTester tester) async {
        when(() => mockViewModel.product).thenReturn(null);

        await pumpScreen(tester);

        expect(
          find.byKey(const Key('product-details-rename-button')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('product-details-delete-button')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('product-details-add-source-fab')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a CircularProgressIndicator instead of the delete button with the correct parameters when isDeletingProduct = true',
      (WidgetTester tester) async {
        when(() => mockViewModel.isDeletingProduct).thenReturn(true);

        await pumpScreen(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(
          find.byKey(const Key('product-details-delete-button')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('product-details-rename-button')),
          findsOneWidget,
        );
      },
    );
  });

  group("ProductDetailsScreen's elements behavior", () {
    testWidgets(
      'ProductDetailsScreen contains a "product-details-back-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        when(
          () => mockViewModel.onGoBack,
        ).thenReturn(() => print('back called'));

        await pumpScreen(tester);

        await expectLater(
          () =>
              tester.tap(find.byKey(const Key('product-details-back-button'))),
          prints('back called\n'),
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen calls onOpenOffer when an offer row is tapped',
      (WidgetTester tester) async {
        String? openedUrl;
        when(
          () => mockViewModel.onOpenOffer,
        ).thenReturn((String url) => openedUrl = url);

        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-tap-target')),
        );

        expect(openedUrl, isA<String>());
        expect(openedUrl, 'https://example.com/products/1');
      },
    );

    testWidgets(
      'ProductDetailsScreen does not call onOpenOffer when an offer is deleting',
      (WidgetTester tester) async {
        String? openedUrl;
        when(
          () => mockViewModel.deletingSourceIds,
        ).thenReturn(const {'source-1'});
        when(
          () => mockViewModel.onOpenOffer,
        ).thenReturn((String url) => openedUrl = url);

        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-tap-target')),
        );

        expect(openedUrl, isNull);
      },
    );

    testWidgets('ProductDetailsScreen opens the source dialog from the FAB', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);

      await tester.tap(find.byKey(const Key('product-details-add-source-fab')));
      await tester.pumpAndSettle();

      final SourceFormDialog dialog = tester.widget(
        find.byType(SourceFormDialog),
      );
      expect(dialog.productId, isA<String>());
      expect(dialog.productId, 'product-1');
    });

    testWidgets(
      'ProductDetailsScreen contains a "product-details-rename-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('product-details-rename-button')),
        );
        await tester.pumpAndSettle();

        final RenameProductDialog dialog = tester.widget(
          find.byType(RenameProductDialog),
        );
        expect(dialog.productId, isA<String>());
        expect(dialog.productId, 'product-1');
        expect(dialog.currentName, 'Example Product');
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a "product-details-delete-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('product-details-delete-button')),
        );
        await tester.pumpAndSettle();

        final ConfirmDialog dialog = tester.widget(find.byType(ConfirmDialog));
        expect(dialog.title, t.productDetails.deleteProductTitle);
        expect(
          dialog.message,
          t.productDetails.deleteProductMessage(name: 'Example Product'),
        );
        expect(dialog.confirmLabel, t.productDetails.deleteProductConfirmLabel);
      },
    );

    testWidgets(
      'ProductDetailsScreen calls onDeleteProduct when the delete confirmation is confirmed',
      (WidgetTester tester) async {
        bool called = false;
        when(
          () => mockViewModel.onDeleteProduct,
        ).thenReturn(() => called = true);

        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('product-details-delete-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('confirm-dialog-confirm-button')),
        );
        await tester.pumpAndSettle();

        expect(called, isA<bool>());
        expect(called, isTrue);
      },
    );

    testWidgets(
      'ProductDetailsScreen does not call onDeleteProduct when the delete confirmation is cancelled',
      (WidgetTester tester) async {
        bool called = false;
        when(
          () => mockViewModel.onDeleteProduct,
        ).thenReturn(() => called = true);

        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('product-details-delete-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('confirm-dialog-cancel-button')));
        await tester.pumpAndSettle();

        expect(called, isA<bool>());
        expect(called, isFalse);
      },
    );
  });

  group(
    "ProductDetailsScreen's StoreConnector does not dispatch source loading on init",
    () {
      testWidgets(
        'ProductDetailsScreen does not dispatch a source-loading action on init',
        (WidgetTester tester) async {
          await pumpScreen(tester);

          expect(dispatchedActions, isEmpty);
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
        await pumpScreen(tester);

        expect(find.text(t.productDetails.available), findsNWidgets(2));
        expect(find.text(t.productDetails.unavailable), findsOneWidget);
        expect(find.text(t.productDetails.filterAll), findsOneWidget);
        expect(find.text(t.productDetails.filterAvailable), findsOneWidget);
        expect(find.text(t.productDetails.filterUnavailable), findsOneWidget);
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
          await pumpScreen(tester);
          await expectLater(tester, meetsGuideline(textContrastGuideline));

          await pumpScreen(tester, themeMode: ThemeMode.dark);
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        } finally {
          handle.dispose();
        }
      });

      testWidgets(
        'ProductDetailsScreen all tap targets meet minimum 48dp size',
        (WidgetTester tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await pumpScreen(tester);

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'ProductDetailsScreen all interactive elements have semantic labels',
        (WidgetTester tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await pumpScreen(tester);

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'ProductDetailsScreen renders without overflow at 150% text scale',
        (WidgetTester tester) async {
          await pumpScreen(tester, textScaler: const TextScaler.linear(1.5));

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
          await pumpScreen(tester, textScaler: const TextScaler.linear(2.0));

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
          await pumpScreen(tester);

          final List<Key> focusableKeys = [
            const Key('product-details-back-button'),
            const Key('product-details-rename-button'),
            const Key('product-details-delete-button'),
            const Key('product-details-source-filter-all'),
            const Key('product-details-source-filter-available'),
            const Key('product-details-source-filter-unavailable'),
          ];

          for (final Key key in focusableKeys) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
            final bool focused = hasPrimaryFocusWithin(tester, find.byKey(key));
            expect(focused, isA<bool>());
            expect(focused, isTrue);
          }
        },
      );
    },
  );
}
