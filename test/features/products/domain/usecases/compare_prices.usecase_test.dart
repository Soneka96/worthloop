// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/compare_prices.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/compare_prices.params.dart';
import '../../fixtures/money.fixture.dart';
import '../../fixtures/product.fixture.dart';
import '../../fixtures/product_source.fixture.dart';

void main() {
  group('Usecase ComparePricesUseCase returns the correct value', () {
    test('returns available prices sorted ascending', () async {
      final ProductSource expensive = buildProductSource(
        id: 'source-expensive',
        currentPrice: buildMoney(minorUnits: 59999),
        isAvailable: true,
      );
      final ProductSource unavailable = buildProductSource(
        id: 'source-unavailable',
        currentPrice: buildMoney(minorUnits: 39999),
        isAvailable: false,
      );
      final ProductSource cheapest = buildProductSource(
        id: 'source-cheapest',
        currentPrice: buildMoney(minorUnits: 49999),
        isAvailable: true,
      );
      final ComparePricesParams params = ComparePricesParams(
        product: buildProduct(sources: [expensive, unavailable, cheapest]),
      );

      final List<ProductSource> result = await ComparePricesUseCase()(params);

      expect(result, <ProductSource>[cheapest, expensive]);
      expect(params.product.sources, <ProductSource>[
        expensive,
        unavailable,
        cheapest,
      ]);
    });

    test('returns an empty list when no price is available', () async {
      final ComparePricesParams params = ComparePricesParams(
        product: buildProduct(
          sources: [
            buildProductSource(currentPrice: buildMoney(), isAvailable: false),
          ],
        ),
      );

      final List<ProductSource> result = await ComparePricesUseCase()(params);

      expect(result, isEmpty);
    });

    test('returns an empty list when the product has no sources', () async {
      final ComparePricesParams params = ComparePricesParams(
        product: buildProduct(sources: const []),
      );

      final List<ProductSource> result = await ComparePricesUseCase()(params);

      expect(result, isEmpty);
    });
  });
}
