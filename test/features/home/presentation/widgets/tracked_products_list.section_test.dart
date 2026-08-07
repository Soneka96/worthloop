// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/home_search_field.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_product.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_empty.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_list.section.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_no_matches.widget.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../products/fixtures/product.fixture.dart';
import '../../../products/fixtures/product_source.fixture.dart';

void main() {
  final List<Product> products = [
    buildProduct(id: 'product-1', name: 'Wireless Mouse'),
    buildProduct(id: 'product-2', name: 'Mechanical Keyboard'),
  ];

  Widget buildWidget({
    List<Product> products = const [],
    bool isLoading = false,
    ValueChanged<String>? onProductTap,
    Map<String, SourceRefreshStatus> sourceRefreshStatuses = const {},
  }) {
    final Store<AppState> store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          products: products,
          sourceRefreshStatuses: sourceRefreshStatuses,
        ),
      ),
    );
    return TranslationProvider(
      child: StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                TrackedProductsListSection(
                  products: products,
                  isLoading: isLoading,
                  onProductTap: onProductTap ?? (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  group('TrackedProductsListSection contains widgets', () {
    testWidgets(
      'TrackedProductsListSection contains a CircularProgressIndicator with the correct parameters when isLoading = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(isLoading: true));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(HomeSearchField), findsNothing);
      },
    );

    testWidgets(
      'TrackedProductsListSection contains a TrackedProductsEmptyWidget with the correct parameters when products is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(TrackedProductsEmptyWidget), findsOneWidget);
        expect(find.byType(HomeSearchField), findsNothing);
      },
    );

    testWidgets(
      'TrackedProductsListSection contains a CircularProgressIndicator with the correct parameters when isLoading = true and products is not empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(products: products, isLoading: true),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(HomeSearchField), findsNothing);
        expect(
          find.byKey(const Key('tracked-product-product-1')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'TrackedProductsListSection contains a HomeSearchField and a TrackedProductWidget per product with the correct parameters when products is not empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(products: products));

        expect(find.byType(HomeSearchField), findsOneWidget);
        expect(
          find.byKey(const Key('tracked-product-product-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tracked-product-product-2')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'TrackedProductsListSection contains a TrackedProductsNoMatchesWidget with the correct parameters when the search query matches no product',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(products: products));

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'headphones',
        );
        await tester.pump();

        expect(find.byType(TrackedProductsNoMatchesWidget), findsOneWidget);
        expect(find.byType(TrackedProductWidget), findsNothing);
        expect(find.byType(HomeSearchField), findsOneWidget);
      },
    );

    testWidgets(
      'TrackedProductsListSection passes source refresh statuses to the product card',
      (WidgetTester tester) async {
        final Product product = buildProduct(sources: [buildProductSource()]);

        await tester.pumpWidget(
          buildWidget(
            products: [product],
            sourceRefreshStatuses: {'source-1': SourceRefreshStatus.error},
          ),
        );

        expect(
          find.byKey(const Key('tracked-product-product-1-refresh-status')),
          findsOneWidget,
        );
      },
    );
  });

  group("TrackedProductsListSection's elements behavior", () {
    testWidgets(
      'TrackedProductsListSection filters the product list by a case-insensitive name match when a search query is entered',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(products: products));

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'KEY',
        );
        await tester.pump();

        expect(
          find.byKey(const Key('tracked-product-product-2')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tracked-product-product-1')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'TrackedProductsListSection shows every product when the search query is whitespace-only',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(products: products));

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          '   ',
        );
        await tester.pump();

        expect(
          find.byKey(const Key('tracked-product-product-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tracked-product-product-2')),
          findsOneWidget,
        );
        expect(find.byType(TrackedProductsNoMatchesWidget), findsNothing);
      },
    );

    testWidgets(
      'TrackedProductsListSection shows every product again when the search query is cleared',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(products: products));

        await tester.enterText(
          find.byKey(const Key('home-search-field')),
          'KEY',
        );
        await tester.pump();
        await tester.tap(find.byKey(const Key('home-search-clear-button')));
        await tester.pump();

        expect(
          find.byKey(const Key('tracked-product-product-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('tracked-product-product-2')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'TrackedProductsListSection calls onProductTap with the tapped product id',
      (WidgetTester tester) async {
        String? tappedId;
        await tester.pumpWidget(
          buildWidget(products: products, onProductTap: (id) => tappedId = id),
        );

        await tester.tap(find.byKey(const Key('tracked-product-product-2')));

        expect(tappedId, isA<String>());
        expect(tappedId, 'product-2');
      },
    );
  });

  group("TrackedProductsListSection's translations", () {
    testWidgets(
      'TrackedProductsListSection displays the Portuguese translations',
      (WidgetTester tester) async {
        LocaleSettings.setLocale(AppLocale.pt);

        try {
          await tester.pumpWidget(buildWidget(products: products));
          expect(find.text(t.home.searchHint), findsOneWidget);

          await tester.enterText(
            find.byKey(const Key('home-search-field')),
            'headphones',
          );
          await tester.pump();

          expect(
            find.text(t.home.noSearchResultsDescription(query: 'headphones')),
            findsOneWidget,
          );
        } finally {
          LocaleSettings.setLocale(AppLocale.en);
        }
      },
    );
  });
}
