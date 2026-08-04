// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:worth_loop/features/products/data/models/drift_schemas/product.table.dart';

/// Persisted website links used to track products.
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

  /// When the source was added.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
