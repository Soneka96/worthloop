// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

void main() {
  group('Product equality', () {
    test('includes every product field', () {
      final Product product = buildProduct(sources: [buildProductSource()]);

      expect(product.props, <Object?>[
        'product-1',
        'Example Product',
        'https://example.com/product.png',
        [buildProductSource()],
        DateTime(2026, 1, 1, 12),
      ]);
      expect(product, buildProduct(sources: [buildProductSource()]));
      expect(
        product,
        isNot(buildProduct(id: 'product-2', sources: [buildProductSource()])),
      );
      expect(
        product,
        isNot(
          buildProduct(
            name: 'Another Product',
            sources: [buildProductSource()],
          ),
        ),
      );
      expect(
        product,
        isNot(
          buildProduct(
            imageUrl: 'https://example.com/other.png',
            sources: [buildProductSource()],
          ),
        ),
      );
      expect(
        product,
        isNot(buildProduct(sources: [buildProductSource(id: 'source-2')])),
      );
      expect(
        product,
        isNot(
          buildProduct(
            sources: [buildProductSource()],
            lastUpdatedAt: DateTime(2026, 1, 2),
          ),
        ),
      );
    });

    test('supports a product without an image', () {
      final Product product = buildProduct(imageUrl: null);

      expect(product.imageUrl, isNull);
    });
  });

  group('Getter availablePricesSorted returns the correct value', () {
    test('returns available offers sorted by ascending minorUnits', () {
      final ProductSource expensive = buildProductSource(
        id: 'source-expensive',
        currentPrice: buildMoney(minorUnits: 60000),
        isAvailable: true,
      );
      final ProductSource unavailable = buildProductSource(
        id: 'source-unavailable',
        currentPrice: buildMoney(minorUnits: 10000),
        isAvailable: false,
      );
      final ProductSource cheapest = buildProductSource(
        id: 'source-cheapest',
        currentPrice: buildMoney(minorUnits: 40000),
        isAvailable: true,
      );
      final Product product = buildProduct(
        sources: [expensive, unavailable, cheapest],
      );

      expect(product.availablePricesSorted, [cheapest, expensive]);
      expect(product.sources, [expensive, unavailable, cheapest]);
    });

    test('returns an empty list when every offer is unavailable', () {
      final Product product = buildProduct(
        sources: [
          buildProductSource(currentPrice: buildMoney(), isAvailable: false),
        ],
      );

      expect(product.availablePricesSorted, isEmpty);
    });

    test('excludes a source with no offer fetched yet', () {
      final Product product = buildProduct(sources: [buildProductSource()]);

      expect(product.availablePricesSorted, isEmpty);
    });

    test('excludes an available source with no price fetched yet', () {
      final Product product = buildProduct(
        sources: [buildProductSource(isAvailable: true)],
      );

      expect(product.availablePricesSorted, isEmpty);
    });

    test('rejects available offers with different currencies', () {
      final Product product = buildProduct(
        sources: [
          buildProductSource(
            id: 'source-usd',
            currentPrice: buildMoney(currencyCode: 'USD'),
            isAvailable: true,
          ),
          buildProductSource(
            id: 'source-eur',
            currentPrice: buildMoney(currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );

      expect(() => product.availablePricesSorted, throwsStateError);
    });

    test(
      'rejects mismatched currencies between an available and an unavailable offer',
      () {
        final Product product = buildProduct(
          sources: [
            buildProductSource(
              id: 'source-usd',
              currentPrice: buildMoney(currencyCode: 'USD'),
              isAvailable: true,
            ),
            buildProductSource(
              id: 'source-eur',
              currentPrice: buildMoney(currencyCode: 'EUR'),
              isAvailable: false,
            ),
          ],
        );

        expect(() => product.availablePricesSorted, throwsStateError);
      },
    );
  });

  group('Getter bestAvailablePrice returns the correct value', () {
    test('returns the lowest available offer', () {
      final ProductSource expensive = buildProductSource(
        id: 'source-expensive',
        currentPrice: buildMoney(minorUnits: 60000),
        isAvailable: true,
      );
      final ProductSource cheapest = buildProductSource(
        id: 'source-cheapest',
        currentPrice: buildMoney(minorUnits: 40000),
        isAvailable: true,
      );
      final Product product = buildProduct(sources: [expensive, cheapest]);

      expect(product.bestAvailablePrice, cheapest);
    });

    test('returns null when no offer is available', () {
      final Product product = buildProduct();

      expect(product.bestAvailablePrice, isNull);
    });

    test('returns null when every offer is unavailable', () {
      final Product product = buildProduct(
        sources: [
          buildProductSource(currentPrice: buildMoney(), isAvailable: false),
        ],
      );

      expect(product.bestAvailablePrice, isNull);
    });

    test('returns null when every source has no offer fetched yet', () {
      final Product product = buildProduct(sources: [buildProductSource()]);

      expect(product.bestAvailablePrice, isNull);
    });

    test('rejects available offers with different currencies', () {
      final Product product = buildProduct(
        sources: [
          buildProductSource(
            id: 'source-usd',
            currentPrice: buildMoney(currencyCode: 'USD'),
            isAvailable: true,
          ),
          buildProductSource(
            id: 'source-eur',
            currentPrice: buildMoney(currencyCode: 'EUR'),
            isAvailable: true,
          ),
        ],
      );

      expect(() => product.bestAvailablePrice, throwsStateError);
    });
  });

  group('Getter pricesForDisplay returns the correct value', () {
    test('returns available offers first and sorted by ascending price', () {
      final ProductSource expensive = buildProductSource(
        id: 'source-expensive',
        currentPrice: buildMoney(minorUnits: 60000),
        isAvailable: true,
      );
      final ProductSource unavailable = buildProductSource(
        id: 'source-unavailable',
        currentPrice: buildMoney(minorUnits: 10000),
        isAvailable: false,
      );
      final ProductSource cheapest = buildProductSource(
        id: 'source-cheapest',
        currentPrice: buildMoney(minorUnits: 40000),
        isAvailable: true,
      );
      final Product product = buildProduct(
        sources: [expensive, unavailable, cheapest],
      );

      expect(product.pricesForDisplay, [cheapest, expensive, unavailable]);
      expect(product.sources, [expensive, unavailable, cheapest]);
    });

    test('excludes a source with no offer fetched yet', () {
      final ProductSource cheapest = buildProductSource(
        id: 'source-cheapest',
        currentPrice: buildMoney(minorUnits: 40000),
        isAvailable: true,
      );
      final ProductSource notCheckedYet = buildProductSource(
        id: 'source-unchecked',
      );
      final Product product = buildProduct(
        sources: [cheapest, notCheckedYet],
      );

      expect(product.pricesForDisplay, [cheapest]);
    });

    test('treats a priced offer with isAvailable == null as unavailable', () {
      final ProductSource unknownAvailability = buildProductSource(
        id: 'source-unknown',
        currentPrice: buildMoney(minorUnits: 40000),
      );
      final Product product = buildProduct(sources: [unknownAvailability]);

      expect(product.pricesForDisplay, [unknownAvailability]);
    });

    test('sorts the unavailable bucket by ascending price', () {
      final ProductSource expensiveUnavailable = buildProductSource(
        id: 'source-expensive-unavailable',
        currentPrice: buildMoney(minorUnits: 60000),
        isAvailable: false,
      );
      final ProductSource cheapUnavailable = buildProductSource(
        id: 'source-cheap-unavailable',
        currentPrice: buildMoney(minorUnits: 20000),
        isAvailable: false,
      );
      final Product product = buildProduct(
        sources: [expensiveUnavailable, cheapUnavailable],
      );

      expect(product.pricesForDisplay, [
        cheapUnavailable,
        expensiveUnavailable,
      ]);
    });

    test('rejects offers with different currencies', () {
      final Product product = buildProduct(
        sources: [
          buildProductSource(
            id: 'source-usd',
            currentPrice: buildMoney(currencyCode: 'USD'),
            isAvailable: true,
          ),
          buildProductSource(
            id: 'source-eur',
            currentPrice: buildMoney(currencyCode: 'EUR'),
            isAvailable: false,
          ),
        ],
      );

      expect(() => product.pricesForDisplay, throwsStateError);
    });
  });
}
