// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

void main() {
  group('ProductsState — initial', () {
    test('ProductsState.initial contains the default values', () {
      final ProductsState state = ProductsState.initial();

      expect(state.products, isEmpty);
      expect(state.isLoading, isA<bool>());
      expect(state.isLoading, isFalse);
      expect(state.isRefreshingAll, isA<bool>());
      expect(state.isRefreshingAll, isFalse);
      expect(state.refreshingProductIds, isEmpty);
      expect(state.error, isNull);
      expect(state.productRefreshStatuses, isEmpty);
      expect(state.isCreatingProduct, isFalse);
      expect(state.creationError, isNull);
      expect(state.createdProductId, isNull);
      expect(state.sourcesByProduct, isEmpty);
      expect(state.loadingSourcesProductIds, isEmpty);
      expect(state.isAddingSource, isFalse);
      expect(state.addSourceError, isNull);
      expect(state.editingSourceId, isNull);
      expect(state.editSourceError, isNull);
      expect(state.deletingSourceIds, isEmpty);
      expect(state.deleteSourceError, isNull);
      expect(state.isRenamingProduct, isFalse);
      expect(state.renameProductError, isNull);
      expect(state.deletingProductIds, isEmpty);
      expect(state.deleteProductError, isNull);
    });
  });

  group('ProductsState — copyWith', () {
    test('ProductsState copyWith replaces every supplied field', () {
      final Product product = buildProduct();
      final ProductSource source = buildProductSource();

      final ProductsState state = ProductsState.initial().copyWith(
        products: [product],
        isLoading: true,
        isRefreshingAll: true,
        refreshingProductIds: {'product-1'},
        error: const Some('failed'),
        productRefreshStatuses: {'product-1': PriceFetchStatus.networkError},
        isCreatingProduct: true,
        creationError: const Some('creation failed'),
        createdProductId: const Some('product-1'),
        sourcesByProduct: {
          'product-1': [source],
        },
        loadingSourcesProductIds: {'product-1'},
        isAddingSource: true,
        addSourceError: const Some('add failed'),
        editingSourceId: const Some('source-1'),
        editSourceError: const Some('edit failed'),
        deletingSourceIds: {'source-1'},
        deleteSourceError: const Some('delete failed'),
        isRenamingProduct: true,
        renameProductError: const Some('rename failed'),
        deletingProductIds: {'product-1'},
        deleteProductError: const Some('product delete failed'),
      );

      expect(state.products, [product]);
      expect(state.isLoading, isA<bool>());
      expect(state.isLoading, isTrue);
      expect(state.isRefreshingAll, isA<bool>());
      expect(state.isRefreshingAll, isTrue);
      expect(state.refreshingProductIds, {'product-1'});
      expect(state.error, isA<String>());
      expect(state.error, 'failed');
      expect(state.productRefreshStatuses, {
        'product-1': PriceFetchStatus.networkError,
      });
      expect(state.isCreatingProduct, isTrue);
      expect(state.creationError, 'creation failed');
      expect(state.createdProductId, 'product-1');
      expect(state.sourcesByProduct, {
        'product-1': [source],
      });
      expect(state.loadingSourcesProductIds, {'product-1'});
      expect(state.isAddingSource, isTrue);
      expect(state.addSourceError, 'add failed');
      expect(state.editingSourceId, 'source-1');
      expect(state.editSourceError, 'edit failed');
      expect(state.deletingSourceIds, {'source-1'});
      expect(state.deleteSourceError, 'delete failed');
      expect(state.isRenamingProduct, isTrue);
      expect(state.renameProductError, 'rename failed');
      expect(state.deletingProductIds, {'product-1'});
      expect(state.deleteProductError, 'product delete failed');
    });

    test('ProductsState copyWith clears error when passed None', () {
      final ProductsState state = ProductsState.initial().copyWith(
        error: const Some('failed'),
      );

      final ProductsState next = state.copyWith(error: const None());

      expect(next.error, isNull);
    });

    test(
      'ProductsState copyWith clears renameProductError and deleteProductError when passed None',
      () {
        final ProductsState state = ProductsState.initial().copyWith(
          renameProductError: const Some('rename failed'),
          deleteProductError: const Some('product delete failed'),
        );

        final ProductsState next = state.copyWith(
          renameProductError: const None(),
          deleteProductError: const None(),
        );

        expect(next.renameProductError, isNull);
        expect(next.deleteProductError, isNull);
      },
    );

    test('ProductsState copyWith preserves fields when omitted', () {
      final ProductsState state = ProductsState.initial().copyWith(
        products: [buildProduct()],
        isLoading: true,
        isRefreshingAll: true,
        refreshingProductIds: {'product-1'},
        error: const Some('failed'),
        productRefreshStatuses: {'product-1': PriceFetchStatus.networkError},
        sourcesByProduct: {
          'product-1': [buildProductSource()],
        },
        loadingSourcesProductIds: {'product-1'},
        isAddingSource: true,
        addSourceError: const Some('add failed'),
        editingSourceId: const Some('source-1'),
        editSourceError: const Some('edit failed'),
        deletingSourceIds: {'source-1'},
        deleteSourceError: const Some('delete failed'),
        isRenamingProduct: true,
        renameProductError: const Some('rename failed'),
        deletingProductIds: {'product-1'},
        deleteProductError: const Some('product delete failed'),
      );

      expect(state.copyWith(), state);
    });
  });
}
