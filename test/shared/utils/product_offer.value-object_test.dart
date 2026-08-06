// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';
import '../fixtures/product_offer.fixture.dart';

void main() {
  group('ProductOffer equality', () {
    test('includes the minor units, currency code and availability', () {
      final ProductOffer offer = buildProductOffer();

      expect(offer.props, <Object?>[4999, 'EUR', true]);
      expect(offer, buildProductOffer());
      expect(offer, isNot(buildProductOffer(minorUnits: 5000)));
      expect(offer, isNot(buildProductOffer(currencyCode: 'USD')));
      expect(offer, isNot(buildProductOffer(isAvailable: false)));
    });
  });
}
