// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// Drift-backed model for the domain [Product] entity.
class ProductModel extends Product {
  /// Creates a persisted product representation.
  const ProductModel({
    required super.id,
    required super.name,
    required super.storePrices,
    required super.lastUpdatedAt,
    super.imageUrl,
  });

  /// Builds a [ProductModel] from a product row and its offer rows.
  factory ProductModel.fromRows(
    ProductRow product,
    List<StorePriceRow> prices,
  ) => ProductModel(
    id: product.id,
    name: product.name,
    imageUrl: product.imageUrl,
    storePrices: prices.map(StorePriceModel.fromRow).toList(growable: false),
    lastUpdatedAt: product.lastUpdatedAt,
  );

  /// Encodes this product as a drift companion.
  ProductTableCompanion toCompanion() => ProductTableCompanion.insert(
    id: id,
    name: name,
    imageUrl: Value(imageUrl),
    lastUpdatedAt: lastUpdatedAt,
  );
}
