// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/data/repositories/products.repository.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product_model.fixture.dart';
import '../../fixtures/store_price_model.fixture.dart';

class MockProductsLocalDatasource extends Mock
    implements ProductsLocalDatasource {}

class MockProductsRemoteDatasource extends Mock
    implements ProductsRemoteDatasource {}

void main() {
  late MockProductsLocalDatasource mockDatasource;
  late MockProductsRemoteDatasource mockRemoteDatasource;
  late ProductsRepository repository;

  setUp(() {
    mockDatasource = MockProductsLocalDatasource();
    mockRemoteDatasource = MockProductsRemoteDatasource();
    repository = ProductsRepository(mockDatasource, mockRemoteDatasource);
  });

  group(
    'ProductsRepository implements the appropriate repository interface',
    () {
      test(
        'ProductsRepository is an implementation of IProductsRepository',
        () {
          expect(repository, isA<IProductsRepository>());
        },
      );
    },
  );

  group('ProductsRepository implements loadProducts() correctly', () {
    test('Method loadProducts() returns the datasource result', () async {
      final List<ProductModel> products = [buildProductModel()];
      when(
        () => mockDatasource.loadProducts(),
      ).thenAnswer((_) async => Right(products));

      final Either<Failure, List<Product>> result = await repository
          .loadProducts();

      expect(result, Right(products));
      verify(() => mockDatasource.loadProducts()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });

  group('ProductsRepository implements createProduct() correctly', () {
    test('Method createProduct() returns the datasource result', () async {
      final ProductModel product = buildProductModel();
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: product.id,
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );
      when(
        () => mockDatasource.createProduct(product, source),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await repository.createProduct(
        product,
        source,
      );

      expect(result, Right(product));
      verify(() => mockDatasource.createProduct(product, source)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test(
      'Method createProduct() forwards datasource failures unchanged',
      () async {
        final ProductModel product = buildProductModel();
        final ProductSource source = ProductSource.fromUrl(
          id: 'source-1',
          productId: product.id,
          url: 'https://example.com/products/1',
          createdAt: DateTime(2026),
        );
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.createProduct(product, source),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.createProduct(
          product,
          source,
        );

        expect(result, const Left(failure));
        verify(() => mockDatasource.createProduct(product, source)).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });

  group('ProductsRepository implements refreshProduct() correctly', () {
    test('refreshes a product source through the remote datasource', () async {
      final ProductModel product = buildProductModel();
      final ProductSourceModel source = ProductSourceModel(
        id: 'source-1',
        productId: product.id,
        url: 'https://example.com/products/1',
        merchantDomain: 'example.com',
        createdAt: DateTime(2026),
      );
      final List<StorePriceModel> offers = [buildStorePriceModel()];
      when(
        () => mockDatasource.loadProductSourcesForProduct(product.id),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(offers));
      when(
        () => mockDatasource.replaceProductPrices(product.id, offers),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await repository.refreshProduct(
        product.id,
      );

      expect(result, Right(product));
      verify(
        () => mockDatasource.loadProductSourcesForProduct(product.id),
      ).called(1);
      verify(() => mockRemoteDatasource.fetchPrices(source)).called(1);
      verify(
        () => mockDatasource.replaceProductPrices(product.id, offers),
      ).called(1);
    });

    test('Method refreshProduct() returns the datasource result', () async {
      final ProductModel product = buildProductModel();
      when(
        () => mockDatasource.refreshProduct('product-1'),
      ).thenAnswer((_) async => Right(product));
      when(
        () => mockDatasource.loadProductSourcesForProduct('product-1'),
      ).thenAnswer((_) async => const Right(<ProductSourceModel>[]));

      final Either<Failure, Product> result = await repository.refreshProduct(
        'product-1',
      );

      expect(result, Right(product));
      verify(
        () => mockDatasource.loadProductSourcesForProduct('product-1'),
      ).called(1);
      verify(() => mockDatasource.refreshProduct('product-1')).called(1);
      verifyNoMoreInteractions(mockDatasource);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('ProductsRepository implements refreshAllProducts() correctly', () {
    test('Method refreshAllProducts() returns the datasource result', () async {
      const DatabaseFailure failure = DatabaseFailure('failed');
      when(
        () => mockDatasource.refreshAllProducts(),
      ).thenAnswer((_) async => const Left(failure));
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => const Right(<ProductSourceModel>[]));

      final Either<Failure, List<Product>> result = await repository
          .refreshAllProducts();

      expect(result, const Left(failure));
      verify(() => mockDatasource.loadProductSources()).called(1);
      verify(() => mockDatasource.refreshAllProducts()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });
}
