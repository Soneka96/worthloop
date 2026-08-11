// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/utils/price_fetch_result.value-object.dart';
import '../fixtures/price_fetch_result.fixture.dart';
import '../fixtures/product_offer.fixture.dart';

void main() {
  group('PriceFetchResult equality', () {
    test('includes the status and offer', () {
      final PriceFetchResult result = buildPriceFetchResult(
        offer: buildProductOffer(),
      );

      expect(result.props, <Object?>[
        PriceFetchStatus.success,
        buildProductOffer(),
      ]);
      expect(result, buildPriceFetchResult(offer: buildProductOffer()));
      expect(
        result,
        isNot(
          buildPriceFetchResult(
            status: PriceFetchStatus.blocked,
            offer: buildProductOffer(),
          ),
        ),
      );
      expect(
        result,
        isNot(buildPriceFetchResult(offer: buildProductOffer(minorUnits: 1))),
      );
      expect(
        buildPriceFetchResult(status: PriceFetchStatus.blocked, offer: null),
        buildPriceFetchResult(status: PriceFetchStatus.blocked, offer: null),
      );
    });
  });
}
