// Project imports:
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'money.fixture.dart';

/// Builds a [StorePriceModel] with overridable values.
StorePriceModel buildStorePriceModel({
  String storeName = 'Example Store',
  String productUrl = 'https://example.com/product',
  Money? currentPrice,
  bool isAvailable = true,
  DateTime? lastCheckedAt,
}) => StorePriceModel(
  storeName: storeName,
  productUrl: productUrl,
  currentPrice: currentPrice ?? buildMoney(),
  isAvailable: isAvailable,
  lastCheckedAt: lastCheckedAt ?? DateTime(2026, 1, 1, 12),
);
