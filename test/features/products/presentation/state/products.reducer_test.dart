// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
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
        sourceRefreshStatuses: {'source-1': SourceRefreshStatus.success},
        refreshCompletedCount: 1,
        refreshTotalCount: 1,
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
        reducedState.sourceRefreshStatuses,
        isEmpty,
        reason: 'stale source statuses clear on a fresh load',
      );
      expect(
        reducedState.refreshCompletedCount,
        0,
        reason: 'source progress resets on a fresh load',
      );
      expect(
        reducedState.refreshTotalCount,
        0,
        reason: 'source total resets on a fresh load',
      );
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

    test(
      'RefreshProductAction modifies nothing when another refresh is active',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          isRefreshingAll: true,
        );

        final ProductsState reducedState = productsReducer(
          state,
          const RefreshProductAction('product-1'),
        );

        expect(reducedState, state);
      },
    );

    test(
      'RefreshProductAction modifies nothing when a product refresh is active',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          refreshingProductIds: {'product-2'},
        );

        final ProductsState reducedState = productsReducer(
          state,
          const RefreshProductAction('product-1'),
        );

        expect(reducedState, state);
      },
    );
  });

  group('productsReducer processes SourceRefreshStartedAction correctly', () {
    test('SourceRefreshStartedAction queues sources in order', () {
      final ProductsState state = ProductsState.initial().copyWith(
        sourceRefreshStatuses: {'old-source': SourceRefreshStatus.success},
        refreshCompletedCount: 4,
        refreshTotalCount: 4,
      );

      final ProductsState reducedState = productsReducer(
        state,
        const SourceRefreshStartedAction(['source-1', 'source-2']),
      );

      expect(
        state.refreshCompletedCount,
        4,
        reason: 'previous progress exists',
      );
      expect(reducedState.sourceRefreshStatuses, {
        'source-1': SourceRefreshStatus.queued,
        'source-2': SourceRefreshStatus.queued,
      }, reason: 'all sources are queued');
      expect(
        reducedState.refreshCompletedCount,
        0,
        reason: 'new refresh starts with no completed sources',
      );
      expect(
        reducedState.refreshTotalCount,
        2,
        reason: 'total matches the new source list',
      );
    });
  });

  group(
    'productsReducer processes SourceRefreshStatusChangedAction correctly',
    () {
      test('SourceRefreshStatusChangedAction records a non-terminal state', () {
        final ProductsState state = ProductsState.initial().copyWith(
          sourceRefreshStatuses: {'source-1': SourceRefreshStatus.queued},
          refreshTotalCount: 2,
        );

        final ProductsState reducedState = productsReducer(
          state,
          const SourceRefreshStatusChangedAction(
            sourceId: 'source-1',
            status: SourceRefreshStatus.fetching,
          ),
        );

        expect(state.refreshCompletedCount, 0, reason: 'no source completed');
        expect(
          reducedState.sourceRefreshStatuses['source-1'],
          SourceRefreshStatus.fetching,
        );
        expect(
          reducedState.refreshCompletedCount,
          0,
          reason: 'fetching is not terminal',
        );
      });

      test('SourceRefreshStatusChangedAction counts a terminal state once', () {
        final ProductsState state = ProductsState.initial().copyWith(
          sourceRefreshStatuses: {'source-1': SourceRefreshStatus.fetching},
          refreshCompletedCount: 1,
          refreshTotalCount: 2,
        );

        final ProductsState reducedState = productsReducer(
          state,
          const SourceRefreshStatusChangedAction(
            sourceId: 'source-1',
            status: SourceRefreshStatus.error,
          ),
        );

        expect(
          state.refreshCompletedCount,
          1,
          reason: 'previous progress exists',
        );
        expect(
          reducedState.refreshCompletedCount,
          2,
          reason: 'the source reached a terminal state',
        );

        final ProductsState repeatedState = productsReducer(
          reducedState,
          const SourceRefreshStatusChangedAction(
            sourceId: 'source-1',
            status: SourceRefreshStatus.error,
          ),
        );
        expect(
          repeatedState.refreshCompletedCount,
          2,
          reason: 'repeated terminal updates are not double-counted',
        );
      });

      test(
        'SourceRefreshStatusChangedAction counts success and unavailable',
        () {
          final ProductsState state = ProductsState.initial().copyWith(
            sourceRefreshStatuses: {
              'source-1': SourceRefreshStatus.fetching,
              'source-2': SourceRefreshStatus.fetching,
            },
          );

          final ProductsState successState = productsReducer(
            state,
            const SourceRefreshStatusChangedAction(
              sourceId: 'source-1',
              status: SourceRefreshStatus.success,
            ),
          );
          final ProductsState unavailableState = productsReducer(
            successState,
            const SourceRefreshStatusChangedAction(
              sourceId: 'source-2',
              status: SourceRefreshStatus.unavailable,
            ),
          );

          expect(
            successState.refreshCompletedCount,
            1,
            reason: 'success is terminal',
          );
          expect(
            unavailableState.refreshCompletedCount,
            2,
            reason: 'unavailable is terminal',
          );
        },
      );

      test('SourceRefreshStatusChangedAction counts a new terminal source', () {
        final ProductsState reducedState = productsReducer(
          ProductsState.initial(),
          const SourceRefreshStatusChangedAction(
            sourceId: 'source-1',
            status: SourceRefreshStatus.success,
          ),
        );

        expect(
          reducedState.refreshCompletedCount,
          1,
          reason: 'a terminal source is counted even without a prior map entry',
        );
      });
    },
  );

  group('productsReducer processes SourceRefreshFinishedAction correctly', () {
    test('SourceRefreshFinishedAction clears progress counters', () {
      final ProductsState state = ProductsState.initial().copyWith(
        sourceRefreshStatuses: {'source-1': SourceRefreshStatus.success},
        refreshCompletedCount: 1,
        refreshTotalCount: 1,
      );

      final ProductsState reducedState = productsReducer(
        state,
        const SourceRefreshFinishedAction(),
      );

      expect(state.refreshTotalCount, 1, reason: 'refresh was active');
      expect(
        reducedState.refreshCompletedCount,
        0,
        reason: 'completed count is cleared',
      );
      expect(
        reducedState.refreshTotalCount,
        0,
        reason: 'total count is cleared',
      );
      expect(
        reducedState.sourceRefreshStatuses,
        {'source-1': SourceRefreshStatus.success},
        reason: 'terminal source statuses are preserved',
      );
    });
  });

  group(
    'productsReducer processes an empty SourceRefreshStartedAction correctly',
    () {
      test('empty SourceRefreshStartedAction starts with zero progress', () {
        final ProductsState reducedState = productsReducer(
          ProductsState.initial(),
          const SourceRefreshStartedAction([]),
        );

        expect(reducedState.sourceRefreshStatuses, isEmpty);
        expect(reducedState.refreshCompletedCount, 0);
        expect(reducedState.refreshTotalCount, 0);
      });
    },
  );

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

    test(
      'RefreshAllProductsAction modifies nothing when a refresh is active',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          refreshingProductIds: {'product-1'},
        );

        final ProductsState reducedState = productsReducer(
          state,
          const RefreshAllProductsAction(),
        );

        expect(reducedState, state);
      },
    );
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
    test(
      'SourceAddedAction replaces only the matching product and completes adding',
      () {
        final Product first = buildProduct();
        final Product second = buildProduct(id: 'product-2', name: 'Second');
        final Product updated = buildProduct(sources: [buildProductSource()]);
        final ProductsState state = ProductsState.initial().copyWith(
          products: [first, second],
          isAddingSource: true,
          addSourceError: const Some('old failure'),
        );

        final ProductsState reducedState = productsReducer(
          state,
          SourceAddedAction(updated),
        );

        expect(
          state.products.first,
          first,
          reason: 'original state is unchanged',
        );
        expect(
          reducedState.products,
          [updated, second],
          reason: 'matching product is replaced, sibling product is untouched',
        );
        expect(state.isAddingSource, isTrue, reason: 'adding was active');
        expect(
          reducedState.isAddingSource,
          isFalse,
          reason: 'adding completes',
        );
        expect(
          reducedState.addSourceError,
          isNull,
          reason: 'old add error is cleared',
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
      'SourceEditedAction replaces only the matching product and completes editing',
      () {
        final Product first = buildProduct();
        final Product second = buildProduct(id: 'product-2', name: 'Second');
        final Product updated = buildProduct(
          sources: [buildProductSource(url: 'https://updated.example.com')],
        );
        final ProductsState state = ProductsState.initial().copyWith(
          products: [first, second],
          editingSourceId: const Some('source-1'),
          editSourceError: const Some('old failure'),
        );

        final ProductsState reducedState = productsReducer(
          state,
          SourceEditedAction(updated),
        );

        expect(
          state.products.first,
          first,
          reason: 'original state is unchanged',
        );
        expect(
          reducedState.products,
          [updated, second],
          reason: 'matching product is replaced, sibling product is untouched',
        );
        expect(state.editingSourceId, 'source-1', reason: 'editing was active');
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
      'SourceDeletedAction replaces only the matching product and completes deleting',
      () {
        final Product first = buildProduct();
        final Product second = buildProduct(id: 'product-2', name: 'Second');
        final Product updated = buildProduct(sources: const []);
        final ProductsState state = ProductsState.initial().copyWith(
          products: [first, second],
          deletingSourceIds: {'source-1', 'source-2'},
        );

        final ProductsState reducedState = productsReducer(
          state,
          SourceDeletedAction(sourceId: 'source-1', product: updated),
        );

        expect(
          state.products.first,
          first,
          reason: 'original state is unchanged',
        );
        expect(
          reducedState.products,
          [updated, second],
          reason: 'matching product is replaced, sibling product is untouched',
        );
        expect(state.deletingSourceIds, {
          'source-1',
          'source-2',
        }, reason: 'both sources were deleting');
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
