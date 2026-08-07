// Project imports:
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Builds a [ProductModel] with overridable values.
ProductModel buildProductModel({
  String id = 'product-1',
  String name = 'Example Product',
  String? imageUrl = 'https://example.com/product.png',
  List<ProductSource> sources = const [],
  DateTime? lastUpdatedAt,
  Money? previousBestPrice,
  DateTime? bestPriceChangedAt,
}) => ProductModel(
  id: id,
  name: name,
  imageUrl: imageUrl,
  sources: sources,
  lastUpdatedAt: lastUpdatedAt ?? DateTime(2026, 1, 1, 12),
  previousBestPrice: previousBestPrice,
  bestPriceChangedAt: bestPriceChangedAt,
);
