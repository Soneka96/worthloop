// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/tracked_product_store.widget.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../products/fixtures/product.fixture.dart';
import '../../../products/fixtures/product_source.fixture.dart';

void main() {
  testWidgets('displays the row status for its own source', (
    WidgetTester tester,
  ) async {
    final product = buildProduct(sources: [buildProductSource(id: 'source-1')]);
    final Store<AppState> store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          products: [product],
          sourceRefreshStatuses: {'source-1': SourceRefreshStatus.error},
        ),
      ),
    );

    await tester.pumpWidget(
      TranslationProvider(
        child: StoreProvider<AppState>(
          store: store,
          child: MaterialApp(
            home: Scaffold(
              body: TrackedProductStoreWidget(product: product, onTap: () {}),
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const Key('tracked-product-product-1-refresh-status')),
      findsOneWidget,
    );
  });
}
