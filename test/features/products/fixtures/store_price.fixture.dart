// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

import 'money.fixture.dart';

/// Builds a [StorePrice] with overridable values.
StorePrice buildStorePrice({
  String storeName = 'Example Store',
  String productUrl = 'https://example.com/product',
  Money? currentPrice,
  bool isAvailable = true,
  DateTime? lastCheckedAt,
}) => StorePrice(
  storeName: storeName,
  productUrl: productUrl,
  currentPrice: currentPrice ?? buildMoney(),
  isAvailable: isAvailable,
  lastCheckedAt: lastCheckedAt ?? DateTime(2026, 1, 1, 12),
);
