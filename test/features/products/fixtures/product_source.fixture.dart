// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';

/// Builds a [ProductSource] with overridable values.
ProductSource buildProductSource({
  String id = 'source-1',
  String productId = 'product-1',
  String url = 'https://example.com/products/1',
  DateTime? createdAt,
}) => ProductSource.fromUrl(
  id: id,
  productId: productId,
  url: url,
  createdAt: createdAt ?? DateTime(2026, 1, 1, 12),
);
