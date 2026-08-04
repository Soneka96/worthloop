// Project imports:
import 'package:worth_loop/features/products/data/models/product.model.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Builds the first release's illustrative local product data.
List<ProductModel> buildFakeProducts(DateTime checkedAt) => [
  ProductModel(
    id: 'moza-r12-v2',
    name: 'Moza R12 V2 Wheelbase',
    storePrices: _offers(checkedAt, const {
      'Globaldata': 49999,
      'Simufy': 51999,
      'Amazon ES': 54999,
      'PCComponentes': 52999,
    }, 'moza-r12-v2'),
    lastUpdatedAt: checkedAt,
  ),
  ProductModel(
    id: 'nlr-wheel-stand-2',
    name: 'Next Level Racing Wheel Stand 2.0',
    storePrices: _offers(checkedAt, const {
      'Globaldata': 22999,
      'Amazon ES': 24999,
      'PCComponentes': 23999,
    }, 'nlr-wheel-stand-2'),
    lastUpdatedAt: checkedAt,
  ),
];

List<StorePriceModel> _offers(
  DateTime checkedAt,
  Map<String, int> prices,
  String productId,
) => prices.entries
    .map(
      (entry) => StorePriceModel(
        storeName: entry.key,
        productUrl: 'https://example.com/$productId/${entry.key}',
        currentPrice: Money(minorUnits: entry.value, currencyCode: 'EUR'),
        isAvailable: true,
        lastCheckedAt: checkedAt,
      ),
    )
    .toList(growable: false);
