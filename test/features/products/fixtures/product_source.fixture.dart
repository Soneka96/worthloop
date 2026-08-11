// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';

/// Builds a [ProductSource] with overridable values.
ProductSource buildProductSource({
  String id = 'source-1',
  String productId = 'product-1',
  String url = 'https://example.com/products/1',
  String merchantDomain = 'example.com',
  DateTime? createdAt,
  Money? currentPrice,
  Money? previousPrice,
  bool? isAvailable,
  DateTime? lastCheckedAt,
  DateTime? priceChangedAt,
  PriceFetchStatus? lastRefreshStatus,
  DateTime? lastRefreshAt,
  SourceRefreshStatus? liveStatus,
}) => ProductSource(
  id: id,
  productId: productId,
  url: url,
  merchantDomain: merchantDomain,
  createdAt: createdAt ?? DateTime(2026, 1, 1, 12),
  currentPrice: currentPrice,
  previousPrice: previousPrice,
  isAvailable: isAvailable,
  lastCheckedAt: lastCheckedAt,
  priceChangedAt: priceChangedAt,
  lastRefreshStatus: lastRefreshStatus,
  lastRefreshAt: lastRefreshAt,
  liveStatus: liveStatus,
);
