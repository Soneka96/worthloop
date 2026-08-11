// Package imports:
import 'package:drift/drift.dart' show Value;

// Project imports:
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Builds a [ProductSourceTableCompanion] with overridable values.
ProductSourceTableCompanion buildProductSourceTableCompanion({
  String id = 'source-1',
  String productId = 'product-1',
  String url = 'https://example.com/products/1',
  String merchantDomain = 'example.com',
  int? minorUnits,
  String? currencyCode,
  bool? isAvailable,
  DateTime? lastCheckedAt,
  DateTime? createdAt,
  PriceFetchStatus? lastRefreshStatus,
  DateTime? lastRefreshAt,
}) => ProductSourceTableCompanion.insert(
  id: id,
  productId: productId,
  url: url,
  merchantDomain: merchantDomain,
  minorUnits: Value(minorUnits),
  currencyCode: Value(currencyCode),
  isAvailable: Value(isAvailable),
  lastCheckedAt: Value(lastCheckedAt),
  createdAt: createdAt ?? DateTime(2026, 1, 1, 12),
  lastRefreshStatus: Value(lastRefreshStatus?.name),
  lastRefreshAt: Value(lastRefreshAt),
);
