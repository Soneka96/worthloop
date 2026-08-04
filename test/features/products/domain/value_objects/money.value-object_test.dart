// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import '../../fixtures/money.fixture.dart';

void main() {
  group('Money equality', () {
    test('includes the minor units and currency code', () {
      final Money money = buildMoney();

      expect(money.props, <Object?>[49999, 'EUR']);
      expect(money, buildMoney());
      expect(money, isNot(buildMoney(minorUnits: 50000)));
      expect(money, isNot(buildMoney(currencyCode: 'USD')));
    });
  });
}
