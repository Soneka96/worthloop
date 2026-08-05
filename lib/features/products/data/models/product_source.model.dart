// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// Drift-backed model for the domain [ProductSource] entity.
class ProductSourceModel extends ProductSource {
  /// Creates a persisted product-source representation.
  const ProductSourceModel({
    required super.id,
    required super.productId,
    required super.url,
    required super.merchantDomain,
    required super.createdAt,
  });

  /// Copies a domain source into its persisted model type.
  factory ProductSourceModel.fromEntity(ProductSource source) =>
      ProductSourceModel(
        id: source.id,
        productId: source.productId,
        url: source.url,
        merchantDomain: source.merchantDomain,
        createdAt: source.createdAt,
      );

  /// Builds a [ProductSourceModel] from a persisted source row.
  factory ProductSourceModel.fromRow(ProductSourceRow row) =>
      ProductSourceModel(
        id: row.id,
        productId: row.productId,
        url: row.url,
        merchantDomain: row.merchantDomain,
        createdAt: row.createdAt,
      );

  /// Encodes this source as a drift companion.
  ProductSourceTableCompanion toCompanion() =>
      ProductSourceTableCompanion.insert(
        id: id,
        productId: productId,
        url: url,
        merchantDomain: merchantDomain,
        createdAt: createdAt,
      );
}
