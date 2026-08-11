// Package imports:
import 'package:drift/drift.dart' show Value;

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';

/// Builds a [ProductTableCompanion] with overridable values.
ProductTableCompanion buildProductTableCompanion({
  String id = 'product-1',
  String name = 'Example Product',
  String? imageUrl,
  DateTime? lastUpdatedAt,
}) => ProductTableCompanion.insert(
  id: id,
  name: name,
  imageUrl: imageUrl == null ? const Value.absent() : Value(imageUrl),
  lastUpdatedAt: lastUpdatedAt ?? DateTime(2026, 1, 1, 12),
);
