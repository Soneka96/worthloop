// Dart imports:
import 'dart:async';

// Package imports:
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';
import '../../fixtures/product_source.fixture.dart';
import '../../fixtures/product_source_model.fixture.dart';
import '../../fixtures/product_source_table.fixture.dart';
import '../../fixtures/product_table.fixture.dart';

class MockLoggerService extends Mock implements LoggerService {}

class MockProductUrlCleanerService extends Mock
    implements ProductUrlCleanerService {}

void main() {
  late AppDatabase db;
  late MockLoggerService mockLoggerService;
  late MockProductUrlCleanerService mockUrlCleanerService;
  late ProductsLocalDatasource datasource;

  Future<void> insertMixedCurrencyProduct(String productId) async {
    await db
        .into(db.productTable)
        .insert(
          buildProductTableCompanion(id: productId, name: 'Mixed Product'),
        );
    for (final String currencyCode in ['USD', 'EUR']) {
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceTableCompanion(
              id: '$productId-$currencyCode',
              productId: productId,
              url: 'https://example.com/$currencyCode',
              minorUnits: 100,
              currencyCode: currencyCode,
              isAvailable: true,
              lastCheckedAt: DateTime(2026, 1, 1, 12),
            ),
          );
    }
  }

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    mockLoggerService = MockLoggerService();
    mockUrlCleanerService = MockProductUrlCleanerService();
    when(
      () => mockUrlCleanerService.clean(any()),
    ).thenAnswer((invocation) => invocation.positionalArguments[0] as String);
    datasource = ProductsLocalDatasource(
      db,
      mockLoggerService,
      mockUrlCleanerService,
    );
  });

  tearDown(() async {
    await db.close();
    reset(mockLoggerService);
    reset(mockUrlCleanerService);
  });

  group('Method loadProducts() returns the correct value', () {
    test('returns an empty list when the product table is empty', () async {
      final Either<Failure, List<ProductModel>> result = await datasource
          .loadProducts();
      final List<ProductModel> products = result.getRight().toNullable() ?? [];

      expect(products, isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns the persisted products when the table is not empty',
      () async {
        await db
            .into(db.productTable)
            .insert(
              buildProductTableCompanion(
                id: 'custom-product',
                name: 'Custom Product',
              ),
            );

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final List<ProductModel> products =
            result.getRight().toNullable() ?? [];

        expect(products.length, isA<int>());
        expect(products.length, 1);
        expect(products.single.id, isA<String>());
        expect(products.single.id, 'custom-product');
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the product table is missing',
      () async {
        await db.customStatement('DROP TABLE product_table');

        final Either<Failure, List<ProductModel>> result = await datasource
            .loadProducts();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test('loads mixed-currency stored offers without rejecting them', () async {
      await insertMixedCurrencyProduct('mixed-product');

      final Either<Failure, List<ProductModel>> result = await datasource
          .loadProducts();
      final ProductModel? product = result.getRight().toNullable()?.single;

      expect(product?.sources, hasLength(2));
      expect(
        product?.sources.map((ProductSource source) => source.currentPrice),
        containsAll([
          const Money(minorUnits: 100, currencyCode: 'USD'),
          const Money(minorUnits: 100, currencyCode: 'EUR'),
        ]),
      );
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('Method watchProducts() returns the correct value', () {
    test('emits an empty list when the database is empty', () async {
      final StreamIterator<List<ProductModel>> products = StreamIterator(
        datasource.watchProducts(),
      );

      expect(await products.moveNext(), isTrue);
      expect(products.current, isEmpty);
      await products.cancel();
    });

    test('emits initial and updated persisted products', () async {
      await db
          .into(db.productTable)
          .insert(buildProductTableCompanion(id: 'product-1'));
      final StreamIterator<List<ProductModel>> products = StreamIterator(
        datasource.watchProducts(),
      );

      expect(await products.moveNext(), isTrue);
      expect(products.current, hasLength(1));
      expect(products.current.single.id, 'product-1');
      expect(products.current.single.sources, isEmpty);

      await db
          .into(db.productSourceTable)
          .insert(buildProductSourceTableCompanion(productId: 'product-1'));

      expect(await products.moveNext(), isTrue);
      expect(products.current.single.sources, hasLength(1));
      await products.cancel();
    });

    test('groups multiple source rows under their products', () async {
      await db
          .into(db.productTable)
          .insert(buildProductTableCompanion(id: 'product-1'));
      await db
          .into(db.productTable)
          .insert(buildProductTableCompanion(id: 'product-2'));
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceTableCompanion(
              id: 'source-1',
              productId: 'product-1',
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceTableCompanion(
              id: 'source-2',
              productId: 'product-1',
              url: 'https://example.com/products/2',
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceTableCompanion(
              id: 'source-3',
              productId: 'product-2',
              url: 'https://example.com/products/3',
            ),
          );

      final StreamIterator<List<ProductModel>> products = StreamIterator(
        datasource.watchProducts(),
      );

      expect(await products.moveNext(), isTrue);
      expect(products.current, hasLength(2));
      expect(
        products.current
            .singleWhere((ProductModel item) => item.id == 'product-1')
            .sources,
        hasLength(2),
      );
      expect(
        products.current
            .singleWhere((ProductModel item) => item.id == 'product-2')
            .sources,
        hasLength(1),
      );
      await products.cancel();
    });
  });

  group('Method loadProduct() returns the correct value', () {
    test('loadProduct() returns the matching product', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());

      final Either<Failure, ProductModel> result = await datasource.loadProduct(
        'product-1',
      );

      expect(result.getRight().toNullable()?.id, 'product-1');
      verifyZeroInteractions(mockLoggerService);
    });

    test('loadProduct() returns Left(NotFoundFailure) when missing', () async {
      final Either<Failure, ProductModel> result = await datasource.loadProduct(
        'missing-product',
      );

      expect(result, const Left(NotFoundFailure('Product not found')));
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('Method renameProduct() returns the correct value', () {
    test('renames the product and preserves everything else', () async {
      await db
          .into(db.productTable)
          .insert(
            buildProductTableCompanion(
              name: 'Original Name',
              imageUrl: 'https://example.com/product.png',
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );

      final Either<Failure, ProductModel> result = await datasource
          .renameProduct('product-1', 'Renamed Product');
      final ProductModel? product = result.getRight().toNullable();

      expect(product, isA<ProductModel>());
      expect(product?.id, 'product-1');
      expect(product?.name, 'Renamed Product');
      expect(product?.imageUrl, 'https://example.com/product.png');
      expect(product?.sources, hasLength(1));
      expect(product?.sources.single.merchantDomain, 'example.com');
      verifyZeroInteractions(mockLoggerService);
    });

    test('leaves other products untouched', () async {
      await db
          .into(db.productTable)
          .insert(buildProductTableCompanion(name: 'Original Name'));
      await db
          .into(db.productTable)
          .insert(
            buildProductTableCompanion(id: 'product-2', name: 'Other Product'),
          );

      await datasource.renameProduct('product-1', 'Renamed Product');
      final ProductRow otherRow = await (db.select(
        db.productTable,
      )..where((table) => table.id.equals('product-2'))).getSingle();

      expect(otherRow.name, 'Other Product');
    });

    test(
      'returns Left(NotFoundFailure) when the product does not exist',
      () async {
        final Either<Failure, ProductModel> result = await datasource
            .renameProduct('missing-product', 'Renamed Product');

        expect(result, const Left(NotFoundFailure('Product not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the product table is missing',
      () async {
        await db.customStatement('DROP TABLE product_table');

        final Either<Failure, ProductModel> result = await datasource
            .renameProduct('product-1', 'Renamed Product');
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method deleteProduct() returns the correct value', () {
    test('deletes the product and returns Right(unit)', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());

      final Either<Failure, Unit> result = await datasource.deleteProduct(
        'product-1',
      );
      final List<ProductRow> rows = await db.select(db.productTable).get();

      expect(result, const Right(unit));
      expect(rows, isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'cascades to the product sources, leaving other products untouched',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
            );
        await db
            .into(db.productTable)
            .insert(
              buildProductTableCompanion(
                id: 'product-2',
                name: 'Other Product',
              ),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceModel.fromEntity(
                buildProductSource(id: 'source-2', productId: 'product-2'),
              ).toCompanion(),
            );

        final Either<Failure, Unit> result = await datasource.deleteProduct(
          'product-1',
        );
        final List<ProductRow> remainingProducts = await db
            .select(db.productTable)
            .get();
        final List<ProductSourceRow> remainingSources = await db
            .select(db.productSourceTable)
            .get();

        expect(result, const Right(unit));
        expect(remainingProducts, hasLength(1));
        expect(remainingProducts.single.id, 'product-2');
        expect(remainingSources, hasLength(1));
        expect(remainingSources.single.productId, 'product-2');
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(NotFoundFailure) when the product does not exist',
      () async {
        final Either<Failure, Unit> result = await datasource.deleteProduct(
          'missing-product',
        );

        expect(result, const Left(NotFoundFailure('Product not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the product table is missing',
      () async {
        await db.customStatement('DROP TABLE product_table');

        final Either<Failure, Unit> result = await datasource.deleteProduct(
          'product-1',
        );
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });

  group('Method createProduct() returns the correct value', () {
    test('creates the product and source atomically', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        sources: const [],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();

      expect(result.getRight().toNullable(), isA<ProductModel>());
      expect(products.length, 1);
      expect(sources.length, 1);
      verifyZeroInteractions(mockLoggerService);
    });

    test('rejects mismatched product and source identifiers', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        sources: const [],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-2',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);

      expect(
        result,
        const Left(
          ValidationFailure('Product and source identifiers do not match'),
        ),
      );
      expect(await db.select(db.productTable).get(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test('rolls back the product when the source insert fails', () async {
      await db
          .into(db.productTable)
          .insert(
            buildProductTableCompanion(
              id: 'existing-product',
              name: 'Existing Product',
            ),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceTableCompanion(
              productId: 'existing-product',
              url: 'https://example.com/products/existing',
            ),
          );
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        sources: const [],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );
      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);

      expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
      expect(await db.select(db.productTable).get(), hasLength(1));
      expect(await db.select(db.productSourceTable).get(), hasLength(1));
      verify(() => mockLoggerService.e(any())).called(1);
    });

    test('rejects non-empty sources', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        sources: [buildProductSource()],
        lastUpdatedAt: DateTime(2026),
      );
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, source);

      expect(
        result,
        const Left(
          ValidationFailure(
            'Product creation does not accept pre-populated sources',
          ),
        ),
      );
      expect(await db.select(db.productTable).get(), isEmpty);
      expect(await db.select(db.productSourceTable).get(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns ValidationFailure for a directly constructed invalid source',
      () async {
        final Product product = Product(
          id: 'product-1',
          name: 'Example Product',
          sources: const [],
          lastUpdatedAt: DateTime(2026),
        );
        final ProductSource source = ProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'http://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: DateTime(2026),
        );

        final Either<Failure, ProductModel> result = await datasource
            .createProduct(product, source);

        expect(result.getLeft().toNullable(), isA<ValidationFailure>());
        expect(await db.select(db.productTable).get(), isEmpty);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('creates the product without a source when source == null', () async {
      final Product product = Product(
        id: 'product-1',
        name: 'Example Product',
        sources: const [],
        lastUpdatedAt: DateTime(2026),
      );

      final Either<Failure, ProductModel> result = await datasource
          .createProduct(product, null);
      final List<ProductRow> products = await db.select(db.productTable).get();
      final List<ProductSourceRow> sources = await db
          .select(db.productSourceTable)
          .get();

      expect(result.getRight().toNullable(), isA<ProductModel>());
      expect(products.length, 1);
      expect(sources, isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns DatabaseFailure when the product insert fails and source == null',
      () async {
        await db
            .into(db.productTable)
            .insert(buildProductTableCompanion(name: 'Existing Product'));
        final Product product = Product(
          id: 'product-1',
          name: 'Example Product',
          sources: const [],
          lastUpdatedAt: DateTime(2026),
        );

        final Either<Failure, ProductModel> result = await datasource
            .createProduct(product, null);

        expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
        expect(await db.select(db.productTable).get(), hasLength(1));
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });

  group('Method addSourceWithPrice() returns the correct value', () {
    Future<void> insertProductOne() =>
        db.into(db.productTable).insert(buildProductTableCompanion());

    test('saves the source with its offer and returns the product', () async {
      await insertProductOne();
      final ProductSource pricedSource = buildProductSource(
        currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
        isAvailable: true,
        lastCheckedAt: DateTime(2026, 1, 1, 12),
      );

      final Either<Failure, ProductModel> result = await datasource
          .addSourceWithPrice(pricedSource);
      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();

      expect(result.getRight().toNullable()?.sources, hasLength(1));
      expect(row.minorUnits, 49999);
      expect(row.currencyCode, 'EUR');
      expect(row.isAvailable, isTrue);
      expect(row.lastCheckedAt, DateTime(2026, 1, 1, 12));
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'adds a source with another currency beside an existing offer',
      () async {
        await insertProductOne();
        await datasource.addSourceWithPrice(
          buildProductSource(
            currentPrice: const Money(minorUnits: 49999, currencyCode: 'USD'),
            isAvailable: true,
          ),
        );

        final Either<Failure, ProductModel> result = await datasource
            .addSourceWithPrice(
              buildProductSource(
                id: 'source-2',
                url: 'https://other.example.com/1',
                currentPrice: const Money(
                  minorUnits: 45999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ),
            );
        final List<Money?> prices =
            result
                .getRight()
                .toNullable()
                ?.sources
                .map((ProductSource source) => source.currentPrice)
                .toList(growable: false) ??
            [];

        expect(
          prices,
          containsAll([
            const Money(minorUnits: 49999, currencyCode: 'USD'),
            const Money(minorUnits: 45999, currencyCode: 'EUR'),
          ]),
        );
      },
    );

    test('persists the cleaned URL, not the raw one', () async {
      await insertProductOne();
      when(
        () => mockUrlCleanerService.clean('https://example.com/1?ref=x'),
      ).thenReturn('https://example.com/1');

      await datasource.addSourceWithPrice(
        buildProductSource(url: 'https://example.com/1?ref=x'),
      );
      final ProductSourceRow row = await db
          .select(db.productSourceTable)
          .getSingle();

      expect(row.url, 'https://example.com/1');
      verify(
        () => mockUrlCleanerService.clean('https://example.com/1?ref=x'),
      ).called(1);
    });

    test('rejects a cleaned URL already tracked for this product', () async {
      await insertProductOne();
      await datasource.addSourceWithPrice(buildProductSource());

      final Either<Failure, ProductModel> result = await datasource
          .addSourceWithPrice(buildProductSource(id: 'source-2'));

      expect(
        result,
        const Left(
          ValidationFailure('This store is already tracked for this product'),
        ),
      );
      expect(await db.select(db.productSourceTable).get(), hasLength(1));
    });

    test('rejects affiliate URL variants of an already tracked product', () async {
      await insertProductOne();
      const String firstUrl =
          'https://www.pccomponentes.pt/moza-racing-r12-v2-base-para-volante-direct-drive-12nm-aluminio-preto?sv1=affiliate&sv_campaign_id=176013&awc=first';
      const String secondUrl =
          'https://www.pccomponentes.pt/moza-racing-r12-v2-base-para-volante-direct-drive-12nm-aluminio-preto?sv1=affiliate&sv_campaign_id=369493&awc=second';
      const String canonicalUrl =
          'https://www.pccomponentes.pt/moza-racing-r12-v2-base-para-volante-direct-drive-12nm-aluminio-preto';
      when(
        () => mockUrlCleanerService.clean(firstUrl),
      ).thenReturn(canonicalUrl);
      when(
        () => mockUrlCleanerService.clean(secondUrl),
      ).thenReturn(canonicalUrl);

      await datasource.addSourceWithPrice(buildProductSource(url: firstUrl));
      final Either<Failure, ProductModel> result = await datasource
          .addSourceWithPrice(
            buildProductSource(id: 'source-2', url: secondUrl),
          );

      expect(
        result,
        const Left(
          ValidationFailure('This store is already tracked for this product'),
        ),
      );
      expect(await db.select(db.productSourceTable).get(), hasLength(1));
    });

    test('allows the same cleaned URL for a different product', () async {
      await insertProductOne();
      await db
          .into(db.productTable)
          .insert(
            buildProductTableCompanion(id: 'product-2', name: 'Other Product'),
          );
      await datasource.addSourceWithPrice(buildProductSource());

      final Either<Failure, ProductModel> result = await datasource
          .addSourceWithPrice(
            buildProductSource(id: 'source-2', productId: 'product-2'),
          );

      expect(result.getRight().toNullable()?.sources, hasLength(1));
      expect(await db.select(db.productSourceTable).get(), hasLength(2));
    });

    test('returns ValidationFailure for an invalid URL', () async {
      await insertProductOne();

      final Either<Failure, ProductModel> result = await datasource
          .addSourceWithPrice(buildProductSource(url: 'http://example.com/1'));

      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      expect(await db.select(db.productSourceTable).get(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the product does not exist',
      () async {
        final Either<Failure, ProductModel> result = await datasource
            .addSourceWithPrice(
              buildProductSource(productId: 'missing-product'),
            );

        expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });

  group('Method editSourceWithPrice() returns the correct value', () {
    Future<void> insertSourceOne() async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );
    }

    test('updates the source URL and offer, and returns the product', () async {
      await insertSourceOne();
      final ProductSource pricedSource = buildProductSource(
        url: 'https://updated.example.com/1',
        currentPrice: const Money(minorUnits: 29999, currencyCode: 'EUR'),
        isAvailable: false,
        lastCheckedAt: DateTime(2026, 1, 2),
      );

      final Either<Failure, ProductModel> result = await datasource
          .editSourceWithPrice('source-1', pricedSource);
      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();

      expect(result.getRight().toNullable()?.id, 'product-1');
      expect(row.url, 'https://updated.example.com/1');
      expect(row.merchantDomain, 'updated.example.com');
      expect(row.minorUnits, 29999);
      expect(row.isAvailable, isFalse);
      expect(row.lastCheckedAt, DateTime(2026, 1, 2));
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'edits a source to another currency beside an existing offer',
      () async {
        await insertSourceOne();
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceModel.fromEntity(
                buildProductSource(
                  id: 'source-2',
                  url: 'https://other.example.com/1',
                  currentPrice: const Money(
                    minorUnits: 45999,
                    currencyCode: 'EUR',
                  ),
                ),
              ).toCompanion(),
            );

        final Either<Failure, ProductModel> result = await datasource
            .editSourceWithPrice(
              'source-1',
              buildProductSource(
                currentPrice: const Money(
                  minorUnits: 49999,
                  currencyCode: 'USD',
                ),
              ),
            );
        final List<Money?> prices =
            result
                .getRight()
                .toNullable()
                ?.sources
                .map((ProductSource source) => source.currentPrice)
                .toList(growable: false) ??
            [];

        expect(
          prices,
          containsAll([
            const Money(minorUnits: 49999, currencyCode: 'USD'),
            const Money(minorUnits: 45999, currencyCode: 'EUR'),
          ]),
        );
      },
    );

    test('persists the cleaned URL, not the raw one', () async {
      await insertSourceOne();
      when(
        () =>
            mockUrlCleanerService.clean('https://updated.example.com/1?ref=x'),
      ).thenReturn('https://updated.example.com/1');

      await datasource.editSourceWithPrice(
        'source-1',
        buildProductSource(url: 'https://updated.example.com/1?ref=x'),
      );
      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();

      expect(row.url, 'https://updated.example.com/1');
      verify(
        () =>
            mockUrlCleanerService.clean('https://updated.example.com/1?ref=x'),
      ).called(1);
    });

    test('leaves other sources untouched', () async {
      await insertSourceOne();
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(
              buildProductSource(
                id: 'source-2',
                url: 'https://other.example.com/1',
                merchantDomain: 'other.example.com',
              ),
            ).toCompanion(),
          );

      await datasource.editSourceWithPrice(
        'source-1',
        buildProductSource(url: 'https://updated.example.com/1'),
      );
      final ProductSourceRow otherRow = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-2'))).getSingle();

      expect(otherRow.url, 'https://other.example.com/1');
      expect(otherRow.merchantDomain, 'other.example.com');
    });

    test('allows keeping the source at its own current URL', () async {
      await insertSourceOne();

      final Either<Failure, ProductModel> result = await datasource
          .editSourceWithPrice(
            'source-1',
            buildProductSource(
              currentPrice: const Money(minorUnits: 1, currencyCode: 'EUR'),
            ),
          );

      expect(result.getRight().toNullable(), isA<ProductModel>());
    });

    test('rejects a cleaned URL already tracked by another source', () async {
      await insertSourceOne();
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(
              buildProductSource(
                id: 'source-2',
                url: 'https://other.example.com/1',
              ),
            ).toCompanion(),
          );

      final Either<Failure, ProductModel> result = await datasource
          .editSourceWithPrice(
            'source-2',
            buildProductSource(url: 'https://example.com/products/1'),
          );

      expect(
        result,
        const Left(
          ValidationFailure('This store is already tracked for this product'),
        ),
      );
    });

    test(
      'returns Left(NotFoundFailure) when the source does not exist',
      () async {
        final Either<Failure, ProductModel> result = await datasource
            .editSourceWithPrice('missing-source', buildProductSource());

        expect(result, const Left(NotFoundFailure('Source not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('returns ValidationFailure for an invalid URL', () async {
      await insertSourceOne();

      final Either<Failure, ProductModel> result = await datasource
          .editSourceWithPrice(
            'source-1',
            buildProductSource(url: 'http://example.com/1'),
          );

      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, ProductModel> result = await datasource
            .editSourceWithPrice('source-1', buildProductSource());
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });

  group('Method deleteSource() returns the correct value', () {
    test('deletes the source and returns the product without it', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );

      final Either<Failure, ProductModel> result = await datasource
          .deleteSource('source-1');
      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();

      expect(result.getRight().toNullable()?.sources, isEmpty);
      expect(rows, isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });

    test('leaves other sources untouched', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(
              buildProductSource(
                id: 'source-2',
                url: 'https://other.example.com/1',
              ),
            ).toCompanion(),
          );

      await datasource.deleteSource('source-1');
      final List<ProductSourceRow> rows = await db
          .select(db.productSourceTable)
          .get();

      expect(rows, hasLength(1));
      expect(rows.single.id, 'source-2');
    });

    test(
      'returns Left(NotFoundFailure) when the source does not exist',
      () async {
        final Either<Failure, ProductModel> result = await datasource
            .deleteSource('missing-source');

        expect(result, const Left(NotFoundFailure('Source not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, ProductModel> result = await datasource
            .deleteSource('source-1');
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });

  group('Method loadProductSourcesForProduct() returns the correct value', () {
    test('loads the saved source for a product', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(buildProductSourceTableCompanion());

      final Either<Failure, List<ProductSourceModel>> result = await datasource
          .loadProductSourcesForProduct('product-1');

      expect(result.getRight().toNullable()?.single.id, 'source-1');
      verifyZeroInteractions(mockLoggerService);
    });

    test('returns an empty list when a product has no saved source', () async {
      final Either<Failure, List<ProductSourceModel>> result = await datasource
          .loadProductSourcesForProduct('product-1');

      expect(result.getRight().toNullable(), isEmpty);
      verifyZeroInteractions(mockLoggerService);
    });
  });

  group('Method loadProductSources() returns the correct value', () {
    test('loads every saved product source', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(buildProductSourceTableCompanion());

      final Either<Failure, List<ProductSourceModel>> result = await datasource
          .loadProductSources();
      final List<ProductSourceModel> sources =
          result.getRight().toNullable() ?? [];

      expect(sources.length, 1);
      expect(sources.single.id, 'source-1');
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, List<ProductSourceModel>> result =
            await datasource.loadProductSources();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });

  group('Method updateSourcePrices() returns the correct value', () {
    Future<void> insertTwoSources() async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
          );
      await db
          .into(db.productSourceTable)
          .insert(
            ProductSourceModel.fromEntity(
              buildProductSource(
                id: 'source-2',
                url: 'https://other.example.com/1',
              ),
            ).toCompanion(),
          );
    }

    test(
      'applies the offer to each updated source and returns the product',
      () async {
        await insertTwoSources();

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', [
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 1999,
                  currencyCode: 'USD',
                ),
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 2),
                lastRefreshStatus: PriceFetchStatus.success,
                lastRefreshAt: DateTime(2026, 1, 2, 12),
              ),
            ]);
        final ProductSourceRow row = await (db.select(
          db.productSourceTable,
        )..where((table) => table.id.equals('source-1'))).getSingle();

        expect(result.getRight().toNullable()?.id, 'product-1');
        expect(row.minorUnits, 1999);
        expect(row.previousPriceMinorUnits, isNull);
        expect(row.priceChangedAt, isNull);
        expect(row.isAvailable, isTrue);
        expect(row.lastCheckedAt, DateTime(2026, 1, 2));
        expect(row.lastRefreshStatus, PriceFetchStatus.success.name);
        expect(row.lastRefreshAt, DateTime(2026, 1, 2, 12));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'records a failed refresh while preserving the previous offer',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 2999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 1),
              ).toCompanion(),
            );

        await datasource.updateSourcePrices('product-1', [
          buildProductSourceModel(
            currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
            isAvailable: true,
            lastCheckedAt: DateTime(2026, 1, 1),
            lastRefreshStatus: PriceFetchStatus.blocked,
          ),
        ]);
        final ProductSourceRow row = await (db.select(
          db.productSourceTable,
        )..where((table) => table.id.equals('source-1'))).getSingle();

        expect(row.minorUnits, 2999);
        expect(row.currencyCode, 'EUR');
        expect(row.lastRefreshStatus, PriceFetchStatus.blocked.name);
        expect(row.lastRefreshAt, isA<DateTime>());
      },
    );

    test(
      'stores the previous source price when a refresh changes it',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 2999,
                  currencyCode: 'EUR',
                ),
                lastCheckedAt: DateTime(2026, 1, 1),
              ).toCompanion(),
            );

        await datasource.updateSourcePrices('product-1', [
          buildProductSourceModel(
            currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
            lastCheckedAt: DateTime(2026, 1, 2),
          ),
        ]);

        final ProductSourceRow row = await (db.select(
          db.productSourceTable,
        )..where((table) => table.id.equals('source-1'))).getSingle();
        expect(row.minorUnits, 1999);
        expect(row.previousPriceMinorUnits, 2999);
        expect(row.previousPriceCurrencyCode, 'EUR');
        expect(row.priceChangedAt, DateTime(2026, 1, 2));
      },
    );

    test(
      'does not change source history when a refresh finds the same price',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 2999,
                  currencyCode: 'EUR',
                ),
                previousPrice: const Money(
                  minorUnits: 3999,
                  currencyCode: 'EUR',
                ),
                lastCheckedAt: DateTime(2026, 1, 1),
                priceChangedAt: DateTime(2025, 12, 31),
              ).toCompanion(),
            );

        await datasource.updateSourcePrices('product-1', [
          buildProductSourceModel(
            currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
            lastCheckedAt: DateTime(2026, 1, 2),
          ),
        ]);

        final ProductSourceRow row = await (db.select(
          db.productSourceTable,
        )..where((table) => table.id.equals('source-1'))).getSingle();
        expect(row.previousPriceMinorUnits, 3999);
        expect(row.previousPriceCurrencyCode, 'EUR');
        expect(row.priceChangedAt, DateTime(2025, 12, 31));
      },
    );

    test('stores history when only the source currency changes', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceModel(
              currentPrice: const Money(minorUnits: 2999, currencyCode: 'EUR'),
              lastCheckedAt: DateTime(2026, 1, 1),
            ).toCompanion(),
          );

      await datasource.updateSourcePrices('product-1', [
        buildProductSourceModel(
          currentPrice: const Money(minorUnits: 2999, currencyCode: 'USD'),
          lastCheckedAt: DateTime(2026, 1, 2),
        ),
      ]);

      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();
      expect(row.previousPriceMinorUnits, 2999);
      expect(row.previousPriceCurrencyCode, 'EUR');
      expect(row.priceChangedAt, DateTime(2026, 1, 2));
    });

    test(
      'stores the previous product best price when the best price changes',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 2999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ).toCompanion(),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                id: 'source-2',
                url: 'https://other.example.com/1',
                currentPrice: const Money(
                  minorUnits: 3999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ).toCompanion(),
            );

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', [
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 1999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 2),
              ),
            ]);

        final ProductModel? product = result.getRight().toNullable();
        expect(
          product?.previousBestPrice,
          const Money(minorUnits: 2999, currencyCode: 'EUR'),
        );
        expect(product?.bestPriceChangedAt, DateTime(2026, 1, 2));
      },
    );

    test(
      'does not change product history when a non-best source changes',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 1999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ).toCompanion(),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                id: 'source-2',
                url: 'https://other.example.com/1',
                currentPrice: const Money(
                  minorUnits: 3999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ).toCompanion(),
            );

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', [
              buildProductSourceModel(
                id: 'source-2',
                currentPrice: const Money(
                  minorUnits: 2999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
                lastCheckedAt: DateTime(2026, 1, 2),
              ),
            ]);

        final ProductModel? product = result.getRight().toNullable();
        expect(product?.previousBestPrice, isNull);
        expect(product?.bestPriceChangedAt, isNull);
      },
    );

    test(
      'stores product history when availability changes the best offer',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 1999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ).toCompanion(),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                id: 'source-2',
                url: 'https://other.example.com/1',
                currentPrice: const Money(
                  minorUnits: 2999,
                  currencyCode: 'EUR',
                ),
                isAvailable: true,
              ).toCompanion(),
            );

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', [
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 1999,
                  currencyCode: 'EUR',
                ),
                isAvailable: false,
                lastCheckedAt: DateTime(2026, 1, 2),
              ),
            ]);

        final ProductModel? product = result.getRight().toNullable();
        expect(
          product?.previousBestPrice,
          const Money(minorUnits: 1999, currencyCode: 'EUR'),
        );
        expect(product?.bestPriceChangedAt, DateTime(2026, 1, 2));
      },
    );

    test('leaves sources not in the update list untouched', () async {
      await insertTwoSources();

      await datasource.updateSourcePrices('product-1', [
        buildProductSourceModel(
          currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
          isAvailable: true,
          lastCheckedAt: DateTime(2026, 1, 2),
        ),
      ]);
      final ProductSourceRow otherRow = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-2'))).getSingle();

      expect(otherRow.minorUnits, isNull);
      expect(otherRow.isAvailable, isNull);
    });

    test(
      'returns Left(NotFoundFailure) when the product does not exist',
      () async {
        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('missing-product', []);

        expect(result, const Left(NotFoundFailure('Product not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'touches the product and returns it unchanged when given no updates',
      () async {
        await insertTwoSources();
        final ProductRow before =
            (await db.select(db.productTable).get()).single;

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', []);
        final ProductRow after =
            (await db.select(db.productTable).get()).single;

        expect(result.getRight().toNullable()?.sources, hasLength(2));
        expect(after.lastUpdatedAt.isAfter(before.lastUpdatedAt), isTrue);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('persists updated offers with different currencies', () async {
      await insertTwoSources();

      final Either<Failure, ProductModel> result = await datasource
          .updateSourcePrices('product-1', [
            buildProductSourceModel(
              id: 'source-1',
              currentPrice: const Money(minorUnits: 1999, currencyCode: 'USD'),
            ),
            buildProductSourceModel(
              id: 'source-2',
              currentPrice: const Money(minorUnits: 1999, currencyCode: 'EUR'),
            ),
          ]);
      final List<Money?> prices =
          result
              .getRight()
              .toNullable()
              ?.sources
              .map((ProductSource source) => source.currentPrice)
              .toList(growable: false) ??
          [];

      expect(
        prices,
        containsAll([
          const Money(minorUnits: 1999, currencyCode: 'USD'),
          const Money(minorUnits: 1999, currencyCode: 'EUR'),
        ]),
      );
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'updates one currency while leaving a different sibling unchanged',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceModel.fromEntity(buildProductSource()).toCompanion(),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              ProductSourceModel.fromEntity(
                buildProductSource(
                  id: 'source-2',
                  url: 'https://other.example.com/1',
                  currentPrice: const Money(
                    minorUnits: 11700,
                    currencyCode: 'GBP',
                  ),
                ),
              ).toCompanion(),
            );

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', [
              buildProductSourceModel(
                currentPrice: const Money(
                  minorUnits: 45999,
                  currencyCode: 'EUR',
                ),
              ),
            ]);
        final List<Money?> prices =
            result
                .getRight()
                .toNullable()
                ?.sources
                .map((ProductSource source) => source.currentPrice)
                .toList(growable: false) ??
            [];

        expect(
          prices,
          containsAll([
            const Money(minorUnits: 45999, currencyCode: 'EUR'),
            const Money(minorUnits: 11700, currencyCode: 'GBP'),
          ]),
        );
      },
    );

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await insertTwoSources();
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, ProductModel> result = await datasource
            .updateSourcePrices('product-1', [buildProductSourceModel()]);
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });

  group('Method writeSourceLiveStatus() returns the correct value', () {
    Future<void> insertSource() async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(buildProductSourceModel().toCompanion());
    }

    test("updates the source's liveStatus and returns Right(unit)", () async {
      await insertSource();

      final Either<Failure, Unit> result = await datasource
          .writeSourceLiveStatus('source-1', SourceRefreshStatus.fetching);
      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();

      expect(result, const Right(unit));
      expect(row.liveStatus, SourceRefreshStatus.fetching.name);
      verifyZeroInteractions(mockLoggerService);
    });

    test('clears liveStatus back to null when status = null', () async {
      await db.into(db.productTable).insert(buildProductTableCompanion());
      await db
          .into(db.productSourceTable)
          .insert(
            buildProductSourceModel(
              liveStatus: SourceRefreshStatus.queued,
            ).toCompanion(),
          );

      final Either<Failure, Unit> result = await datasource
          .writeSourceLiveStatus('source-1', null);
      final ProductSourceRow row = await (db.select(
        db.productSourceTable,
      )..where((table) => table.id.equals('source-1'))).getSingle();

      expect(result, const Right(unit));
      expect(row.liveStatus, isNull);
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(NotFoundFailure) when the source does not exist',
      () async {
        final Either<Failure, Unit> result = await datasource
            .writeSourceLiveStatus(
              'missing-source',
              SourceRefreshStatus.fetching,
            );

        expect(result, const Left(NotFoundFailure('Source not found')));
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, Unit> result = await datasource
            .writeSourceLiveStatus('source-1', SourceRefreshStatus.fetching);
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });

  group('Method resetStaleLiveStatuses() returns the correct value', () {
    test(
      'clears every queued and fetching source, leaving others untouched',
      () async {
        await db.into(db.productTable).insert(buildProductTableCompanion());
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                liveStatus: SourceRefreshStatus.queued,
              ).toCompanion(),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                id: 'source-2',
                url: 'https://other.example.com/1',
                liveStatus: SourceRefreshStatus.fetching,
              ).toCompanion(),
            );
        await db
            .into(db.productSourceTable)
            .insert(
              buildProductSourceModel(
                id: 'source-3',
                url: 'https://third.example.com/1',
                currentPrice: const Money(
                  minorUnits: 1999,
                  currencyCode: 'USD',
                ),
                lastRefreshStatus: PriceFetchStatus.success,
              ).toCompanion(),
            );

        final Either<Failure, Unit> result = await datasource
            .resetStaleLiveStatuses();
        final List<ProductSourceRow> rows = await db
            .select(db.productSourceTable)
            .get();

        expect(result, const Right(unit));
        expect(
          rows.firstWhere((row) => row.id == 'source-1').liveStatus,
          isNull,
        );
        expect(
          rows.firstWhere((row) => row.id == 'source-2').liveStatus,
          isNull,
        );
        final ProductSourceRow untouchedRow = rows.firstWhere(
          (row) => row.id == 'source-3',
        );
        expect(untouchedRow.liveStatus, isNull);
        expect(untouchedRow.minorUnits, 1999);
        expect(untouchedRow.lastRefreshStatus, PriceFetchStatus.success.name);
        verifyZeroInteractions(mockLoggerService);
      },
    );

    test('returns Right(unit) when there is nothing stale to clear', () async {
      final Either<Failure, Unit> result = await datasource
          .resetStaleLiveStatuses();

      expect(result, const Right(unit));
      verifyZeroInteractions(mockLoggerService);
    });

    test(
      'returns Left(DatabaseFailure) when the source table is missing',
      () async {
        await db.customStatement('DROP TABLE product_source_table');

        final Either<Failure, Unit> result = await datasource
            .resetStaleLiveStatuses();
        final Failure failure =
            result.getLeft().toNullable() ??
            const DatabaseFailure('Expected a failure');

        expect(failure, isA<DatabaseFailure>());
        verify(() => mockLoggerService.e(failure.message)).called(1);
      },
    );
  });
}
