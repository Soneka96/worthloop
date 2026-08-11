// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/tracked_product_refresh.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../../products/fixtures/product.fixture.dart';
import '../../../../products/fixtures/product_source.fixture.dart';

void main() {
  test('selects statuses for the tracked product', () {
    final product = buildProduct(sources: [buildProductSource(id: 'source-1')]);
    final Store<AppState> store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          products: [product],
          sourceRefreshStatuses: {'source-1': SourceRefreshStatus.fetching},
        ),
      ),
    );

    final viewModel = TrackedProductRefreshViewModel.fromStore(store, product);

    expect(viewModel.product, product);
    expect(viewModel.sourceRefreshStatuses, {
      'source-1': SourceRefreshStatus.fetching,
    });
  });

  test('compares equal when the selected product statuses are unchanged', () {
    final product = buildProduct(sources: [buildProductSource(id: 'source-1')]);
    const status = SourceRefreshStatus.fetching;
    final first = TrackedProductRefreshViewModel(
      product: product,
      sourceRefreshStatuses: {'source-1': status},
    );
    final second = TrackedProductRefreshViewModel(
      product: product,
      sourceRefreshStatuses: {'source-1': status},
    );

    expect(first, second);
  });
}
