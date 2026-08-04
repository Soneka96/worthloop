// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// Drift-backed model for the domain [StorePrice] entity.
class StorePriceModel extends StorePrice {
  /// Creates a persisted merchant offer representation.
  const StorePriceModel({
    required super.storeName,
    required super.productUrl,
    required super.currentPrice,
    required super.isAvailable,
    required super.lastCheckedAt,
  });

  /// Builds a [StorePriceModel] from a persisted offer row.
  factory StorePriceModel.fromRow(StorePriceRow row) => StorePriceModel(
    storeName: row.storeName,
    productUrl: row.productUrl,
    currentPrice: Money(
      minorUnits: row.minorUnits,
      currencyCode: row.currencyCode,
    ),
    isAvailable: row.isAvailable,
    lastCheckedAt: row.lastCheckedAt,
  );

  /// Encodes this offer for [productId] as a drift companion.
  StorePriceTableCompanion toCompanion(String productId) =>
      StorePriceTableCompanion.insert(
        productId: productId,
        storeName: storeName,
        productUrl: productUrl,
        minorUnits: currentPrice.minorUnits,
        currencyCode: currentPrice.currencyCode,
        isAvailable: isAvailable,
        lastCheckedAt: lastCheckedAt,
      );
}
