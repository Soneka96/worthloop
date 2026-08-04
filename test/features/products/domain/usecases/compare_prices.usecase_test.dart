// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/compare_prices.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/compare_prices.params.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/store_price.fixture.dart';

void main() {
  group('Usecase ComparePricesUseCase returns the correct value', () {
    test('returns available prices sorted ascending', () async {
      final StorePrice expensive = buildStorePrice(
        storeName: 'Expensive Store',
        currentPrice: buildMoney(minorUnits: 59999),
      );
      final StorePrice unavailable = buildStorePrice(
        storeName: 'Unavailable Store',
        currentPrice: buildMoney(minorUnits: 39999),
        isAvailable: false,
      );
      final StorePrice cheapest = buildStorePrice(
        storeName: 'Cheapest Store',
        currentPrice: buildMoney(minorUnits: 49999),
      );
      final ComparePricesParams params = ComparePricesParams(
        product: buildProduct(storePrices: [expensive, unavailable, cheapest]),
      );

      final List<StorePrice> result = await ComparePricesUseCase()(params);

      expect(result, <StorePrice>[cheapest, expensive]);
      expect(params.product.storePrices, <StorePrice>[
        expensive,
        unavailable,
        cheapest,
      ]);
    });

    test('returns an empty list when no price is available', () async {
      final ComparePricesParams params = ComparePricesParams(
        product: buildProduct(
          storePrices: [buildStorePrice(isAvailable: false)],
        ),
      );

      final List<StorePrice> result = await ComparePricesUseCase()(params);

      expect(result, isEmpty);
    });

    test(
      'returns an empty list when the product has no store prices',
      () async {
        final ComparePricesParams params = ComparePricesParams(
          product: buildProduct(storePrices: const []),
        );

        final List<StorePrice> result = await ComparePricesUseCase()(params);

        expect(result, isEmpty);
      },
    );
  });
}
