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
import 'package:worth_loop/shared/utils/product_source_refresh_engine.dart';
import '../../fixtures/product_model.fixture.dart';
import '../../fixtures/product_source.fixture.dart';
import '../../fixtures/product_source_model.fixture.dart';

class MockProductsLocalDatasource extends Mock
    implements ProductsLocalDatasource {}

class MockIProductsRemoteDatasource extends Mock
    implements IProductsRemoteDatasource {}

class MockProductSourceRefreshEngine extends Mock
    implements ProductSourceRefreshEngine {}

void main() {
  late MockProductsLocalDatasource mockDatasource;
  late MockIProductsRemoteDatasource mockRemoteDatasource;
  late MockProductSourceRefreshEngine mockRefreshEngine;
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
    mockRefreshEngine = MockProductSourceRefreshEngine();
    repository = ProductsRepository(
      mockDatasource,
      mockRemoteDatasource,
      mockRefreshEngine,
    );
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

  group('ProductsRepository implements watchProducts() correctly', () {
    test('Method watchProducts() returns the datasource stream', () async {
      final List<ProductModel> products = [buildProductModel()];
      final List<ProductModel> updatedProducts = [
        buildProductModel(name: 'Updated Product'),
      ];
      when(
        () => mockDatasource.watchProducts(),
      ).thenAnswer((_) => Stream.fromIterable([products, updatedProducts]));

      final List<List<Product>> result = await repository
          .watchProducts()
          .take(2)
          .toList();

      expect(result, [products, updatedProducts]);
      verify(() => mockDatasource.watchProducts()).called(1);
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

  group('ProductsRepository implements resetStaleSourceStatuses() correctly', () {
    test(
      'Method resetStaleSourceStatuses() returns the datasource result',
      () async {
        when(
          () => mockDatasource.resetStaleLiveStatuses(),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await repository
            .resetStaleSourceStatuses();

        expect(result, const Right(unit));
        verify(() => mockDatasource.resetStaleLiveStatuses()).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'Method resetStaleSourceStatuses() forwards datasource failures unchanged',
      () async {
        const DatabaseFailure failure = DatabaseFailure('database failed');
        when(
          () => mockDatasource.resetStaleLiveStatuses(),
        ).thenAnswer((_) async => const Left(failure));

        final Either<Failure, Unit> result = await repository
            .resetStaleSourceStatuses();

        expect(result, const Left(failure));
        verify(() => mockDatasource.resetStaleLiveStatuses()).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });

  group('ProductsRepository implements enqueueSourceRefresh() correctly', () {
    test(
      'Method enqueueSourceRefresh() calls ProductSourceRefreshEngine.enqueueSourceRefresh() when bypassCooldown = true',
      () async {
        when(
          () => mockRefreshEngine.enqueueSourceRefresh(
            ['source-1'],
            bypassCooldown: true,
          ),
        ).thenAnswer((_) async => const Right(unit));

        final Either<Failure, Unit> result = await repository
            .enqueueSourceRefresh(['source-1'], bypassCooldown: true);

        expect(result, const Right(unit));
        verify(
          () => mockRefreshEngine.enqueueSourceRefresh(
            ['source-1'],
            bypassCooldown: true,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRefreshEngine);
        verifyZeroInteractions(mockDatasource);
        verifyZeroInteractions(mockRemoteDatasource);
      },
    );

    test(
      'Method enqueueSourceRefresh() calls ProductSourceRefreshEngine.enqueueSourceRefresh() when bypassCooldown is omitted',
      () async {
        when(
          () => mockRefreshEngine.enqueueSourceRefresh(
            ['source-1'],
            bypassCooldown: false,
          ),
        ).thenAnswer((_) async => const Right(unit));

        await repository.enqueueSourceRefresh(['source-1']);

        verify(
          () => mockRefreshEngine.enqueueSourceRefresh(
            ['source-1'],
            bypassCooldown: false,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRefreshEngine);
      },
    );

    test('Method enqueueSourceRefresh() forwards engine failures unchanged', () async {
      const DatabaseFailure failure = DatabaseFailure('database failed');
      when(
        () => mockRefreshEngine.enqueueSourceRefresh(
          ['source-1'],
          bypassCooldown: false,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final Either<Failure, Unit> result = await repository
          .enqueueSourceRefresh(['source-1']);

      expect(result, const Left(failure));
      verify(
        () => mockRefreshEngine.enqueueSourceRefresh(
          ['source-1'],
          bypassCooldown: false,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRefreshEngine);
    });
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
