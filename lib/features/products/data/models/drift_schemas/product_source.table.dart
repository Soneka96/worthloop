// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/drift_schemas/product.table.dart';

/// Persisted website links tracked for products, together with each one's
/// latest fetched offer.
@DataClassName('ProductSourceRow')
class ProductSourceTable extends Table {
  /// Stable source identifier.
  TextColumn get id => text()();

  /// Product this source belongs to.
  TextColumn get productId =>
      text().references(ProductTable, #id, onDelete: KeyAction.cascade)();

  /// Website link supplied for the product.
  TextColumn get url => text()();

  /// Lower-case merchant domain extracted from [url].
  TextColumn get merchantDomain => text()();

  /// Exact price in the currency's minor unit, once an offer is fetched.
  IntColumn get minorUnits => integer().nullable()();

  /// ISO 4217 currency code, once an offer is fetched.
  TextColumn get currencyCode => text().nullable()();

  /// Whether the merchant currently has the product available, once an
  /// offer is fetched.
  BoolColumn get isAvailable => boolean().nullable()();

  /// When this source's offer was last checked, once fetched.
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();

  /// When the source was added.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {productId, url},
  ];
}
