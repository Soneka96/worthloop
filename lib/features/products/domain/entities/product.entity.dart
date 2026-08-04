// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';

/// An item whose merchant offers are tracked.
@immutable
class Product extends Equatable {
  /// Stable product identifier.
  final String id;

  /// Product display name.
  final String name;

  /// Optional product image URL.
  final String? imageUrl;

  /// Latest known merchant offers.
  final List<StorePrice> storePrices;

  /// When any offer for this product was last updated.
  final DateTime lastUpdatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.storePrices,
    required this.lastUpdatedAt,
    this.imageUrl,
  });

  /// Available offers ordered from lowest to highest price.
  List<StorePrice> get availablePricesSorted {
    _ensureSingleCurrency();
    final List<StorePrice> available = storePrices
        .where((StorePrice price) => price.isAvailable)
        .toList(growable: false);
    _sortByPrice(available);
    return available;
  }

  /// Lowest available offer, or `null` when no store has stock.
  StorePrice? get bestAvailablePrice {
    final List<StorePrice> prices = availablePricesSorted;
    return prices.isEmpty ? null : prices.first;
  }

  /// Offers ordered by availability and then by ascending price.
  List<StorePrice> get pricesForDisplay {
    _ensureSingleCurrency();
    final List<StorePrice> unavailable = storePrices
        .where((StorePrice price) => !price.isAvailable)
        .toList(growable: false);
    _sortByPrice(unavailable);
    return [...availablePricesSorted, ...unavailable];
  }

  void _sortByPrice(List<StorePrice> prices) {
    prices.sort(
      (StorePrice first, StorePrice second) => first.currentPrice.minorUnits
          .compareTo(second.currentPrice.minorUnits),
    );
  }

  void _ensureSingleCurrency() {
    final Set<String> currencyCodes = storePrices
        .map((StorePrice price) => price.currentPrice.currencyCode)
        .toSet();
    if (currencyCodes.length > 1) {
      throw StateError('Product offers must use one currency');
    }
  }

  @override
  List<Object?> get props => [id, name, imageUrl, storePrices, lastUpdatedAt];
}
