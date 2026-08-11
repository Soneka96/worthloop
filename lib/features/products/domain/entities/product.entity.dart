// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/currency_converter.value-object.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// An item whose merchant offers are tracked.
@immutable
class Product extends Equatable {
  /// Stable product identifier.
  final String id;

  /// Product display name.
  final String name;

  /// Optional product image URL.
  final String? imageUrl;

  /// Tracked website sources and their latest known offers.
  final List<ProductSource> sources;

  /// When any offer for this product was last updated.
  final DateTime lastUpdatedAt;

  /// Best price immediately before the latest best-price change, or `null` if none.
  final Money? previousBestPrice;

  /// When the product's best price last changed, or `null` if it has not changed.
  final DateTime? bestPriceChangedAt;

  const Product({
    required this.id,
    required this.name,
    required this.sources,
    required this.lastUpdatedAt,
    this.previousBestPrice,
    this.bestPriceChangedAt,
    this.imageUrl,
  });

  /// Converts prices with the default display currency for comparison.
  static const CurrencyConverter _currencyConverter = CurrencyConverter();

  /// Priced, in-stock sources ordered from lowest to highest converted price.
  List<ProductSource> get availablePricesSorted {
    final List<ProductSource> available = sources
        .where(
          (ProductSource source) =>
              source.isAvailable == true && source.currentPrice != null,
        )
        .toList(growable: false);
    _sortByPrice(available);
    return available;
  }

  /// Lowest-priced in-stock source, or `null` when none is available.
  ProductSource? get bestAvailablePrice {
    final List<ProductSource> prices = availablePricesSorted;
    if (prices.isEmpty) {
      return null;
    }
    return _comparablePrice(prices.first) == null ? null : prices.first;
  }

  /// Sources ordered by availability, converted price, and merchant identity.
  List<ProductSource> get pricesForDisplay {
    final List<ProductSource> unavailable = sources
        .where(
          (ProductSource source) =>
              source.isAvailable != true && source.currentPrice != null,
        )
        .toList(growable: false);
    final List<ProductSource> unpriced = sources
        .where((ProductSource source) => source.currentPrice == null)
        .toList(growable: false);
    _sortByPrice(unavailable);
    return [...availablePricesSorted, ...unavailable, ...unpriced];
  }

  void _sortByPrice(List<ProductSource> entries) {
    entries.sort((ProductSource first, ProductSource second) {
      final Money? firstPrice = _comparablePrice(first);
      final Money? secondPrice = _comparablePrice(second);
      if (firstPrice == null || secondPrice == null) {
        if (firstPrice != null) {
          return -1;
        }
        if (secondPrice != null) {
          return 1;
        }
      } else {
        final int priceComparison = firstPrice.minorUnits.compareTo(
          secondPrice.minorUnits,
        );
        if (priceComparison != 0) {
          return priceComparison;
        }
      }
      final int merchantComparison = first.merchantDomain.compareTo(
        second.merchantDomain,
      );
      return merchantComparison != 0
          ? merchantComparison
          : first.id.compareTo(second.id);
    });
  }

  Money? _comparablePrice(ProductSource source) {
    final Money? price = source.currentPrice;
    return price == null ? null : _currencyConverter.convert(price);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    sources,
    lastUpdatedAt,
    previousBestPrice,
    bestPriceChangedAt,
  ];
}
