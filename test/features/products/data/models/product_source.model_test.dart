// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';

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

    test('fromRow() maps every persisted field', () {
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
    });

    test('toCompanion() maps every model field', () {
      final ProductSourceModel model = ProductSourceModel(
        id: 'source-1',
        productId: 'product-1',
        url: 'https://example.com/products/1',
        merchantDomain: 'example.com',
        createdAt: DateTime(2026, 1, 1),
      );

      final ProductSourceTableCompanion companion = model.toCompanion();

      expect(companion.id.value, 'source-1');
      expect(companion.productId.value, 'product-1');
      expect(companion.url.value, 'https://example.com/products/1');
      expect(companion.merchantDomain.value, 'example.com');
      expect(companion.createdAt.value, DateTime(2026, 1, 1));
    });
  });
}
