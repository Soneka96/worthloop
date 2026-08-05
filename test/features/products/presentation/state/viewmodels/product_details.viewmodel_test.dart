// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../fixtures/product.fixture.dart';

void main() {
  late List<dynamic> dispatchedActions;

  Store<AppState> buildStore(AppState initialState) =>
      Store<AppState>((AppState state, dynamic action) {
        dispatchedActions.add(action);
        return state;
      }, initialState: initialState);

  setUp(() {
    dispatchedActions = [];
  });

  group(
    'ProductDetailsViewModel constructor initializes all parameters correctly',
    () {
      test(
        'Method fromStore() constructs ProductDetailsViewModel correctly',
        () {
          final Product product = buildProduct();
          final AppState state = AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(
              products: [product],
              refreshingProductIds: {product.id},
              productRefreshStatuses: {product.id: PriceFetchStatus.blocked},
            ),
          );

          final ProductDetailsViewModel viewmodel =
              ProductDetailsViewModel.fromStore(buildStore(state), product.id);

          expect(viewmodel.product, product);
          expect(viewmodel.isRefreshing, isA<bool>());
          expect(viewmodel.isRefreshing, isTrue);
          expect(viewmodel.refreshStatus, isA<PriceFetchStatus>());
          expect(viewmodel.refreshStatus, PriceFetchStatus.blocked);
          expect(viewmodel.onRefresh, isA<Function()>());
          expect(viewmodel.onGoBack, isA<Function()>());
        },
      );

      test('Method onRefresh dispatches RefreshProductAction when called', () {
        final ProductDetailsViewModel viewmodel =
            ProductDetailsViewModel.fromStore(
              buildStore(AppState.initial()),
              'product-1',
            );

        viewmodel.onRefresh();

        expect(dispatchedActions, [const RefreshProductAction('product-1')]);
      });

      test(
        'Method onGoBack dispatches GoBackFromProductDetailsAction when called',
        () {
          final ProductDetailsViewModel viewmodel =
              ProductDetailsViewModel.fromStore(
                buildStore(AppState.initial()),
                'product-1',
              );

          viewmodel.onGoBack();

          expect(dispatchedActions, [const GoBackFromProductDetailsAction()]);
        },
      );
    },
  );
}
