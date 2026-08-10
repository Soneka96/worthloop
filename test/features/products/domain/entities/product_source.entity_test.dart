// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../fixtures/money.fixture.dart';

void main() {
  group('ProductSource.fromUrl', () {
    test('normalizes whitespace and extracts the lower-case domain', () {
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: '  HTTPS://Example.COM/products/1  ',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(source.url, 'HTTPS://Example.COM/products/1');
      expect(source.merchantDomain, 'example.com');
      expect(source.id, 'source-1');
      expect(source.productId, 'product-1');
      expect(source.createdAt, DateTime(2026, 1, 1));
    });

    test('creates a source with no offer yet', () {
      final ProductSource source = ProductSource.fromUrl(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(source.currentPrice, isNull);
      expect(source.isAvailable, isNull);
      expect(source.lastCheckedAt, isNull);
      expect(source.liveStatus, isNull);
    });

    test('rejects non-HTTPS URLs', () {
      expect(
        () => ProductSource.fromUrl(
          id: 'source-1',
          productId: 'product-1',
          url: 'http://example.com/products/1',
          createdAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects URLs without a host', () {
      expect(
        () => ProductSource.fromUrl(
          id: 'source-1',
          productId: 'product-1',
          url: 'https:///products/1',
          createdAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects malformed URLs', () {
      expect(
        () => ProductSource.fromUrl(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://[invalid',
          createdAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('ProductSource equality', () {
    test('treats two sources with no offer yet as equal', () {
      final DateTime createdAt = DateTime(2026, 1, 1);

      expect(
        ProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: createdAt,
        ),
        ProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: createdAt,
        ),
      );
    });

    test('includes every source field', () {
      final DateTime createdAt = DateTime(2026, 1, 1);
      final DateTime checkedAt = DateTime(2026, 1, 2);
      final DateTime changedAt = DateTime(2026, 1, 3);
      final DateTime refreshedAt = DateTime(2026, 1, 4);
      final ProductSource source = ProductSource(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        merchantDomain: 'example.com',
        createdAt: createdAt,
        currentPrice: buildMoney(),
        previousPrice: buildMoney(minorUnits: 59999),
        isAvailable: true,
        lastCheckedAt: checkedAt,
        priceChangedAt: changedAt,
        lastRefreshStatus: PriceFetchStatus.success,
        lastRefreshAt: refreshedAt,
        liveStatus: SourceRefreshStatus.fetching,
      );

      expect(source.props, <Object?>[
        'source-1',
        'product-1',
        'https://example.com/products/1',
        'example.com',
        createdAt,
        buildMoney(),
        buildMoney(minorUnits: 59999),
        true,
        checkedAt,
        changedAt,
        PriceFetchStatus.success,
        refreshedAt,
        SourceRefreshStatus.fetching,
      ]);
      expect(
        source,
        ProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: createdAt,
          currentPrice: buildMoney(),
          previousPrice: buildMoney(minorUnits: 59999),
          isAvailable: true,
          lastCheckedAt: checkedAt,
          priceChangedAt: changedAt,
          lastRefreshStatus: PriceFetchStatus.success,
          lastRefreshAt: refreshedAt,
          liveStatus: SourceRefreshStatus.fetching,
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-2',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-2',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/2',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'other.example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: DateTime(2026, 1, 3),
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(minorUnits: 1),
            isAvailable: true,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: false,
            lastCheckedAt: checkedAt,
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: DateTime(2026, 1, 4),
          ),
        ),
      );
      expect(
        source,
        isNot(
          ProductSource(
            id: 'source-1',
            productId: 'product-1',
            url: 'https://example.com/products/1',
            merchantDomain: 'example.com',
            createdAt: createdAt,
            currentPrice: buildMoney(),
            isAvailable: true,
            lastCheckedAt: checkedAt,
            liveStatus: SourceRefreshStatus.queued,
          ),
        ),
      );
    });
  });
}
