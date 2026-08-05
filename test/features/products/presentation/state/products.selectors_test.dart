// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

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

  group(
    'Method sourcesForProductSelector() returns a List<ProductSource> instance',
    () {
      test('sourcesForProductSelector() returns the matching sources', () {
        final ProductSource source = buildProductSource();
        final ProductSource otherSource = buildProductSource(
          id: 'source-2',
          productId: 'product-2',
        );
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(
            sourcesByProduct: {
              'product-1': [source],
              'product-2': [otherSource],
            },
          ),
        );

        expect(
          ProductsSelectors.sourcesForProductSelector(state, 'product-1'),
          [source],
        );
      });

      test(
        'sourcesForProductSelector() returns an empty list when productId has no sources',
        () {
          expect(
            ProductsSelectors.sourcesForProductSelector(
              AppState.initial(),
              'product-1',
            ),
            isEmpty,
          );
        },
      );
    },
  );

  group('Method isLoadingSourcesSelector() returns a bool instance', () {
    test(
      'isLoadingSourcesSelector() returns true when productId is loading',
      () {
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(
            loadingSourcesProductIds: {'product-1', 'product-2'},
          ),
        );

        expect(
          ProductsSelectors.isLoadingSourcesSelector(state, 'product-1'),
          isA<bool>(),
        );
        expect(
          ProductsSelectors.isLoadingSourcesSelector(state, 'product-1'),
          isTrue,
        );
      },
    );

    test('isLoadingSourcesSelector() returns false when productId is idle', () {
      expect(
        ProductsSelectors.isLoadingSourcesSelector(
          AppState.initial(),
          'product-1',
        ),
        isFalse,
      );
    });
  });

  group('Method isAddingSourceSelector() returns a bool instance', () {
    test('isAddingSourceSelector() returns isAddingSource', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(isAddingSource: true),
      );

      expect(ProductsSelectors.isAddingSourceSelector(state), isA<bool>());
      expect(ProductsSelectors.isAddingSourceSelector(state), isTrue);
    });

    test(
      'isAddingSourceSelector() returns false when isAddingSource == false',
      () {
        expect(
          ProductsSelectors.isAddingSourceSelector(AppState.initial()),
          isFalse,
        );
      },
    );
  });

  group('Method addSourceErrorSelector() returns a String instance', () {
    test('addSourceErrorSelector() returns addSourceError', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          addSourceError: const Some('add failed'),
        ),
      );

      expect(ProductsSelectors.addSourceErrorSelector(state), isA<String>());
      expect(ProductsSelectors.addSourceErrorSelector(state), 'add failed');
    });

    test(
      'addSourceErrorSelector() returns null when addSourceError == null',
      () {
        expect(
          ProductsSelectors.addSourceErrorSelector(AppState.initial()),
          isNull,
        );
      },
    );
  });

  group('Method editingSourceIdSelector() returns a String instance', () {
    test('editingSourceIdSelector() returns editingSourceId', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          editingSourceId: const Some('source-1'),
        ),
      );

      expect(ProductsSelectors.editingSourceIdSelector(state), isA<String>());
      expect(ProductsSelectors.editingSourceIdSelector(state), 'source-1');
    });

    test(
      'editingSourceIdSelector() returns null when editingSourceId == null',
      () {
        expect(
          ProductsSelectors.editingSourceIdSelector(AppState.initial()),
          isNull,
        );
      },
    );
  });

  group('Method editSourceErrorSelector() returns a String instance', () {
    test('editSourceErrorSelector() returns editSourceError', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          editSourceError: const Some('edit failed'),
        ),
      );

      expect(ProductsSelectors.editSourceErrorSelector(state), isA<String>());
      expect(ProductsSelectors.editSourceErrorSelector(state), 'edit failed');
    });

    test(
      'editSourceErrorSelector() returns null when editSourceError == null',
      () {
        expect(
          ProductsSelectors.editSourceErrorSelector(AppState.initial()),
          isNull,
        );
      },
    );
  });

  group('Method deletingSourceIdsSelector() returns a Set<String> instance', () {
    test('deletingSourceIdsSelector() returns deletingSourceIds', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          deletingSourceIds: {'source-1'},
        ),
      );

      expect(ProductsSelectors.deletingSourceIdsSelector(state), {'source-1'});
    });

    test(
      'deletingSourceIdsSelector() returns an empty set when nothing is deleting',
      () {
        expect(
          ProductsSelectors.deletingSourceIdsSelector(AppState.initial()),
          isEmpty,
        );
      },
    );
  });

  group('Method deleteSourceErrorSelector() returns a String instance', () {
    test('deleteSourceErrorSelector() returns deleteSourceError', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          deleteSourceError: const Some('delete failed'),
        ),
      );

      expect(ProductsSelectors.deleteSourceErrorSelector(state), isA<String>());
      expect(
        ProductsSelectors.deleteSourceErrorSelector(state),
        'delete failed',
      );
    });

    test(
      'deleteSourceErrorSelector() returns null when deleteSourceError == null',
      () {
        expect(
          ProductsSelectors.deleteSourceErrorSelector(AppState.initial()),
          isNull,
        );
      },
    );
  });

  group('Method isRenamingProductSelector() returns a bool instance', () {
    test('isRenamingProductSelector() returns isRenamingProduct', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(isRenamingProduct: true),
      );

      expect(ProductsSelectors.isRenamingProductSelector(state), isA<bool>());
      expect(ProductsSelectors.isRenamingProductSelector(state), isTrue);
    });

    test(
      'isRenamingProductSelector() returns false when isRenamingProduct == false',
      () {
        expect(
          ProductsSelectors.isRenamingProductSelector(AppState.initial()),
          isFalse,
        );
      },
    );
  });

  group('Method renameProductErrorSelector() returns a String instance', () {
    test('renameProductErrorSelector() returns renameProductError', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          renameProductError: const Some('rename failed'),
        ),
      );

      expect(
        ProductsSelectors.renameProductErrorSelector(state),
        isA<String>(),
      );
      expect(
        ProductsSelectors.renameProductErrorSelector(state),
        'rename failed',
      );
    });

    test(
      'renameProductErrorSelector() returns null when renameProductError == null',
      () {
        expect(
          ProductsSelectors.renameProductErrorSelector(AppState.initial()),
          isNull,
        );
      },
    );
  });

  group('Method isDeletingProductSelector() returns a bool instance', () {
    test('isDeletingProductSelector() returns true when id is deleting', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          deletingProductIds: {'product-1', 'product-2'},
        ),
      );

      expect(
        ProductsSelectors.isDeletingProductSelector(state, 'product-1'),
        isA<bool>(),
      );
      expect(
        ProductsSelectors.isDeletingProductSelector(state, 'product-1'),
        isTrue,
      );
    });

    test('isDeletingProductSelector() returns false when id is idle', () {
      expect(
        ProductsSelectors.isDeletingProductSelector(
          AppState.initial(),
          'product-1',
        ),
        isFalse,
      );
    });
  });

  group('Method deleteProductErrorSelector() returns a String instance', () {
    test('deleteProductErrorSelector() returns deleteProductError', () {
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          deleteProductError: const Some('product delete failed'),
        ),
      );

      expect(
        ProductsSelectors.deleteProductErrorSelector(state),
        isA<String>(),
      );
      expect(
        ProductsSelectors.deleteProductErrorSelector(state),
        'product delete failed',
      );
    });

    test(
      'deleteProductErrorSelector() returns null when deleteProductError == null',
      () {
        expect(
          ProductsSelectors.deleteProductErrorSelector(AppState.initial()),
          isNull,
        );
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
