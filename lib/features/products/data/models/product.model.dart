// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/product_source.model.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// Drift-backed model for the domain [Product] entity.
class ProductModel extends Product {
  /// Creates a persisted product representation.
  const ProductModel({
    required super.id,
    required super.name,
    required super.sources,
    required super.lastUpdatedAt,
    super.previousBestPrice,
    super.bestPriceChangedAt,
    super.imageUrl,
  });

  /// Builds a [ProductModel] from a product row and its source rows.
  factory ProductModel.fromRows(
    ProductRow product,
    List<ProductSourceRow> sources,
  ) {
    final int? previousBestPriceMinorUnits =
        product.previousBestPriceMinorUnits;
    final String? previousBestPriceCurrencyCode =
        product.previousBestPriceCurrencyCode;
    return ProductModel(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      sources: sources.map(ProductSourceModel.fromRow).toList(growable: false),
      lastUpdatedAt: product.lastUpdatedAt,
      previousBestPrice:
          previousBestPriceMinorUnits != null &&
              previousBestPriceCurrencyCode != null
          ? Money(
              minorUnits: previousBestPriceMinorUnits,
              currencyCode: previousBestPriceCurrencyCode,
            )
          : null,
      bestPriceChangedAt: product.bestPriceChangedAt,
    );
  }

  /// Encodes this product as a drift companion.
  ProductTableCompanion toCompanion() => ProductTableCompanion.insert(
    id: id,
    name: name,
    imageUrl: Value(imageUrl),
    lastUpdatedAt: lastUpdatedAt,
    previousBestPriceMinorUnits: Value(previousBestPrice?.minorUnits),
    previousBestPriceCurrencyCode: Value(previousBestPrice?.currencyCode),
    bestPriceChangedAt: Value(bestPriceChangedAt),
  );
}
