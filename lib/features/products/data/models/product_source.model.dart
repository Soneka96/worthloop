// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
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
    super.currentPrice,
    super.previousPrice,
    super.isAvailable,
    super.lastCheckedAt,
    super.priceChangedAt,
    super.lastRefreshStatus,
    super.lastRefreshAt,
  });

  /// Copies a domain source into its persisted model type.
  factory ProductSourceModel.fromEntity(ProductSource source) =>
      ProductSourceModel(
        id: source.id,
        productId: source.productId,
        url: source.url,
        merchantDomain: source.merchantDomain,
        createdAt: source.createdAt,
        currentPrice: source.currentPrice,
        previousPrice: source.previousPrice,
        isAvailable: source.isAvailable,
        lastCheckedAt: source.lastCheckedAt,
        priceChangedAt: source.priceChangedAt,
        lastRefreshStatus: source.lastRefreshStatus,
        lastRefreshAt: source.lastRefreshAt,
      );

  /// Builds a [ProductSourceModel] from a persisted source row.
  factory ProductSourceModel.fromRow(ProductSourceRow row) {
    final int? minorUnits = row.minorUnits;
    final String? currencyCode = row.currencyCode;
    final int? previousPriceMinorUnits = row.previousPriceMinorUnits;
    final String? previousPriceCurrencyCode = row.previousPriceCurrencyCode;
    return ProductSourceModel(
      id: row.id,
      productId: row.productId,
      url: row.url,
      merchantDomain: row.merchantDomain,
      createdAt: row.createdAt,
      currentPrice: minorUnits != null && currencyCode != null
          ? Money(minorUnits: minorUnits, currencyCode: currencyCode)
          : null,
      previousPrice:
          previousPriceMinorUnits != null && previousPriceCurrencyCode != null
          ? Money(
              minorUnits: previousPriceMinorUnits,
              currencyCode: previousPriceCurrencyCode,
            )
          : null,
      isAvailable: row.isAvailable,
      lastCheckedAt: row.lastCheckedAt,
      priceChangedAt: row.priceChangedAt,
      lastRefreshStatus: _statusFromName(row.lastRefreshStatus),
      lastRefreshAt: row.lastRefreshAt,
    );
  }

  /// Encodes this source as a drift companion.
  ProductSourceTableCompanion toCompanion() =>
      ProductSourceTableCompanion.insert(
        id: id,
        productId: productId,
        url: url,
        merchantDomain: merchantDomain,
        createdAt: createdAt,
        minorUnits: Value(currentPrice?.minorUnits),
        currencyCode: Value(currentPrice?.currencyCode),
        previousPriceMinorUnits: Value(previousPrice?.minorUnits),
        previousPriceCurrencyCode: Value(previousPrice?.currencyCode),
        isAvailable: Value(isAvailable),
        lastCheckedAt: Value(lastCheckedAt),
        priceChangedAt: Value(priceChangedAt),
        lastRefreshStatus: Value(lastRefreshStatus?.name),
        lastRefreshAt: Value(lastRefreshAt),
      );

  static PriceFetchStatus? _statusFromName(String? name) {
    for (final PriceFetchStatus status in PriceFetchStatus.values) {
      if (status.name == name) {
        return status;
      }
    }
    return null;
  }
}
