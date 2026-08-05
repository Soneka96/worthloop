// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/product.fixture.dart';

void main() {
  group('Method productsSelector() returns a List<Product> instance', () {
    test('productsSelector() returns the products list', () {
      final Product product = buildProduct();
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(products: [product]),
      );

      expect(ProductsSelectors.productsSelector(state), [product]);
    });
  });

  group('Method productSelector() returns a Product instance', () {
    test('productSelector() returns the matching product', () {
      final Product product = buildProduct();
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(products: [product]),
      );

      expect(ProductsSelectors.productSelector(state, 'product-1'), product);
    });

    test('productSelector() returns null when productId is missing', () {
      expect(
        ProductsSelectors.productSelector(AppState.initial(), 'missing'),
        isNull,
      );
    });
  });

  group('Method isLoadingSelector() returns a bool instance', () {
    test('isLoadingSelector() returns isLoading', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(isLoading: true),
      );

      expect(ProductsSelectors.isLoadingSelector(state), isA<bool>());
      expect(ProductsSelectors.isLoadingSelector(state), isTrue);
    });
  });

  group('Method isRefreshingAllSelector() returns a bool instance', () {
    test('isRefreshingAllSelector() returns isRefreshingAll', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(isRefreshingAll: true),
      );

      expect(ProductsSelectors.isRefreshingAllSelector(state), isA<bool>());
      expect(ProductsSelectors.isRefreshingAllSelector(state), isTrue);
    });
  });

  group('Method isRefreshingProductSelector() returns a bool instance', () {
    test(
      'isRefreshingProductSelector() returns true when id is refreshing',
      () {
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(
            refreshingProductIds: {'product-1'},
          ),
        );

        expect(
          ProductsSelectors.isRefreshingProductSelector(state, 'product-1'),
          isA<bool>(),
        );
        expect(
          ProductsSelectors.isRefreshingProductSelector(state, 'product-1'),
          isTrue,
        );
      },
    );

    test('isRefreshingProductSelector() returns false when id is idle', () {
      expect(
        ProductsSelectors.isRefreshingProductSelector(
          AppState.initial(),
          'product-1',
        ),
        isFalse,
      );
    });
  });

  group(
    'Method refreshStatusForProductSelector() returns a PriceFetchStatus instance',
    () {
      test(
        'refreshStatusForProductSelector() returns the status for the matching product',
        () {
          final AppState state = AppState.initial().copyWith(
            products: ProductsState.initial().copyWith(
              productRefreshStatuses: {
                'product-1': PriceFetchStatus.networkError,
                'product-2': PriceFetchStatus.blocked,
              },
            ),
          );

          expect(
            ProductsSelectors.refreshStatusForProductSelector(
              state,
              'product-1',
            ),
            isA<PriceFetchStatus>(),
          );
          expect(
            ProductsSelectors.refreshStatusForProductSelector(
              state,
              'product-1',
            ),
            PriceFetchStatus.networkError,
          );
        },
      );

      test(
        'refreshStatusForProductSelector() returns null when productId has no status',
        () {
          expect(
            ProductsSelectors.refreshStatusForProductSelector(
              AppState.initial(),
              'product-1',
            ),
            isNull,
          );
        },
      );
    },
  );

  group('Method errorSelector() returns a String instance', () {
    test('errorSelector() returns error', () {
      final AppState state = _productsStateWithError();

      expect(ProductsSelectors.errorSelector(state), isA<String>());
      expect(ProductsSelectors.errorSelector(state), 'failed');
    });

    test('errorSelector() returns null when error == null', () {
      expect(ProductsSelectors.errorSelector(AppState.initial()), isNull);
    });
  });

  group('Product creation selectors return the correct values', () {
    test('isCreatingProductSelector() returns creation state', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(isCreatingProduct: true),
      );

      expect(ProductsSelectors.isCreatingProductSelector(state), isTrue);
    });

    test('productCreationErrorSelector() returns the creation error', () {
      final AppState state = _productsStateWithCreationError();

      expect(
        ProductsSelectors.productCreationErrorSelector(state),
        'creation failed',
      );
    });

    test(
      'createdProductIdSelector() returns the created product identifier',
      () {
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(
            createdProductId: const Some('product-1'),
          ),
        );

        expect(ProductsSelectors.createdProductIdSelector(state), 'product-1');
      },
    );
  });
}

AppState _productsStateWithError() => AppState.initial().copyWith(
  products: ProductsState.initial().copyWith(error: const Some('failed')),
);

AppState _productsStateWithCreationError() => AppState.initial().copyWith(
  products: ProductsState.initial().copyWith(
    creationError: const Some('creation failed'),
  ),
);
