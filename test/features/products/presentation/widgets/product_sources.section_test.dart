// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/merchant_offer_row.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources.section.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

class MockProductDetailsViewModel extends Mock
    implements ProductDetailsViewModel {}

void main() {
  late MockProductDetailsViewModel mockViewModel;
  late Store<AppState> store;
  final ProductSource availableSource = buildProductSource(
    id: 'source-1',
    url: 'https://example.com/products/1',
    currentPrice: const Money(minorUnits: 1000, currencyCode: 'EUR'),
    isAvailable: true,
  );
  final ProductSource unavailableSource = buildProductSource(
    id: 'source-2',
    url: 'https://another.com/products/2',
    merchantDomain: 'another.com',
    currentPrice: const Money(minorUnits: 2000, currencyCode: 'EUR'),
    isAvailable: false,
  );
  final ProductSource unknownAvailabilitySource = buildProductSource(
    id: 'source-3',
    url: 'https://unknown.com/products/3',
    merchantDomain: 'unknown.com',
  );
  final List<ProductSource> sources = [
    availableSource,
    unavailableSource,
    unknownAvailabilitySource,
  ];

  setUp(() {
    mockViewModel = MockProductDetailsViewModel();
    when(() => mockViewModel.isAddingSource).thenReturn(false);
    when(() => mockViewModel.addSourceError).thenReturn(null);
    when(() => mockViewModel.editingSourceId).thenReturn(null);
    when(() => mockViewModel.editSourceError).thenReturn(null);
    when(() => mockViewModel.onAddSource).thenReturn((_) {});
    when(() => mockViewModel.onEditSource).thenReturn((_, _) {});

    sl.registerFactoryParam<ProductDetailsViewModel, Store<AppState>, String>(
      (store, productId) => mockViewModel,
    );

    store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );
  });

  tearDown(() async {
    await sl.reset();
    reset(mockViewModel);
  });

  Widget buildWidget({
    List<ProductSource> sources = const [],
    bool isRefreshing = false,
    Map<String, SourceRefreshStatus> sourceRefreshStatuses = const {},
    Set<String> deletingSourceIds = const {},
    ValueChanged<String>? onDeleteSource,
    ValueChanged<String>? onRefreshSource,
    ValueChanged<String>? onOpenOffer,
  }) => TranslationProvider(
    child: StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              ProductSourcesSection(
                product: buildProduct(sources: sources),
                isRefreshing: isRefreshing,
                sourceRefreshStatuses: sourceRefreshStatuses,
                deletingSourceIds: deletingSourceIds,
                onRefreshSource: onRefreshSource ?? (_) {},
                onDeleteSource: onDeleteSource ?? (_) {},
                onOpenOffer: onOpenOffer ?? (_) {},
              ),
            ],
          ),
        ),
      ),
    ),
  );

  group('ProductSourcesSection contains widgets', () {
    testWidgets(
      'ProductSourcesSection contains filters without refresh or add-source controls',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        expect(find.byType(FilterChip), findsNWidgets(4));
        expect(find.byType(OutlinedButton), findsNothing);
        expect(find.byType(FilledButton), findsNothing);
        expect(find.textContaining('sources checked'), findsNothing);
      },
    );

    testWidgets(
      'ProductSourcesSection contains a ProductSourcesEmptyWidget with the correct parameters when product.sources is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(ProductSourcesEmptyWidget), findsOneWidget);
        expect(find.byType(MerchantOfferRow), findsNothing);
      },
    );

    testWidgets(
      'ProductSourcesSection contains a MerchantOfferRow per source with the correct parameters when product.sources is not empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        expect(
          find.byKey(const Key('merchant-offer-source-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('merchant-offer-source-2')),
          findsOneWidget,
        );
        final MerchantOfferRow idleRow = tester.widget(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-1',
          ),
        );
        expect(idleRow.refreshStatus, SourceRefreshStatus.idle);
      },
    );

    testWidgets('ProductSourcesSection uses a lazy offer list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(sources: sources));

      final SliverList sliverList = tester.widget(find.byType(SliverList));

      expect(sliverList.delegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets(
      'ProductSourcesSection displays sources in domain order and preserves it in filters',
      (WidgetTester tester) async {
        final ProductSource expensiveAvailable = buildProductSource(
          id: 'source-expensive-available',
          merchantDomain: 'expensive.example.com',
          currentPrice: const Money(minorUnits: 3000, currencyCode: 'EUR'),
          isAvailable: true,
        );
        final ProductSource cheapAvailable = buildProductSource(
          id: 'source-cheap-available',
          merchantDomain: 'cheap.example.com',
          currentPrice: const Money(minorUnits: 1000, currencyCode: 'EUR'),
          isAvailable: true,
        );
        final ProductSource unavailable = buildProductSource(
          id: 'source-unavailable',
          merchantDomain: 'unavailable.example.com',
          currentPrice: const Money(minorUnits: 2000, currencyCode: 'EUR'),
          isAvailable: false,
        );
        final ProductSource cheaperUnavailable = buildProductSource(
          id: 'source-cheaper-unavailable',
          merchantDomain: 'cheaper-unavailable.example.com',
          currentPrice: const Money(minorUnits: 1500, currencyCode: 'EUR'),
          isAvailable: false,
        );
        final ProductSource unpriced = buildProductSource(
          id: 'source-unpriced',
          merchantDomain: 'unpriced.example.com',
          isAvailable: null,
        );
        final ProductSource secondUnpriced = buildProductSource(
          id: 'source-second-unpriced',
          merchantDomain: 'second-unpriced.example.com',
          isAvailable: null,
        );
        await tester.pumpWidget(
          buildWidget(
            sources: [
              expensiveAvailable,
              unpriced,
              unavailable,
              secondUnpriced,
              cheaperUnavailable,
              cheapAvailable,
            ],
          ),
        );

        List<String> visibleSourceIds() => tester
            .widgetList<MerchantOfferRow>(find.byType(MerchantOfferRow))
            .map((MerchantOfferRow row) => row.source.id)
            .toList();

        expect(visibleSourceIds(), [
          cheapAvailable.id,
          expensiveAvailable.id,
          cheaperUnavailable.id,
          unavailable.id,
          unpriced.id,
          secondUnpriced.id,
        ]);
        final MerchantOfferRow bestRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow &&
                widget.source.id == cheapAvailable.id,
          ),
        );
        expect(bestRow.isBestPrice, isA<bool>());
        expect(bestRow.isBestPrice, isTrue);

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-available')),
        );
        await tester.pumpAndSettle();
        expect(visibleSourceIds(), [cheapAvailable.id, expensiveAvailable.id]);

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-unavailable')),
        );
        await tester.pumpAndSettle();
        expect(visibleSourceIds(), [
          cheaperUnavailable.id,
          unavailable.id,
          unpriced.id,
          secondUnpriced.id,
        ]);
      },
    );

    testWidgets(
      'ProductSourcesSection preserves source order while refreshing',
      (WidgetTester tester) async {
        final ProductSource first = buildProductSource(
          id: 'source-first',
          currentPrice: const Money(minorUnits: 3000, currencyCode: 'EUR'),
          isAvailable: true,
        );
        final ProductSource second = buildProductSource(
          id: 'source-second',
          merchantDomain: 'second.example.com',
          currentPrice: const Money(minorUnits: 1000, currencyCode: 'EUR'),
          isAvailable: true,
        );
        await tester.pumpWidget(
          buildWidget(
            sources: [first, second],
            isRefreshing: true,
            sourceRefreshStatuses: {
              first.id: SourceRefreshStatus.fetching,
              second.id: SourceRefreshStatus.success,
            },
          ),
        );

        final List<String> visibleSourceIds = tester
            .widgetList<MerchantOfferRow>(find.byType(MerchantOfferRow))
            .map((MerchantOfferRow row) => row.source.id)
            .toList();

        expect(visibleSourceIds, [second.id, first.id]);
        expect(
          tester
              .widget<MerchantOfferRow>(
                find.byWidgetPredicate(
                  (Widget widget) =>
                      widget is MerchantOfferRow &&
                      widget.source.id == first.id,
                ),
              )
              .refreshStatus,
          SourceRefreshStatus.fetching,
        );
      },
    );

    testWidgets(
      'ProductSourcesSection contains a MerchantOfferRow with isDeleting = true only for the source id in deletingSourceIds',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(sources: sources, deletingSourceIds: const {'source-1'}),
        );

        final MerchantOfferRow deletingRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-1',
          ),
        );
        final MerchantOfferRow otherRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-2',
          ),
        );
        expect(deletingRow.isDeleting, isA<bool>());
        expect(deletingRow.isDeleting, isTrue);
        expect(otherRow.isDeleting, isA<bool>());
        expect(otherRow.isDeleting, isFalse);
      },
    );

    testWidgets(
      'ProductSourcesSection marks only the lowest available priced source as the best price',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        final MerchantOfferRow bestRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-1',
          ),
        );
        final MerchantOfferRow unavailableRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-2',
          ),
        );
        final MerchantOfferRow unknownRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-3',
          ),
        );
        expect(bestRow.isBestPrice, isA<bool>());
        expect(bestRow.isBestPrice, isTrue);
        expect(unavailableRow.isBestPrice, isA<bool>());
        expect(unavailableRow.isBestPrice, isFalse);
        expect(unknownRow.isBestPrice, isA<bool>());
        expect(unknownRow.isBestPrice, isFalse);
      },
    );

    testWidgets(
      'ProductSourcesSection does not mark a source as the best price when no available price exists',
      (WidgetTester tester) async {
        final ProductSource unavailable = buildProductSource(
          id: 'source-4',
          isAvailable: false,
          currentPrice: const Money(minorUnits: 1000, currencyCode: 'EUR'),
        );
        await tester.pumpWidget(buildWidget(sources: [unavailable]));

        final MerchantOfferRow row = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is MerchantOfferRow && widget.source.id == 'source-4',
          ),
        );
        expect(row.isBestPrice, isA<bool>());
        expect(row.isBestPrice, isFalse);
      },
    );

    testWidgets(
      'ProductSourcesSection contains filter chips when product.sources is not empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        expect(
          find.byKey(const Key('product-details-source-filter-all')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-details-source-filter-available')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-details-source-filter-unavailable')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-details-source-filter-issues')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductSourcesSection displays only available offers when the available filter is selected',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-available')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MerchantOfferRow), findsOneWidget);
        expect(
          find.byKey(const Key('merchant-offer-source-1')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('merchant-offer-source-2')), findsNothing);
        final FilterChip allChip = tester.widget(
          find.byKey(const Key('product-details-source-filter-all')),
        );
        final FilterChip availableChip = tester.widget(
          find.byKey(const Key('product-details-source-filter-available')),
        );
        expect(allChip.selected, isA<bool>());
        expect(allChip.selected, isFalse);
        expect(availableChip.selected, isA<bool>());
        expect(availableChip.selected, isTrue);

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-all')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MerchantOfferRow), findsNWidgets(3));
      },
    );

    testWidgets(
      'ProductSourcesSection displays only unavailable offers when the unavailable filter is selected',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-unavailable')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MerchantOfferRow), findsNWidgets(2));
        expect(find.byKey(const Key('merchant-offer-source-1')), findsNothing);
        expect(
          find.byKey(const Key('merchant-offer-source-2')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('merchant-offer-source-3')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductSourcesSection displays only sources with refresh errors when the issues filter is selected',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            isRefreshing: true,
            sourceRefreshStatuses: {
              availableSource.id: SourceRefreshStatus.error,
              unavailableSource.id: SourceRefreshStatus.error,
              unknownAvailabilitySource.id: SourceRefreshStatus.error,
            },
          ),
        );

        expect(find.byType(MerchantOfferRow), findsNWidgets(3));

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-issues')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MerchantOfferRow), findsNWidgets(3));
        expect(
          find.byKey(const Key('merchant-offer-source-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('merchant-offer-source-2')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('merchant-offer-source-3')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductSourcesSection displays no-offers copy when the issues filter has no errors',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            sourceRefreshStatuses: {
              availableSource.id: SourceRefreshStatus.success,
              unavailableSource.id: SourceRefreshStatus.unavailable,
              unknownAvailabilitySource.id: SourceRefreshStatus.success,
            },
          ),
        );

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-issues')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MerchantOfferRow), findsNothing);
        expect(find.text(t.productDetails.noOffers), findsOneWidget);
      },
    );

    testWidgets(
      'ProductSourcesSection excludes issue sources from available and unavailable filters',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            sourceRefreshStatuses: {
              availableSource.id: SourceRefreshStatus.error,
              unavailableSource.id: SourceRefreshStatus.success,
              unknownAvailabilitySource.id: SourceRefreshStatus.error,
            },
          ),
        );

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-available')),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MerchantOfferRow), findsNothing);
        expect(find.text(t.productDetails.noOffers), findsOneWidget);

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-unavailable')),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MerchantOfferRow), findsOneWidget);
        expect(
          find.byKey(const Key('merchant-offer-source-2')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('merchant-offer-source-1')), findsNothing);
        expect(find.byKey(const Key('merchant-offer-source-3')), findsNothing);
      },
    );

    testWidgets(
      'ProductSourcesSection displays no-offers copy when the selected filter has no matches',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: [availableSource]));

        await tester.tap(
          find.byKey(const Key('product-details-source-filter-unavailable')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MerchantOfferRow), findsNothing);
        expect(find.text(t.productDetails.noOffers), findsOneWidget);
      },
    );
  });

  group("ProductSourcesSection's elements behavior", () {
    testWidgets(
      'ProductSourcesSection calls onOpenOffer when an offer is tapped',
      (WidgetTester tester) async {
        String? openedUrl;
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            onOpenOffer: (String url) => openedUrl = url,
          ),
        );

        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-tap-target')),
        );

        expect(openedUrl, isA<String>());
        expect(openedUrl, availableSource.url);
      },
    );

    testWidgets(
      'ProductSourcesSection calls onRefreshSource for a slid source action',
      (WidgetTester tester) async {
        String? refreshedId;
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            onRefreshSource: (String id) => refreshedId = id,
          ),
        );

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-refresh-action')),
        );
        await tester.pumpAndSettle();

        expect(refreshedId, 'source-1');
      },
    );

    testWidgets(
      'ProductSourcesSection contains a merchant-offer edit action with the correct behavior',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-edit-action')),
        );
        await tester.pumpAndSettle();

        final SourceFormDialog dialog = tester.widget(
          find.byType(SourceFormDialog),
        );
        expect(dialog.source, isA<ProductSource>());
        expect(dialog.source?.id, 'source-1');
      },
    );

    testWidgets(
      'ProductSourcesSection calls onDeleteSource when the delete confirmation is confirmed',
      (WidgetTester tester) async {
        String? deletedId;
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            onDeleteSource: (String id) => deletedId = id,
          ),
        );

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-delete-action')),
        );
        await tester.pumpAndSettle();
        expect(find.text(t.productDetails.deleteSourceTitle), findsOneWidget);
        expect(
          find.text(
            t.productDetails.deleteSourceMessage(
              merchant: availableSource.merchantDomain,
            ),
          ),
          findsOneWidget,
        );
        await tester.tap(
          find.byKey(const Key('confirm-dialog-confirm-button')),
        );
        await tester.pumpAndSettle();

        expect(deletedId, isA<String>());
        expect(deletedId, 'source-1');
      },
    );

    testWidgets(
      'ProductSourcesSection does not call onDeleteSource when the delete confirmation is cancelled',
      (WidgetTester tester) async {
        String? deletedId;
        await tester.pumpWidget(
          buildWidget(
            sources: sources,
            onDeleteSource: (String id) => deletedId = id,
          ),
        );

        await tester.drag(
          find.byKey(const Key('merchant-offer-source-1')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('merchant-offer-source-1-delete-action')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('confirm-dialog-cancel-button')));
        await tester.pumpAndSettle();

        expect(deletedId, isNull);
      },
    );
  });

  group("ProductSourcesSection's translations", () {
    testWidgets('ProductSourcesSection displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget(sources: sources));
        expect(find.text(t.productDetails.filterAll), findsOneWidget);
        expect(find.text(t.productDetails.filterAvailable), findsOneWidget);
        expect(find.text(t.productDetails.filterUnavailable), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
