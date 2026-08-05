// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../../fixtures/product.fixture.dart';
import '../../../fixtures/product_source.fixture.dart';

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
          final ProductSource source = buildProductSource();
          final AppState state = AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(
              products: [product],
              refreshingProductIds: {product.id},
              productRefreshStatuses: {product.id: PriceFetchStatus.blocked},
              sourcesByProduct: {
                product.id: [source],
              },
              loadingSourcesProductIds: {product.id},
              isAddingSource: true,
              addSourceError: const Some('add failed'),
              editingSourceId: const Some('source-1'),
              editSourceError: const Some('edit failed'),
              deletingSourceIds: {'source-1'},
              deleteSourceError: const Some('delete failed'),
            ),
          );

          final ProductDetailsViewModel viewmodel =
              ProductDetailsViewModel.fromStore(buildStore(state), product.id);

          expect(viewmodel.product, product);
          expect(viewmodel.isRefreshing, isA<bool>());
          expect(viewmodel.isRefreshing, isTrue);
          expect(viewmodel.refreshStatus, isA<PriceFetchStatus>());
          expect(viewmodel.refreshStatus, PriceFetchStatus.blocked);
          expect(viewmodel.sources, [source]);
          expect(viewmodel.isLoadingSources, isA<bool>());
          expect(viewmodel.isLoadingSources, isTrue);
          expect(viewmodel.isAddingSource, isA<bool>());
          expect(viewmodel.isAddingSource, isTrue);
          expect(viewmodel.addSourceError, 'add failed');
          expect(viewmodel.editingSourceId, 'source-1');
          expect(viewmodel.editSourceError, 'edit failed');
          expect(viewmodel.deletingSourceIds, {'source-1'});
          expect(viewmodel.deleteSourceError, 'delete failed');
          expect(viewmodel.onRefresh, isA<Function()>());
          expect(viewmodel.onGoBack, isA<Function()>());
          expect(viewmodel.onAddSource, isA<Function(String)>());
          expect(viewmodel.onEditSource, isA<Function(String, String)>());
          expect(viewmodel.onDeleteSource, isA<Function(String)>());
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

      test('Method onAddSource dispatches AddSourceAction when called', () {
        final ProductDetailsViewModel viewmodel =
            ProductDetailsViewModel.fromStore(
              buildStore(AppState.initial()),
              'product-1',
            );

        viewmodel.onAddSource('https://example.com/products/1');

        expect(dispatchedActions, [
          const AddSourceAction(
            productId: 'product-1',
            url: 'https://example.com/products/1',
          ),
        ]);
      });

      test('Method onEditSource dispatches EditSourceAction when called', () {
        final ProductDetailsViewModel viewmodel =
            ProductDetailsViewModel.fromStore(
              buildStore(AppState.initial()),
              'product-1',
            );

        viewmodel.onEditSource('source-1', 'https://example.com/updated');

        expect(dispatchedActions, [
          const EditSourceAction(
            sourceId: 'source-1',
            url: 'https://example.com/updated',
          ),
        ]);
      });

      test(
        'Method onDeleteSource dispatches DeleteSourceAction when called',
        () {
          final ProductDetailsViewModel viewmodel =
              ProductDetailsViewModel.fromStore(
                buildStore(AppState.initial()),
                'product-1',
              );

          viewmodel.onDeleteSource('source-1');

          expect(dispatchedActions, [
            const DeleteSourceAction(
              productId: 'product-1',
              sourceId: 'source-1',
            ),
          ]);
        },
      );
    },
  );
}
