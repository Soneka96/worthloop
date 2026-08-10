// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// A website link tracked for a product, together with its latest fetched
/// offer.
@immutable
class ProductSource extends Equatable {
  /// Stable source identifier.
  final String id;

  /// Identifier of the product tracked by this source.
  final String productId;

  /// Website link supplied for the product.
  final String url;

  /// Lower-case merchant domain extracted from [url].
  final String merchantDomain;

  /// When the source was added.
  final DateTime createdAt;

  /// Latest checked price, or `null` before the first successful fetch.
  final Money? currentPrice;

  /// Price immediately before the latest price change, or `null` if none.
  final Money? previousPrice;

  /// Whether the merchant currently has the product available, or `null`
  /// before the first successful fetch.
  final bool? isAvailable;

  /// When this source's offer was last checked, or `null` before the first
  /// successful fetch.
  final DateTime? lastCheckedAt;

  /// When this source's price last changed, or `null` if it has not changed.
  final DateTime? priceChangedAt;

  /// The outcome of the most recently completed refresh attempt.
  final PriceFetchStatus? lastRefreshStatus;

  /// When the most recently completed refresh attempt finished.
  final DateTime? lastRefreshAt;

  /// Live progress of a refresh currently in flight; null when none is.
  final SourceRefreshStatus? liveStatus;

  const ProductSource({
    required this.id,
    required this.productId,
    required this.url,
    required this.merchantDomain,
    required this.createdAt,
    this.currentPrice,
    this.previousPrice,
    this.isAvailable,
    this.lastCheckedAt,
    this.priceChangedAt,
    this.lastRefreshStatus,
    this.lastRefreshAt,
    this.liveStatus,
  });

  /// Creates a source from a validated HTTPS product URL, with no offer yet.
  factory ProductSource.fromUrl({
    required String id,
    required String productId,
    required String url,
    required DateTime createdAt,
  }) {
    final String normalizedUrl = url.trim();
    final Uri? parsedUrl = Uri.tryParse(normalizedUrl);
    if (parsedUrl == null ||
        parsedUrl.scheme != 'https' ||
        parsedUrl.host.isEmpty) {
      throw ArgumentError.value(url, 'url', 'Must be a valid HTTPS URL');
    }

    return ProductSource(
      id: id,
      productId: productId,
      url: normalizedUrl,
      merchantDomain: parsedUrl.host.toLowerCase(),
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    url,
    merchantDomain,
    createdAt,
    currentPrice,
    previousPrice,
    isAvailable,
    lastCheckedAt,
    priceChangedAt,
    lastRefreshStatus,
    lastRefreshAt,
    liveStatus,
  ];
}
