// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';

/// Builds a [Product] with overridable values.
Product buildProduct({
  String id = 'product-1',
  String name = 'Example Product',
  String? imageUrl = 'https://example.com/product.png',
  List<ProductSource> sources = const [],
  DateTime? lastUpdatedAt,
}) => Product(
  id: id,
  name: name,
  imageUrl: imageUrl,
  sources: sources,
  lastUpdatedAt: lastUpdatedAt ?? DateTime(2026, 1, 1, 12),
);
