// Package imports:
import 'package:drift/drift.dart';

/// Persisted tracked products.
@DataClassName('ProductRow')
class ProductTable extends Table {
  /// Stable product identifier.
  TextColumn get id => text()();

  /// Product display name.
  TextColumn get name => text()();

  /// Optional product image URL.
  TextColumn get imageUrl => text().nullable()();

  /// When any offer for the product was last updated.
  DateTimeColumn get lastUpdatedAt => dateTime()();

  /// Previous best price in the currency's minor unit.
  IntColumn get previousBestPriceMinorUnits => integer().nullable()();

  /// ISO 4217 currency code for the previous best price.
  TextColumn get previousBestPriceCurrencyCode => text().nullable()();

  /// When the product's best price last changed.
  DateTimeColumn get bestPriceChangedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
