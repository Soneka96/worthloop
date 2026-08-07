// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/data/repositories/products.repository.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import '../../fixtures/product_model.fixture.dart';
import '../../fixtures/product_source.fixture.dart';
import '../../fixtures/product_source_model.fixture.dart';

class MockProductsLocalDatasource extends Mock
    implements ProductsLocalDatasource {}

class MockIProductsRemoteDatasource extends Mock
    implements IProductsRemoteDatasource {}

void main() {
  late MockProductsLocalDatasource mockDatasource;
  late MockIProductsRemoteDatasource mockRemoteDatasource;
  late ProductsRepository repository;

  setUpAll(() {
    registerFallbackValue(
      ProductSource(
        id: 'fallback',
        productId: 'fallback',
        url: 'https://example.com',
        merchantDomain: 'example.com',
        createdAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    mockDatasource = MockProductsLocalDatasource();
    mockRemoteDatasource = MockIProductsRemoteDatasource();
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

    test(
      'Method loadProducts() forwards datasource failures unchanged',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.loadProducts(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<Product>> result = await repository
            .loadProducts();

        expect(result, const Left(failure));
        verify(() => mockDatasource.loadProducts()).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
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

    test(
      'Method createProduct() calls ProductsLocalDatasource.createProduct() when source == null',
      () async {
        final ProductModel product = buildProductModel();
        when(
          () => mockDatasource.createProduct(product, null),
        ).thenAnswer((_) async => Right(product));

        final Either<Failure, Product> result = await repository.createProduct(
          product,
          null,
        );

        expect(result, Right(product));
        verify(() => mockDatasource.createProduct(product, null)).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });

  group('ProductsRepository implements addSource() correctly', () {
    test(
      'fetches an offer, then calls ProductsLocalDatasource.addSourceWithPrice()',
      () async {
        final ProductSource source = buildProductSource();
        final ProductSourceModel pricedSource = buildProductSourceModel(
          currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
          isAvailable: true,
          lastCheckedAt: DateTime(2026, 1, 1, 12),
        );
        final ProductModel product = buildProductModel(sources: [pricedSource]);
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(pricedSource));
        when(
          () => mockDatasource.addSourceWithPrice(pricedSource),
        ).thenAnswer((_) async => Right(product));

        final Either<Failure, Product> result = await repository.addSource(
          source,
        );

        expect(result, Right(product));
        verify(() => mockRemoteDatasource.fetchPrices(source)).called(1);
        verify(() => mockDatasource.addSourceWithPrice(pricedSource)).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'returns the fetch failure without calling ProductsLocalDatasource.addSourceWithPrice()',
      () async {
        final ProductSource source = buildProductSource();
        const PriceFetchFailure failure = PriceFetchFailure(
          status: PriceFetchStatus.blocked,
          message: 'Website blocked the price request',
        );
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.addSource(
          source,
        );

        expect(result, const Left(failure));
        verify(() => mockRemoteDatasource.fetchPrices(source)).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
        verifyZeroInteractions(mockDatasource);
      },
    );

    test(
      'forwards ProductsLocalDatasource.addSourceWithPrice() failures unchanged',
      () async {
        final ProductSource source = buildProductSource();
        final ProductSourceModel pricedSource = buildProductSourceModel();
        const ValidationFailure failure = ValidationFailure(
          'This store is already tracked for this product',
        );
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(pricedSource));
        when(
          () => mockDatasource.addSourceWithPrice(pricedSource),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.addSource(
          source,
        );

        expect(result, const Left(failure));
        verify(() => mockRemoteDatasource.fetchPrices(source)).called(1);
        verify(() => mockDatasource.addSourceWithPrice(pricedSource)).called(1);
      },
    );
  });

  group('ProductsRepository implements updateSource() correctly', () {
    test(
      'fetches an offer for the given URL, then calls ProductsLocalDatasource.editSourceWithPrice()',
      () async {
        final ProductSourceModel pricedSource = buildProductSourceModel(
          url: 'https://example.com/updated',
          currentPrice: const Money(minorUnits: 29999, currencyCode: 'EUR'),
          isAvailable: true,
          lastCheckedAt: DateTime(2026, 1, 1, 12),
        );
        final ProductModel product = buildProductModel(sources: [pricedSource]);
        when(
          () => mockRemoteDatasource.fetchPrices(
            any(
              that: _isCandidateFor('source-1', 'https://example.com/updated'),
            ),
          ),
        ).thenAnswer((_) async => Right(pricedSource));
        when(
          () => mockDatasource.editSourceWithPrice('source-1', pricedSource),
        ).thenAnswer((_) async => Right(product));

        final Either<Failure, Product> result = await repository.updateSource(
          'source-1',
          'https://example.com/updated',
        );

        expect(result, Right(product));
        verify(
          () => mockDatasource.editSourceWithPrice('source-1', pricedSource),
        ).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'returns the fetch failure without calling ProductsLocalDatasource.editSourceWithPrice()',
      () async {
        const NetworkFailure failure = NetworkFailure(
          'Unable to fetch the product price',
        );
        when(
          () => mockRemoteDatasource.fetchPrices(
            any(
              that: _isCandidateFor('source-1', 'https://example.com/updated'),
            ),
          ),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.updateSource(
          'source-1',
          'https://example.com/updated',
        );

        expect(result, const Left(failure));
        verifyZeroInteractions(mockDatasource);
      },
    );

    test(
      'forwards ProductsLocalDatasource.editSourceWithPrice() failures unchanged',
      () async {
        final ProductSourceModel pricedSource = buildProductSourceModel(
          url: 'https://example.com/updated',
        );
        const NotFoundFailure failure = NotFoundFailure('Source not found');
        when(
          () => mockRemoteDatasource.fetchPrices(
            any(
              that: _isCandidateFor('source-1', 'https://example.com/updated'),
            ),
          ),
        ).thenAnswer((_) async => Right(pricedSource));
        when(
          () => mockDatasource.editSourceWithPrice('source-1', pricedSource),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.updateSource(
          'source-1',
          'https://example.com/updated',
        );

        expect(result, const Left(failure));
        verify(
          () => mockDatasource.editSourceWithPrice('source-1', pricedSource),
        ).called(1);
      },
    );
  });

  group('ProductsRepository implements deleteSource() correctly', () {
    test('Method deleteSource() returns the datasource result', () async {
      final ProductModel product = buildProductModel();
      when(
        () => mockDatasource.deleteSource('source-1'),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await repository.deleteSource(
        'source-1',
      );

      expect(result, Right(product));
      verify(() => mockDatasource.deleteSource('source-1')).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test(
      'Method deleteSource() forwards datasource failures unchanged',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Source not found');
        when(
          () => mockDatasource.deleteSource('source-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.deleteSource(
          'source-1',
        );

        expect(result, const Left(failure));
        verify(() => mockDatasource.deleteSource('source-1')).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });

  group('ProductsRepository implements renameProduct() correctly', () {
    test('Method renameProduct() returns the datasource result', () async {
      final ProductModel product = buildProductModel(name: 'Renamed Product');
      when(
        () => mockDatasource.renameProduct('product-1', 'Renamed Product'),
      ).thenAnswer((_) async => Right(product));

      final Either<Failure, Product> result = await repository.renameProduct(
        'product-1',
        'Renamed Product',
      );

      expect(result, Right(product));
      verify(
        () => mockDatasource.renameProduct('product-1', 'Renamed Product'),
      ).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test(
      'Method renameProduct() forwards datasource failures unchanged',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Product not found');
        when(
          () => mockDatasource.renameProduct('product-1', 'Renamed Product'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.renameProduct(
          'product-1',
          'Renamed Product',
        );

        expect(result, const Left(failure));
        verify(
          () => mockDatasource.renameProduct('product-1', 'Renamed Product'),
        ).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });

  group('ProductsRepository implements deleteProduct() correctly', () {
    test('Method deleteProduct() returns the datasource result', () async {
      when(
        () => mockDatasource.deleteProduct('product-1'),
      ).thenAnswer((_) async => const Right(unit));

      final Either<Failure, Unit> result = await repository.deleteProduct(
        'product-1',
      );

      expect(result, const Right(unit));
      verify(() => mockDatasource.deleteProduct('product-1')).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test(
      'Method deleteProduct() forwards datasource failures unchanged',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.deleteProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await repository.deleteProduct(
          'product-1',
        );

        expect(result, const Left(failure));
        verify(() => mockDatasource.deleteProduct('product-1')).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });

  group('ProductsRepository implements refreshProduct() correctly', () {
    test('refreshes a product source through the remote datasource', () async {
      final ProductModel product = buildProductModel();
      final ProductSourceModel source = buildProductSourceModel();
      final ProductSourceModel updatedSource = buildProductSourceModel(
        currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
        isAvailable: true,
        lastCheckedAt: DateTime(2026, 1, 2),
      );
      when(
        () => mockDatasource.loadProductSourcesForProduct(product.id),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(updatedSource));
      when(
        () => mockDatasource.updateSourcePrices(product.id, [updatedSource]),
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
        () => mockDatasource.updateSourcePrices(product.id, [updatedSource]),
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

    test(
      'returns the fetch failure without calling updateSourcePrices()',
      () async {
        final ProductSourceModel source = buildProductSourceModel();
        const PriceFetchFailure failure = PriceFetchFailure(
          status: PriceFetchStatus.blocked,
          message: 'Website blocked the price request',
        );
        when(
          () => mockDatasource.loadProductSourcesForProduct('product-1'),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.refreshProduct(
          'product-1',
        );

        expect(result, const Left(failure));
        verifyNever(() => mockDatasource.updateSourcePrices(any(), any()));
      },
    );

    test(
      'fetches every source and accumulates their offers before calling updateSourcePrices()',
      () async {
        final ProductModel product = buildProductModel();
        final ProductSourceModel firstSource = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel secondSource = buildProductSourceModel(
          id: 'source-2',
          url: 'https://other.com/products/1',
        );
        final ProductSourceModel firstUpdated = buildProductSourceModel(
          id: 'source-1',
          currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
          isAvailable: true,
        );
        final ProductSourceModel secondUpdated = buildProductSourceModel(
          id: 'source-2',
          url: 'https://other.com/products/1',
          currentPrice: const Money(minorUnits: 2999, currencyCode: 'USD'),
          isAvailable: false,
        );
        when(
          () => mockDatasource.loadProductSourcesForProduct(product.id),
        ).thenAnswer((_) async => Right([firstSource, secondSource]));
        when(
          () => mockRemoteDatasource.fetchPrices(firstSource),
        ).thenAnswer((_) async => Right(firstUpdated));
        when(
          () => mockRemoteDatasource.fetchPrices(secondSource),
        ).thenAnswer((_) async => Right(secondUpdated));
        when(
          () => mockDatasource.updateSourcePrices(product.id, [
            firstUpdated,
            secondUpdated,
          ]),
        ).thenAnswer((_) async => Right(product));

        final List<String> lifecycle = [];
        final Either<Failure, Product> result = await repository.refreshProduct(
          product.id,
          onSourceStatusChanged: (String sourceId, SourceRefreshStatus status) {
            lifecycle.add('$sourceId:$status');
          },
        );

        expect(result, Right(product));
        verify(() => mockRemoteDatasource.fetchPrices(firstSource)).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(secondSource)).called(1);
        verify(
          () => mockDatasource.updateSourcePrices(product.id, [
            firstUpdated,
            secondUpdated,
          ]),
        ).called(1);
        expect(lifecycle, [
          'source-1:SourceRefreshStatus.fetching',
          'source-1:SourceRefreshStatus.success',
          'source-2:SourceRefreshStatus.fetching',
          'source-2:SourceRefreshStatus.unavailable',
        ]);
      },
    );

    test(
      'continues refreshing later sources after an earlier fetch failure',
      () async {
        final ProductSourceModel firstSource = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel secondSource = buildProductSourceModel(
          id: 'source-2',
          url: 'https://other.com/products/1',
        );
        const PriceFetchFailure failure = PriceFetchFailure(
          status: PriceFetchStatus.blocked,
          message: 'blocked',
        );
        final ProductSourceModel secondUpdated = buildProductSourceModel(
          id: 'source-2',
          url: 'https://other.com/products/1',
          isAvailable: true,
        );
        when(
          () => mockDatasource.loadProductSourcesForProduct('product-1'),
        ).thenAnswer((_) async => Right([firstSource, secondSource]));
        when(
          () => mockRemoteDatasource.fetchPrices(firstSource),
        ).thenAnswer((_) async => const Left(failure));
        when(
          () => mockRemoteDatasource.fetchPrices(secondSource),
        ).thenAnswer((_) async => Right(secondUpdated));

        final List<SourceRefreshStatus> statuses = [];
        final Either<Failure, Product> result = await repository.refreshProduct(
          'product-1',
          onSourceStatusChanged: (String sourceId, SourceRefreshStatus status) {
            statuses.add(status);
          },
        );

        expect(result, const Left(failure));
        expect(statuses, [
          SourceRefreshStatus.fetching,
          SourceRefreshStatus.error,
          SourceRefreshStatus.fetching,
          SourceRefreshStatus.success,
        ]);
        verify(() => mockRemoteDatasource.fetchPrices(secondSource)).called(1);
        verifyNever(() => mockDatasource.updateSourcePrices(any(), any()));
      },
    );

    test(
      'returns the datasource failure when loadProductSourcesForProduct() fails',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.loadProductSourcesForProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.refreshProduct(
          'product-1',
        );

        expect(result, const Left(failure));
        verifyZeroInteractions(mockRemoteDatasource);
      },
    );

    test('forwards updateSourcePrices() failures unchanged', () async {
      final ProductSourceModel source = buildProductSourceModel();
      final ProductSourceModel updatedSource = buildProductSourceModel(
        currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
      );
      const DatabaseFailure failure = DatabaseFailure('database failed');
      when(
        () => mockDatasource.loadProductSourcesForProduct('product-1'),
      ).thenAnswer((_) async => Right([source]));
      when(
        () => mockRemoteDatasource.fetchPrices(source),
      ).thenAnswer((_) async => Right(updatedSource));
      when(
        () => mockDatasource.updateSourcePrices('product-1', [updatedSource]),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Product> result = await repository.refreshProduct(
        'product-1',
      );

      expect(result, const Left(failure));
    });

    test(
      'forwards ProductsLocalDatasource.refreshProduct() failures unchanged when there are no sources',
      () async {
        const NotFoundFailure failure = NotFoundFailure('Product not found');
        when(
          () => mockDatasource.loadProductSourcesForProduct('product-1'),
        ).thenAnswer((_) async => const Right(<ProductSourceModel>[]));
        when(
          () => mockDatasource.refreshProduct('product-1'),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Product> result = await repository.refreshProduct(
          'product-1',
        );

        expect(result, const Left(failure));
      },
    );
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

    test(
      'returns the datasource failure when loadProductSources() fails',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<Product>> result = await repository
            .refreshAllProducts();

        expect(result, const Left(failure));
        verifyZeroInteractions(mockRemoteDatasource);
        verifyNever(() => mockDatasource.refreshAllProducts());
      },
    );

    test(
      'stops without calling ProductsLocalDatasource.refreshAllProducts() when updateSourcePrices() fails',
      () async {
        final ProductSourceModel source = buildProductSourceModel();
        final ProductSourceModel updatedSource = buildProductSourceModel(
          currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
        );
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => Right(updatedSource));
        when(
          () => mockDatasource.updateSourcePrices('product-1', [updatedSource]),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<Product>> result = await repository
            .refreshAllProducts();

        expect(result, const Left(failure));
        verifyNever(() => mockDatasource.refreshAllProducts());
      },
    );

    test(
      'groups updated sources by product before calling updateSourcePrices()',
      () async {
        final ProductModel product = buildProductModel();
        final ProductSourceModel firstSource = buildProductSourceModel(
          id: 'source-1',
        );
        final ProductSourceModel secondSource = buildProductSourceModel(
          id: 'source-2',
          url: 'https://other.com/products/1',
        );
        final ProductSourceModel firstUpdated = buildProductSourceModel(
          id: 'source-1',
          currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
        );
        final ProductSourceModel secondUpdated = buildProductSourceModel(
          id: 'source-2',
          currentPrice: const Money(minorUnits: 2999, currencyCode: 'USD'),
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([firstSource, secondSource]));
        when(
          () => mockRemoteDatasource.fetchPrices(firstSource),
        ).thenAnswer((_) async => Right(firstUpdated));
        when(
          () => mockRemoteDatasource.fetchPrices(secondSource),
        ).thenAnswer((_) async => Right(secondUpdated));
        when(
          () => mockDatasource.updateSourcePrices(product.id, [
            firstUpdated,
            secondUpdated,
          ]),
        ).thenAnswer((_) async => Right(product));
        final List<ProductModel> refreshedProducts = [product];
        when(
          () => mockDatasource.refreshAllProducts(),
        ).thenAnswer((_) async => Right(refreshedProducts));

        final Either<Failure, List<Product>> result = await repository
            .refreshAllProducts();

        expect(result, Right(refreshedProducts));
        verify(() => mockRemoteDatasource.fetchPrices(firstSource)).called(1);
        verify(() => mockRemoteDatasource.fetchPrices(secondSource)).called(1);
        verify(
          () => mockDatasource.updateSourcePrices(product.id, [
            firstUpdated,
            secondUpdated,
          ]),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDatasource);
        verify(() => mockDatasource.loadProductSources()).called(1);
        verify(() => mockDatasource.refreshAllProducts()).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('updates sources separately for each distinct product', () async {
      final ProductModel firstProduct = buildProductModel();
      final ProductModel secondProduct = buildProductModel(id: 'product-2');
      final ProductSourceModel firstSource = buildProductSourceModel(
        productId: firstProduct.id,
      );
      final ProductSourceModel secondSource = buildProductSourceModel(
        id: 'source-2',
        productId: secondProduct.id,
        url: 'https://example.com/products/2',
      );
      final ProductSourceModel firstUpdated = buildProductSourceModel(
        productId: firstProduct.id,
        currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
      );
      final ProductSourceModel secondUpdated = buildProductSourceModel(
        id: 'source-2',
        productId: secondProduct.id,
        url: 'https://example.com/products/2',
        currentPrice: const Money(minorUnits: 2999, currencyCode: 'USD'),
      );
      when(
        () => mockDatasource.loadProductSources(),
      ).thenAnswer((_) async => Right([firstSource, secondSource]));
      when(
        () => mockRemoteDatasource.fetchPrices(firstSource),
      ).thenAnswer((_) async => Right(firstUpdated));
      when(
        () => mockRemoteDatasource.fetchPrices(secondSource),
      ).thenAnswer((_) async => Right(secondUpdated));
      when(
        () =>
            mockDatasource.updateSourcePrices(firstProduct.id, [firstUpdated]),
      ).thenAnswer((_) async => Right(firstProduct));
      when(
        () => mockDatasource.updateSourcePrices(secondProduct.id, [
          secondUpdated,
        ]),
      ).thenAnswer((_) async => Right(secondProduct));
      when(
        () => mockDatasource.refreshAllProducts(),
      ).thenAnswer((_) async => Right([firstProduct, secondProduct]));

      await repository.refreshAllProducts();

      verify(
        () =>
            mockDatasource.updateSourcePrices(firstProduct.id, [firstUpdated]),
      ).called(1);
      verify(
        () => mockDatasource.updateSourcePrices(secondProduct.id, [
          secondUpdated,
        ]),
      ).called(1);
    });

    test(
      'returns the fetch failure without calling updateSourcePrices()',
      () async {
        final ProductSourceModel source = buildProductSourceModel();
        const PriceFetchFailure failure = PriceFetchFailure(
          status: PriceFetchStatus.blocked,
          message: 'Website blocked the price request',
        );
        when(
          () => mockDatasource.loadProductSources(),
        ).thenAnswer((_) async => Right([source]));
        when(
          () => mockRemoteDatasource.fetchPrices(source),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, List<Product>> result = await repository
            .refreshAllProducts();

        expect(result, const Left(failure));
        verifyNever(() => mockDatasource.updateSourcePrices(any(), any()));
        verifyNever(() => mockDatasource.refreshAllProducts());
      },
    );
  });
}

Matcher _isCandidateFor(String sourceId, String url) =>
    predicate<ProductSource>(
      (ProductSource candidate) =>
          candidate.id == sourceId &&
          candidate.url == url &&
          candidate.productId.isEmpty &&
          candidate.merchantDomain.isEmpty,
    );
