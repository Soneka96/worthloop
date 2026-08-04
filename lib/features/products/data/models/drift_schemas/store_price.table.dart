// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/drift_schemas/product.table.dart';

/// Persisted merchant offers for tracked products.
@DataClassName('StorePriceRow')
class StorePriceTable extends Table {
  /// Product this offer belongs to.
  TextColumn get productId =>
      text().references(ProductTable, #id, onDelete: KeyAction.cascade)();

  /// Merchant display name.
  TextColumn get storeName => text()();

  /// Merchant product-page URL.
  TextColumn get productUrl => text()();

  /// Exact price in the currency's minor unit.
  IntColumn get minorUnits => integer()();

  /// ISO 4217 currency code.
  TextColumn get currencyCode => text()();

  /// Whether the product is currently available.
  BoolColumn get isAvailable => boolean()();

  /// When this offer was last checked.
  DateTimeColumn get lastCheckedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {productId, storeName};
}
