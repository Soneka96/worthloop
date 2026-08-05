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
        const CreateProductAction(name: 'Example Product'),
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

  group('productsReducer processes AddSourceAction correctly', () {
    test('AddSourceAction starts adding and clears the error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        addSourceError: const Some('old failure'),
      );

      final ProductsState reducedState = productsReducer(
        state,
        const AddSourceAction(productId: 'product-1', url: 'https://x.com'),
      );

      expect(state.isAddingSource, isA<bool>());
      expect(state.isAddingSource, isFalse, reason: 'adding starts idle');
      expect(reducedState.isAddingSource, isA<bool>());
      expect(reducedState.isAddingSource, isTrue, reason: 'adding starts');
      expect(
        reducedState.addSourceError,
        isNull,
        reason: 'old add error is cleared',
      );
    });
  });

  group('productsReducer processes SourceAddedAction correctly', () {
    test('SourceAddedAction appends the source and completes adding', () {
      final ProductSource existing = buildProductSource(
        id: 'source-1',
        productId: 'product-1',
      );
      final ProductSource added = buildProductSource(
        id: 'source-2',
        productId: 'product-1',
      );
      final ProductSource otherProductSource = buildProductSource(
        id: 'source-3',
        productId: 'product-2',
      );
      final ProductsState state = ProductsState.initial().copyWith(
        isAddingSource: true,
        addSourceError: const Some('old failure'),
        sourcesByProduct: {
          'product-1': [existing],
          'product-2': [otherProductSource],
        },
      );

      final ProductsState reducedState = productsReducer(
        state,
        SourceAddedAction(added),
      );

      expect(
        reducedState.sourcesByProduct,
        {
          'product-1': [existing, added],
          'product-2': [otherProductSource],
        },
        reason:
            "the new source is appended to its product, the other product's sources are untouched",
      );
      expect(reducedState.isAddingSource, isFalse, reason: 'adding completes');
      expect(
        reducedState.addSourceError,
        isNull,
        reason: 'old add error is cleared',
      );
    });

    test(
      'SourceAddedAction creates the entry when the product has no sources yet',
      () {
        final ProductSource added = buildProductSource();
        final ProductsState state = ProductsState.initial().copyWith(
          isAddingSource: true,
        );

        final ProductsState reducedState = productsReducer(
          state,
          SourceAddedAction(added),
        );

        expect(
          state.sourcesByProduct,
          isEmpty,
          reason: 'the product had no sources yet',
        );
        expect(
          reducedState.sourcesByProduct,
          {
            'product-1': [added],
          },
          reason: "the product's first source creates its entry",
        );
      },
    );
  });

  group('productsReducer processes SourceAddFailedAction correctly', () {
    test('SourceAddFailedAction completes adding with an error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        isAddingSource: true,
      );

      final ProductsState reducedState = productsReducer(
        state,
        const SourceAddFailedAction('failed'),
      );

      expect(state.isAddingSource, isA<bool>());
      expect(state.isAddingSource, isTrue, reason: 'adding was active');
      expect(reducedState.isAddingSource, isA<bool>());
      expect(reducedState.isAddingSource, isFalse, reason: 'adding completes');
      expect(reducedState.addSourceError, isA<String>());
      expect(
        reducedState.addSourceError,
        'failed',
        reason: 'failure is stored',
      );
    });
  });

  group('productsReducer processes EditSourceAction correctly', () {
    test('EditSourceAction starts editing and clears the error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        editSourceError: const Some('old failure'),
      );

      final ProductsState reducedState = productsReducer(
        state,
        const EditSourceAction(sourceId: 'source-1', url: 'https://x.com'),
      );

      expect(state.editingSourceId, isNull, reason: 'editing starts idle');
      expect(reducedState.editingSourceId, isA<String>());
      expect(
        reducedState.editingSourceId,
        'source-1',
        reason: 'requested source starts editing',
      );
      expect(
        reducedState.editSourceError,
        isNull,
        reason: 'old edit error is cleared',
      );
    });
  });

  group('productsReducer processes SourceEditedAction correctly', () {
    test(
      'SourceEditedAction replaces only the matching source and completes editing',
      () {
        final ProductSource original = buildProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://original.example.com',
        );
        final ProductSource sibling = buildProductSource(
          id: 'source-2',
          productId: 'product-1',
        );
        final ProductSource edited = buildProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://updated.example.com',
        );
        final ProductsState state = ProductsState.initial().copyWith(
          editingSourceId: const Some('source-1'),
          editSourceError: const Some('old failure'),
          sourcesByProduct: {
            'product-1': [original, sibling],
          },
        );

        final ProductsState reducedState = productsReducer(
          state,
          SourceEditedAction(edited),
        );

        expect(
          reducedState.sourcesByProduct,
          {
            'product-1': [edited, sibling],
          },
          reason: 'matching source is replaced, sibling source is untouched',
        );
        expect(
          reducedState.editingSourceId,
          isNull,
          reason: 'editing completes',
        );
        expect(
          reducedState.editSourceError,
          isNull,
          reason: 'old edit error is cleared',
        );
      },
    );
  });

  group('productsReducer processes SourceEditFailedAction correctly', () {
    test('SourceEditFailedAction completes editing with an error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        editingSourceId: const Some('source-1'),
      );

      final ProductsState reducedState = productsReducer(
        state,
        const SourceEditFailedAction('failed'),
      );

      expect(state.editingSourceId, isA<String>());
      expect(state.editingSourceId, 'source-1', reason: 'editing was active');
      expect(reducedState.editingSourceId, isNull, reason: 'editing completes');
      expect(reducedState.editSourceError, isA<String>());
      expect(
        reducedState.editSourceError,
        'failed',
        reason: 'failure is stored',
      );
    });
  });

  group('productsReducer processes DeleteSourceAction correctly', () {
    test(
      'DeleteSourceAction modifies deletingSourceIds and clears the error',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          deleteSourceError: const Some('old failure'),
        );

        final ProductsState reducedState = productsReducer(
          state,
          const DeleteSourceAction(
            productId: 'product-1',
            sourceId: 'source-1',
          ),
        );

        expect(
          state.deletingSourceIds,
          isEmpty,
          reason: 'no source starts deleting',
        );
        expect(
          reducedState.deletingSourceIds,
          {'source-1'},
          reason: 'requested source starts deleting',
        );
        expect(
          reducedState.deleteSourceError,
          isNull,
          reason: 'old delete error is cleared',
        );
      },
    );
  });

  group('productsReducer processes SourceDeletedAction correctly', () {
    test(
      'SourceDeletedAction removes only the matching source and completes deleting',
      () {
        final ProductSource deleted = buildProductSource(
          id: 'source-1',
          productId: 'product-1',
        );
        final ProductSource sibling = buildProductSource(
          id: 'source-2',
          productId: 'product-1',
        );
        final ProductsState state = ProductsState.initial().copyWith(
          deletingSourceIds: {'source-1', 'source-2'},
          sourcesByProduct: {
            'product-1': [deleted, sibling],
          },
        );

        final ProductsState reducedState = productsReducer(
          state,
          const SourceDeletedAction(
            productId: 'product-1',
            sourceId: 'source-1',
          ),
        );

        expect(
          reducedState.sourcesByProduct,
          {
            'product-1': [sibling],
          },
          reason: 'matching source is removed, sibling source is untouched',
        );
        expect(
          reducedState.deletingSourceIds,
          {'source-2'},
          reason:
              "the deleted source's delete completes, the other source's is untouched",
        );
      },
    );
  });

  group('productsReducer processes SourceDeleteFailedAction correctly', () {
    test('SourceDeleteFailedAction completes deleting with an error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        deletingSourceIds: {'source-1', 'source-2'},
      );

      final ProductsState reducedState = productsReducer(
        state,
        const SourceDeleteFailedAction(sourceId: 'source-1', message: 'failed'),
      );

      expect(state.deletingSourceIds, {
        'source-1',
        'source-2',
      }, reason: 'both sources were deleting');
      expect(
        reducedState.deletingSourceIds,
        {'source-2'},
        reason:
            "the failed source's delete completes, the other source's is untouched",
      );
      expect(reducedState.deleteSourceError, isA<String>());
      expect(
        reducedState.deleteSourceError,
        'failed',
        reason: 'failure is stored',
      );
    });
  });

  group('productsReducer processes RenameProductAction correctly', () {
    test('RenameProductAction starts renaming and clears the error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        renameProductError: const Some('old failure'),
      );

      final ProductsState reducedState = productsReducer(
        state,
        const RenameProductAction(
          productId: 'product-1',
          name: 'Renamed Product',
        ),
      );

      expect(state.isRenamingProduct, isA<bool>());
      expect(state.isRenamingProduct, isFalse, reason: 'renaming starts idle');
      expect(reducedState.isRenamingProduct, isA<bool>());
      expect(reducedState.isRenamingProduct, isTrue, reason: 'renaming starts');
      expect(
        reducedState.renameProductError,
        isNull,
        reason: 'old rename error is cleared',
      );
    });
  });

  group('productsReducer processes ProductRenamedAction correctly', () {
    test(
      'ProductRenamedAction modifies only the matching product and completes renaming',
      () {
        final Product first = buildProduct();
        final Product second = buildProduct(id: 'product-2', name: 'Second');
        final Product renamed = buildProduct(name: 'Renamed Product');
        final ProductsState state = ProductsState.initial().copyWith(
          products: [first, second],
          isRenamingProduct: true,
          renameProductError: const Some('old failure'),
        );

        final ProductsState reducedState = productsReducer(
          state,
          ProductRenamedAction(renamed),
        );

        expect(
          state.products.first,
          first,
          reason: 'original state is unchanged',
        );
        expect(
          reducedState.products,
          [renamed, second],
          reason: 'matching product is replaced, other product is untouched',
        );
        expect(state.isRenamingProduct, isTrue, reason: 'renaming was active');
        expect(
          reducedState.isRenamingProduct,
          isFalse,
          reason: 'renaming completes',
        );
        expect(
          reducedState.renameProductError,
          isNull,
          reason: 'old rename error is cleared',
        );
      },
    );
  });

  group('productsReducer processes ProductRenameFailedAction correctly', () {
    test('ProductRenameFailedAction completes renaming with an error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        isRenamingProduct: true,
      );

      final ProductsState reducedState = productsReducer(
        state,
        const ProductRenameFailedAction('failed'),
      );

      expect(state.isRenamingProduct, isA<bool>());
      expect(state.isRenamingProduct, isTrue, reason: 'renaming was active');
      expect(reducedState.isRenamingProduct, isA<bool>());
      expect(
        reducedState.isRenamingProduct,
        isFalse,
        reason: 'renaming completes',
      );
      expect(reducedState.renameProductError, isA<String>());
      expect(
        reducedState.renameProductError,
        'failed',
        reason: 'failure is stored',
      );
    });
  });

  group('productsReducer processes DeleteProductAction correctly', () {
    test(
      'DeleteProductAction modifies deletingProductIds and clears the error',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          deleteProductError: const Some('old failure'),
        );

        final ProductsState reducedState = productsReducer(
          state,
          const DeleteProductAction('product-1'),
        );

        expect(
          state.deletingProductIds,
          isEmpty,
          reason: 'no product starts deleting',
        );
        expect(
          reducedState.deletingProductIds,
          {'product-1'},
          reason: 'requested product starts deleting',
        );
        expect(
          reducedState.deleteProductError,
          isNull,
          reason: 'old delete error is cleared',
        );
      },
    );
  });

  group('productsReducer processes ProductDeletedAction correctly', () {
    test(
      'ProductDeletedAction removes only the matching product and completes deleting',
      () {
        final Product deleted = buildProduct();
        final Product sibling = buildProduct(id: 'product-2', name: 'Second');
        final ProductsState state = ProductsState.initial().copyWith(
          products: [deleted, sibling],
          deletingProductIds: {'product-1', 'product-2'},
        );

        final ProductsState reducedState = productsReducer(
          state,
          const ProductDeletedAction('product-1'),
        );

        expect(state.products, [
          deleted,
          sibling,
        ], reason: 'both products were present before the delete');
        expect(
          reducedState.products,
          [sibling],
          reason: 'matching product is removed, sibling product is untouched',
        );
        expect(state.deletingProductIds, {
          'product-1',
          'product-2',
        }, reason: 'both products were deleting');
        expect(
          reducedState.deletingProductIds,
          {'product-2'},
          reason:
              "the deleted product's delete completes, the other product's is untouched",
        );
      },
    );
  });

  group('productsReducer processes ProductDeleteFailedAction correctly', () {
    test('ProductDeleteFailedAction completes deleting with an error', () {
      final ProductsState state = ProductsState.initial().copyWith(
        deletingProductIds: {'product-1', 'product-2'},
      );

      final ProductsState reducedState = productsReducer(
        state,
        const ProductDeleteFailedAction(
          productId: 'product-1',
          message: 'failed',
        ),
      );

      expect(state.deletingProductIds, {
        'product-1',
        'product-2',
      }, reason: 'both products were deleting');
      expect(
        reducedState.deletingProductIds,
        {'product-2'},
        reason:
            "the failed product's delete completes, the other product's is untouched",
      );
      expect(reducedState.deleteProductError, isA<String>());
      expect(
        reducedState.deleteProductError,
        'failed',
        reason: 'failure is stored',
      );
    });
  });

  group('productsReducer processes unhandled actions correctly', () {
    test('Object modifies nothing', () {
      final ProductsState state = ProductsState.initial();

      final ProductsState reducedState = productsReducer(state, Object());

      expect(reducedState, state);
    });
  });
}
