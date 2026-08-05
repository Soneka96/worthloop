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
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/rename_product_dialog.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/store_price.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';
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
    when(() => mockViewModel.sources).thenReturn([]);
    when(() => mockViewModel.isLoadingSources).thenReturn(false);
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
    when(() => mockViewModel.onGoBack).thenReturn(() {});
    when(() => mockViewModel.onAddSource).thenReturn((_) {});
    when(() => mockViewModel.onEditSource).thenReturn((_, _) {});
    when(() => mockViewModel.onDeleteSource).thenReturn((_) {});
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

  /// Pumps [ProductDetailsScreen] with an enlarged surface so the
  /// Sources section — the last sliver in the page — is actually built and
  /// findable instead of staying off-screen at the default test viewport
  /// size.
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
      'ProductDetailsScreen contains product and offer data with the correct parameters',
      (WidgetTester tester) async {
        await pumpScreen(tester);

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
      await pumpScreen(tester);

      final SliverList sliverList = tester.widget(find.byType(SliverList).last);

      expect(sliverList.delegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets(
      'ProductDetailsScreen contains offers sorted with available prices first',
      (WidgetTester tester) async {
        await pumpScreen(tester);

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

        await pumpScreen(tester);

        expect(find.text('Product not found'), findsOneWidget);
        expect(find.byType(IllustrativePriceNotice), findsNothing);
        expect(find.byType(StorePriceWidget), findsNothing);
      },
    );

    testWidgets('ProductDetailsScreen explains when no offers exist', (
      WidgetTester tester,
    ) async {
      when(() => mockViewModel.product).thenReturn(buildProduct());

      await pumpScreen(tester);

      expect(find.text(t.productDetails.noOffers), findsOneWidget);
      expect(find.byType(StorePriceWidget), findsNothing);
    });

    testWidgets(
      'ProductDetailsScreen contains a "product-details-add-source-button" FilledButton with the correct parameters',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(
          find.byKey(const Key('product-details-add-source-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a ProductSourcesEmptyWidget with the correct parameters when sources is empty',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        expect(find.byType(ProductSourcesEmptyWidget), findsOneWidget);
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a ProductSourceRow per source with the correct parameters when sources is not empty',
      (WidgetTester tester) async {
        when(() => mockViewModel.sources).thenReturn([
          buildProductSource(id: 'source-1'),
          buildProductSource(id: 'source-2'),
        ]);

        await pumpScreen(tester);

        expect(
          find.byKey(const Key('product-source-source-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-source-source-2')),
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
      'ProductDetailsScreen contains a "product-details-refresh-button" FilledButton with the correct behavior',
      (WidgetTester tester) async {
        when(
          () => mockViewModel.onRefresh,
        ).thenReturn(() => print('refresh called'));

        await pumpScreen(tester);

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

        await pumpScreen(tester);

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

        await pumpScreen(tester);
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

        await pumpScreen(tester);

        await expectLater(
          () => tester.tap(
            find.byKey(const Key('product-details-refresh-button')),
          ),
          prints(isEmpty),
        );
      },
    );

    testWidgets(
      'ProductDetailsScreen contains a "product-details-add-source-button" FilledButton with the correct behavior',
      (WidgetTester tester) async {
        await pumpScreen(tester);

        await tester.tap(
          find.byKey(const Key('product-details-add-source-button')),
        );
        await tester.pumpAndSettle();

        final SourceFormDialog dialog = tester.widget(
          find.byType(SourceFormDialog),
        );
        expect(dialog.productId, isA<String>());
        expect(dialog.productId, 'product-1');
      },
    );

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
    "ProductDetailsScreen's StoreConnector dispatches LoadProductSourcesAction on init",
    () {
      testWidgets(
        'ProductDetailsScreen dispatches LoadProductSourcesAction on init',
        (WidgetTester tester) async {
          await pumpScreen(tester);

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
        await pumpScreen(tester);

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
        expect(find.text(t.productDetails.sourcesTitle), findsOneWidget);
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

          const Key backKey = Key('product-details-back-button');
          const Key renameKey = Key('product-details-rename-button');
          const Key deleteKey = Key('product-details-delete-button');
          const Key refreshKey = Key('product-details-refresh-button');
          const Key addSourceKey = Key('product-details-add-source-button');

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool backFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(backKey),
          );

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool renameFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(renameKey),
          );

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool deleteFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(deleteKey),
          );

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool refreshFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(refreshKey),
          );

          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          final bool addSourceFocused = hasPrimaryFocusWithin(
            tester,
            find.byKey(addSourceKey),
          );

          expect(backFocused, isA<bool>());
          expect(backFocused, isTrue);
          expect(renameFocused, isA<bool>());
          expect(renameFocused, isTrue);
          expect(deleteFocused, isA<bool>());
          expect(deleteFocused, isTrue);
          expect(refreshFocused, isA<bool>());
          expect(refreshFocused, isTrue);
          expect(addSourceFocused, isA<bool>());
          expect(addSourceFocused, isTrue);
        },
      );
    },
  );
}
