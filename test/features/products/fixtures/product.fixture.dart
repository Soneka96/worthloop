// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';

/// Builds a [Product] with overridable values.
Product buildProduct({
  String id = 'product-1',
  String name = 'Example Product',
  String? imageUrl = 'https://example.com/product.png',
  List<StorePrice> storePrices = const [],
  DateTime? lastUpdatedAt,
}) => Product(
  id: id,
  name: name,
  imageUrl: imageUrl,
  storePrices: storePrices,
  lastUpdatedAt: lastUpdatedAt ?? DateTime(2026, 1, 1, 12),
);
