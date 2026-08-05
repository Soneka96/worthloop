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
    });

    test('ProductsState copyWith clears error when passed None', () {
      final ProductsState state = ProductsState.initial().copyWith(
        error: const Some('failed'),
      );

      final ProductsState next = state.copyWith(error: const None());

      expect(next.error, isNull);
    });

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
      );

      expect(state.copyWith(), state);
    });
  });
}
