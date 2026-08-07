// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import '../../fixtures/product_source.fixture.dart';
import '../../fixtures/product_source_model.fixture.dart';

void main() {
  group('ProductSourceModel is an implementation of ProductSource', () {
    test('ProductSourceModel is a ProductSource', () {
      expect(
        ProductSourceModel(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: DateTime(2026, 1, 1),
        ),
        isA<ProductSource>(),
      );
    });
  });

  group("ProductSourceModel's methods return the correct value", () {
    test(
      'Method fromRow() should return a ProductSourceModel with no offer yet',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.id, 'source-1');
        expect(model.productId, 'product-1');
        expect(model.url, 'https://example.com/products/1');
        expect(model.merchantDomain, 'example.com');
        expect(model.createdAt, DateTime(2026, 1, 1));
        expect(model.currentPrice, isNull);
        expect(model.isAvailable, isNull);
        expect(model.lastCheckedAt, isNull);
      },
    );

    test(
      'Method fromRow() should return a ProductSourceModel with a fetched offer',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            minorUnits: 49999,
            currencyCode: 'EUR',
            previousPriceMinorUnits: 59999,
            previousPriceCurrencyCode: 'EUR',
            isAvailable: true,
            lastCheckedAt: DateTime(2026, 1, 1, 12),
            priceChangedAt: DateTime(2026, 1, 2, 12),
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.currentPrice?.minorUnits, isA<int>());
        expect(model.currentPrice?.minorUnits, 49999);
        expect(model.currentPrice?.currencyCode, isA<String>());
        expect(model.currentPrice?.currencyCode, 'EUR');
        expect(
          model.previousPrice,
          const Money(minorUnits: 59999, currencyCode: 'EUR'),
        );
        expect(model.isAvailable, isA<bool>());
        expect(model.isAvailable, isTrue);
        expect(model.lastCheckedAt, DateTime(2026, 1, 1, 12));
        expect(model.priceChangedAt, DateTime(2026, 1, 2, 12));
      },
    );

    test(
      'Method fromRow() returns a null currentPrice when currencyCode is missing',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            minorUnits: 49999,
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.currentPrice, isNull);
      },
    );

    test(
      'Method fromRow() returns a null currentPrice when minorUnits is missing',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            currencyCode: 'EUR',
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.currentPrice, isNull);
      },
    );

    test(
      'Method fromRow() returns a null previousPrice when its currency is missing',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            previousPriceMinorUnits: 59999,
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.previousPrice, isNull);
      },
    );

    test(
      'Method fromRow() returns a null previousPrice when its amount is missing',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            previousPriceCurrencyCode: 'EUR',
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.previousPrice, isNull);
      },
    );

    test('Method fromRow() maps isAvailable = false', () {
      final ProductSourceModel model = ProductSourceModel.fromRow(
        ProductSourceRow(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://example.com/products/1',
          merchantDomain: 'example.com',
          minorUnits: 49999,
          currencyCode: 'EUR',
          isAvailable: false,
          lastCheckedAt: DateTime(2026, 1, 1, 12),
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      expect(model.isAvailable, isA<bool>());
      expect(model.isAvailable, isFalse);
    });

    test(
      'Method fromRow() maps a priced offer with isAvailable and lastCheckedAt still unset',
      () {
        final ProductSourceModel model = ProductSourceModel.fromRow(
          ProductSourceRow(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            minorUnits: 49999,
            currencyCode: 'EUR',
            createdAt: DateTime(2026, 1, 1),
          ),
        );

        expect(model.currentPrice?.minorUnits, 49999);
        expect(model.isAvailable, isNull);
        expect(model.lastCheckedAt, isNull);
      },
    );

    test('Method fromEntity() copies every source field with no offer yet', () {
      final ProductSourceModel model = ProductSourceModel.fromEntity(
        buildProductSource(),
      );

      expect(model.id, buildProductSource().id);
      expect(model.productId, buildProductSource().productId);
      expect(model.url, buildProductSource().url);
      expect(model.merchantDomain, buildProductSource().merchantDomain);
      expect(model.createdAt, buildProductSource().createdAt);
      expect(model.currentPrice, isNull);
      expect(model.isAvailable, isNull);
      expect(model.lastCheckedAt, isNull);
    });

    test(
      'Method fromEntity() copies every source field with a fetched offer',
      () {
        final ProductSourceModel model = ProductSourceModel.fromEntity(
          buildProductSource(
            currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
            previousPrice: const Money(minorUnits: 59999, currencyCode: 'EUR'),
            isAvailable: true,
            lastCheckedAt: DateTime(2026, 1, 1, 12),
            priceChangedAt: DateTime(2026, 1, 2, 12),
          ),
        );

        expect(
          model.currentPrice,
          const Money(minorUnits: 49999, currencyCode: 'EUR'),
        );
        expect(
          model.previousPrice,
          const Money(minorUnits: 59999, currencyCode: 'EUR'),
        );
        expect(model.isAvailable, isTrue);
        expect(model.lastCheckedAt, DateTime(2026, 1, 1, 12));
        expect(model.priceChangedAt, DateTime(2026, 1, 2, 12));
      },
    );

    test(
      'Method toCompanion() should return the correct companion with no offer yet',
      () {
        final ProductSourceModel model = buildProductSourceModel(
          createdAt: DateTime(2026, 1, 1),
        );

        final ProductSourceTableCompanion companion = model.toCompanion();

        expect(companion.id.value, 'source-1');
        expect(companion.productId.value, 'product-1');
        expect(companion.url.value, 'https://example.com/products/1');
        expect(companion.merchantDomain.value, 'example.com');
        expect(companion.createdAt.value, DateTime(2026, 1, 1));
        expect(companion.minorUnits.value, isNull);
        expect(companion.currencyCode.value, isNull);
        expect(companion.isAvailable.value, isNull);
        expect(companion.lastCheckedAt.value, isNull);
      },
    );

    test(
      'Method toCompanion() should return the correct companion with a fetched offer',
      () {
        final ProductSourceModel model = buildProductSourceModel(
          createdAt: DateTime(2026, 1, 1),
          currentPrice: const Money(minorUnits: 49999, currencyCode: 'EUR'),
          previousPrice: const Money(minorUnits: 59999, currencyCode: 'EUR'),
          isAvailable: true,
          lastCheckedAt: DateTime(2026, 1, 1, 12),
          priceChangedAt: DateTime(2026, 1, 2, 12),
        );

        final ProductSourceTableCompanion companion = model.toCompanion();

        expect(companion.minorUnits.value, isA<int>());
        expect(companion.minorUnits.value, 49999);
        expect(companion.currencyCode.value, isA<String>());
        expect(companion.currencyCode.value, 'EUR');
        expect(companion.previousPriceMinorUnits.value, 59999);
        expect(companion.previousPriceCurrencyCode.value, 'EUR');
        expect(companion.isAvailable.value, isA<bool>());
        expect(companion.isAvailable.value, isTrue);
        expect(companion.lastCheckedAt.value, DateTime(2026, 1, 1, 12));
        expect(companion.priceChangedAt.value, DateTime(2026, 1, 2, 12));
      },
    );
  });
}
