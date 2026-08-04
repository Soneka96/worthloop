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

  @override
  Set<Column> get primaryKey => {id};
}
