// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.reducer.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

void main() {
  group('productsReducer processes LoadProductsAction correctly', () {
    test('LoadProductsAction modifies loading and error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        products: [buildProduct()],
        error: const Some('old failure'),
      );
      final ProductsState reducedState = productsReducer(
        state,
        const LoadProductsAction(),
      );

      expect(state.isLoading, isA<bool>());
      expect(state.isLoading, isFalse, reason: 'loading starts false');
      expect(reducedState.isLoading, isA<bool>());
      expect(reducedState.isLoading, isTrue, reason: 'loading starts');
      expect(reducedState.error, isNull, reason: 'old error is cleared');
      expect(
        reducedState.products,
        state.products,
        reason: 'products are preserved',
      );
    });
  });

  group('productsReducer processes ProductsLoadedAction correctly', () {
    test('ProductsLoadedAction modifies products and operation flags', () {
      final ProductsState state = ProductsState.initial().copyWith(
        isLoading: true,
        isRefreshingAll: true,
        refreshingProductIds: {'product-1'},
        error: const Some('old failure'),
        productRefreshStatuses: {'product-1': PriceFetchStatus.blocked},
      );
      final Product product = buildProduct();
      final ProductsState reducedState = productsReducer(
        state,
        ProductsLoadedAction([product]),
      );

      expect(state.products, isEmpty, reason: 'products start empty');
      expect(reducedState.products, [product], reason: 'products are replaced');
      expect(reducedState.isLoading, isA<bool>());
      expect(reducedState.isLoading, isFalse, reason: 'loading completes');
      expect(reducedState.isRefreshingAll, isA<bool>());
      expect(
        reducedState.isRefreshingAll,
        isFalse,
        reason: 'refresh completes',
      );
      expect(
        reducedState.refreshingProductIds,
        isEmpty,
        reason: 'individual refreshes complete',
      );
      expect(reducedState.error, isNull, reason: 'old error is cleared');
      expect(
        state.productRefreshStatuses,
        {'product-1': PriceFetchStatus.blocked},
        reason: 'a stale per-product status existed before the load',
      );
      expect(
        reducedState.productRefreshStatuses,
        isEmpty,
        reason: 'stale per-product statuses clear on a fresh load',
      );
    });
  });

  group('productsReducer processes ProductsLoadFailedAction correctly', () {
    test('ProductsLoadFailedAction modifies loading and error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        isLoading: true,
      );
      final ProductsState reducedState = productsReducer(
        state,
        const ProductsLoadFailedAction('failed'),
      );

      expect(state.isLoading, isA<bool>());
      expect(state.isLoading, isTrue, reason: 'loading was active');
      expect(reducedState.isLoading, isA<bool>());
      expect(reducedState.isLoading, isFalse, reason: 'loading completes');
      expect(reducedState.error, isA<String>());
      expect(reducedState.error, 'failed', reason: 'failure is stored');
    });
  });

  group('productsReducer processes CreateProductAction correctly', () {
    test('CreateProductAction starts creation and clears its result', () {
      final ProductsState state = ProductsState.initial().copyWith(
        creationError: const Some('old failure'),
        createdProductId: const Some('old-product'),
      );

      final ProductsState reducedState = productsReducer(
        state,
        const CreateProductAction(
          name: 'Example Product',
          url: 'https://example.com/products/1',
        ),
      );

      expect(state.isCreatingProduct, isFalse, reason: 'creation starts idle');
      expect(reducedState.isCreatingProduct, isTrue, reason: 'creation starts');
      expect(
        reducedState.creationError,
        isNull,
        reason: 'old creation error is cleared',
      );
      expect(
        reducedState.createdProductId,
        isNull,
        reason: 'old created product is cleared',
      );
    });
  });

  group('productsReducer processes ProductCreatedAction correctly', () {
    test('ProductCreatedAction appends the product and completes creation', () {
      final Product product = buildProduct();
      final ProductsState state = ProductsState.initial().copyWith(
        isCreatingProduct: true,
        creationError: const Some('old failure'),
      );

      final ProductsState reducedState = productsReducer(
        state,
        ProductCreatedAction(product),
      );

      expect(state.products, isEmpty, reason: 'no product was created yet');
      expect(reducedState.products, [product], reason: 'product is appended');
      expect(
        reducedState.isCreatingProduct,
        isFalse,
        reason: 'creation completes',
      );
      expect(
        reducedState.creationError,
        isNull,
        reason: 'old creation error is cleared',
      );
      expect(
        reducedState.createdProductId,
        product.id,
        reason: 'created product is exposed',
      );
    });
  });

  group('productsReducer processes ProductCreationFailedAction correctly', () {
    test('ProductCreationFailedAction completes creation with an error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        isCreatingProduct: true,
      );

      final ProductsState reducedState = productsReducer(
        state,
        const ProductCreationFailedAction('failed'),
      );

      expect(state.isCreatingProduct, isTrue, reason: 'creation was active');
      expect(
        reducedState.isCreatingProduct,
        isFalse,
        reason: 'creation completes',
      );
      expect(reducedState.creationError, 'failed', reason: 'failure is stored');
    });
  });

  group('productsReducer processes RefreshProductAction correctly', () {
    test('RefreshProductAction modifies refreshingProductIds', () {
      final ProductsState state = ProductsState.initial().copyWith(
        products: [buildProduct()],
        error: const Some('old failure'),
        productRefreshStatuses: {
          'product-1': PriceFetchStatus.networkError,
          'product-2': PriceFetchStatus.blocked,
        },
      );
      final ProductsState reducedState = productsReducer(
        state,
        const RefreshProductAction('product-1'),
      );

      expect(
        state.refreshingProductIds,
        isEmpty,
        reason: 'no product starts refreshing',
      );
      expect(
        reducedState.refreshingProductIds,
        {'product-1'},
        reason: 'requested product starts refreshing',
      );
      expect(reducedState.error, isNull, reason: 'old error is cleared');
      expect(state.productRefreshStatuses, {
        'product-1': PriceFetchStatus.networkError,
        'product-2': PriceFetchStatus.blocked,
      }, reason: 'both products had a stale status');
      expect(
        reducedState.productRefreshStatuses,
        {'product-2': PriceFetchStatus.blocked},
        reason:
            "the refreshing product's stale status clears, other products' statuses are preserved",
      );
      expect(
        reducedState.products,
        state.products,
        reason: 'products are preserved',
      );
    });
  });

  group('productsReducer processes ProductRefreshedAction correctly', () {
    test('ProductRefreshedAction modifies only the matching product', () {
      final Product first = buildProduct();
      final Product second = buildProduct(id: 'product-2', name: 'Second');
      final Product refreshed = buildProduct(name: 'Updated');
      final ProductsState state = ProductsState.initial().copyWith(
        products: [first, second],
        refreshingProductIds: {'product-1', 'product-2'},
        error: const Some('old failure'),
        productRefreshStatuses: {
          'product-1': PriceFetchStatus.networkError,
          'product-2': PriceFetchStatus.blocked,
        },
      );
      final ProductsState reducedState = productsReducer(
        state,
        ProductRefreshedAction(refreshed),
      );

      expect(
        state.products.first,
        first,
        reason: 'original state is unchanged',
      );
      expect(reducedState.products, [
        refreshed,
        second,
      ], reason: 'matching product is replaced');
      expect(reducedState.refreshingProductIds, {
        'product-2',
      }, reason: 'matching refresh completes');
      expect(reducedState.error, isNull, reason: 'old error is cleared');
      expect(state.productRefreshStatuses, {
        'product-1': PriceFetchStatus.networkError,
        'product-2': PriceFetchStatus.blocked,
      }, reason: 'both products had a stale status');
      expect(
        reducedState.productRefreshStatuses,
        {'product-2': PriceFetchStatus.blocked},
        reason:
            "the refreshed product's stale status clears, the other product's status is preserved",
      );
    });
  });

  group('productsReducer processes ProductRefreshFailedAction correctly', () {
    test('ProductRefreshFailedAction modifies refresh identifiers and error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        refreshingProductIds: {'product-1', 'product-2'},
        productRefreshStatuses: {'product-2': PriceFetchStatus.blocked},
      );
      final ProductsState reducedState = productsReducer(
        state,
        const ProductRefreshFailedAction(
          productId: 'product-1',
          message: 'failed',
          status: PriceFetchStatus.networkError,
        ),
      );

      expect(state.refreshingProductIds, {
        'product-1',
        'product-2',
      }, reason: 'both refreshes were active');
      expect(reducedState.refreshingProductIds, {
        'product-2',
      }, reason: 'failed refresh completes');
      expect(reducedState.error, isA<String>());
      expect(reducedState.error, 'failed', reason: 'failure is stored');
      expect(
        state.productRefreshStatuses,
        {'product-2': PriceFetchStatus.blocked},
        reason: 'only the other product had a stale status',
      );
      expect(
        reducedState.productRefreshStatuses,
        {
          'product-1': PriceFetchStatus.networkError,
          'product-2': PriceFetchStatus.blocked,
        },
        reason:
            "the failed product's status is recorded, the other product's status is untouched",
      );
    });

    test('ProductRefreshFailedAction clears the status when status = null', () {
      final ProductsState state = ProductsState.initial().copyWith(
        productRefreshStatuses: {
          'product-1': PriceFetchStatus.blocked,
          'product-2': PriceFetchStatus.blocked,
        },
      );
      final ProductsState reducedState = productsReducer(
        state,
        const ProductRefreshFailedAction(
          productId: 'product-1',
          message: 'failed',
        ),
      );

      expect(state.productRefreshStatuses, {
        'product-1': PriceFetchStatus.blocked,
        'product-2': PriceFetchStatus.blocked,
      }, reason: 'both products had a stale status');
      expect(
        reducedState.productRefreshStatuses,
        {'product-2': PriceFetchStatus.blocked},
        reason:
            'no classified status means nothing to display for product-1, but product-2 is untouched',
      );
    });
  });

  group('productsReducer processes RefreshAllProductsAction correctly', () {
    test('RefreshAllProductsAction modifies isRefreshingAll', () {
      final ProductsState state = ProductsState.initial().copyWith(
        products: [buildProduct()],
        error: const Some('old failure'),
      );
      final ProductsState reducedState = productsReducer(
        state,
        const RefreshAllProductsAction(),
      );

      expect(state.isRefreshingAll, isA<bool>());
      expect(state.isRefreshingAll, isFalse, reason: 'refresh starts idle');
      expect(reducedState.isRefreshingAll, isA<bool>());
      expect(
        reducedState.isRefreshingAll,
        isTrue,
        reason: 'refresh all starts',
      );
      expect(reducedState.error, isNull, reason: 'old error is cleared');
      expect(
        reducedState.products,
        state.products,
        reason: 'products are preserved',
      );
    });
  });

  group(
    'productsReducer processes RefreshAllProductsFailedAction correctly',
    () {
      test('RefreshAllProductsFailedAction modifies refresh and error', () {
        final ProductsState state = ProductsState.initial().copyWith(
          isRefreshingAll: true,
        );
        final ProductsState reducedState = productsReducer(
          state,
          const RefreshAllProductsFailedAction('failed'),
        );

        expect(state.isRefreshingAll, isTrue, reason: 'refresh was active');
        expect(
          reducedState.isRefreshingAll,
          isFalse,
          reason: 'refresh completes',
        );
        expect(reducedState.error, isA<String>());
        expect(reducedState.error, 'failed', reason: 'failure is stored');
      });
    },
  );

  group('productsReducer processes LoadProductSourcesAction correctly', () {
    test('LoadProductSourcesAction modifies loadingSourcesProductIds', () {
      final ProductsState state = ProductsState.initial();
      final ProductsState reducedState = productsReducer(
        state,
        const LoadProductSourcesAction('product-1'),
      );

      expect(
        state.loadingSourcesProductIds,
        isEmpty,
        reason: 'no product starts loading sources',
      );
      expect(
        reducedState.loadingSourcesProductIds,
        {'product-1'},
        reason: 'requested product starts loading sources',
      );
    });
  });

  group('productsReducer processes ProductSourcesLoadedAction correctly', () {
    test(
      'ProductSourcesLoadedAction modifies sourcesByProduct and loadingSourcesProductIds',
      () {
        final ProductSource source = buildProductSource();
        final ProductSource otherSource = buildProductSource(
          id: 'source-2',
          productId: 'product-2',
        );
        final ProductsState state = ProductsState.initial().copyWith(
          loadingSourcesProductIds: {'product-1', 'product-2'},
          sourcesByProduct: {
            'product-2': [otherSource],
          },
        );
        final ProductsState reducedState = productsReducer(
          state,
          ProductSourcesLoadedAction(productId: 'product-1', sources: [source]),
        );

        expect(
          state.sourcesByProduct,
          {
            'product-2': [otherSource],
          },
          reason: 'only the other product had sources loaded',
        );
        expect(
          reducedState.sourcesByProduct,
          {
            'product-1': [source],
            'product-2': [otherSource],
          },
          reason:
              "the requested product's sources are stored, the other product's are untouched",
        );
        expect(
          reducedState.loadingSourcesProductIds,
          {'product-2'},
          reason: "the requested product's loading completes",
        );
      },
    );
  });

  group('productsReducer processes ProductSourcesLoadFailedAction correctly', () {
    test(
      'ProductSourcesLoadFailedAction modifies loadingSourcesProductIds and error',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          loadingSourcesProductIds: {'product-1', 'product-2'},
        );
        final ProductsState reducedState = productsReducer(
          state,
          const ProductSourcesLoadFailedAction(
            productId: 'product-1',
            message: 'failed',
          ),
        );

        expect(state.loadingSourcesProductIds, {
          'product-1',
          'product-2',
        }, reason: 'both products were loading');
        expect(
          reducedState.loadingSourcesProductIds,
          {'product-2'},
          reason:
              "the failed product's loading completes, the other product's is untouched",
        );
        expect(reducedState.error, isA<String>());
        expect(reducedState.error, 'failed', reason: 'failure is stored');
      },
    );
  });

  group('productsReducer processes unhandled actions correctly', () {
    test('Object modifies nothing', () {
      final ProductsState state = ProductsState.initial();

      final ProductsState reducedState = productsReducer(state, Object());

      expect(reducedState, state);
    });
  });
}
