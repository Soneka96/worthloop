// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.reducer.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import '../../fixtures/product.fixture.dart';

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
    });
  });

  group('productsReducer processes ProductRefreshFailedAction correctly', () {
    test(
      'ProductRefreshFailedAction modifies refresh identifiers and error',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          refreshingProductIds: {'product-1', 'product-2'},
        );
        final ProductsState reducedState = productsReducer(
          state,
          const ProductRefreshFailedAction(
            productId: 'product-1',
            message: 'failed',
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
      },
    );
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

  group('productsReducer processes unhandled actions correctly', () {
    test('Object modifies nothing', () {
      final ProductsState state = ProductsState.initial();

      final ProductsState reducedState = productsReducer(state, Object());

      expect(reducedState, state);
    });
  });
}
