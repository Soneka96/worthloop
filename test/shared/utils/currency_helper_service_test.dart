import 'package:flutter_test/flutter_test.dart';

import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/utils/currency_helper_service.dart';

void main() {
  group('CurrencyHelperService behaves correctly', () {
    test('uses USD by default', () {
      expect(CurrencyHelperService.defaultCurrencyCode, 'USD');
    });

    test('accepts prices in one currency', () {
      const CurrencyHelperService service = CurrencyHelperService();

      expect(
        () => service.validate([
          const Money(minorUnits: 100, currencyCode: 'EUR'),
          const Money(minorUnits: 200, currencyCode: 'EUR'),
        ]),
        returnsNormally,
      );
    });

    test('rejects prices in different currencies', () {
      const CurrencyHelperService service = CurrencyHelperService();

      expect(
        () => service.validate([
          const Money(minorUnits: 100, currencyCode: 'USD'),
          const Money(minorUnits: 200, currencyCode: 'EUR'),
        ]),
        throwsStateError,
      );
    });
  });
}
