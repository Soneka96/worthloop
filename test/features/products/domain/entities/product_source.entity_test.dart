// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';

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
    test('includes every source field', () {
      final DateTime createdAt = DateTime(2026, 1, 1);
      final ProductSource source = ProductSource(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        merchantDomain: 'example.com',
        createdAt: createdAt,
      );

      expect(
        source,
        ProductSource(
          id: 'source-1',
          productId: 'product-1',
          url: 'https://example.com/products/1',
          merchantDomain: 'example.com',
          createdAt: createdAt,
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
            createdAt: DateTime(2026, 1, 2),
          ),
        ),
      );
    });
  });
}
