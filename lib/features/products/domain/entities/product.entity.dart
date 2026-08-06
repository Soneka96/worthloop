// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';

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

  const Product({
    required this.id,
    required this.name,
    required this.sources,
    required this.lastUpdatedAt,
    this.imageUrl,
  });

  /// Priced, in-stock sources ordered from lowest to highest price.
  List<ProductSource> get availablePricesSorted {
    _ensureSingleCurrency();
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
    return prices.isEmpty ? null : prices.first;
  }

  /// Sources ordered by availability, price, and merchant identity.
  List<ProductSource> get pricesForDisplay {
    _ensureSingleCurrency();
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
      final int priceComparison = (first.currentPrice?.minorUnits ?? 0)
          .compareTo(second.currentPrice?.minorUnits ?? 0);
      if (priceComparison != 0) {
        return priceComparison;
      }
      final int merchantComparison = first.merchantDomain.compareTo(
        second.merchantDomain,
      );
      return merchantComparison != 0
          ? merchantComparison
          : first.id.compareTo(second.id);
    });
  }

  void _ensureSingleCurrency() {
    final Set<String> currencyCodes = sources
        .map((ProductSource source) => source.currentPrice?.currencyCode)
        .whereType<String>()
        .toSet();
    if (currencyCodes.length > 1) {
      throw StateError('Product offers must use one currency');
    }
  }

  @override
  List<Object?> get props => [id, name, imageUrl, sources, lastUpdatedAt];
}
