// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/currency_converter.value-object.dart';
import 'package:worth_loop/features/products/presentation/utils/price_formatter.dart';
import '../../fixtures/money.fixture.dart';

void main() {
  group('Method formatPrice() returns a String instance', () {
    test('formatPrice() returns the euro symbol when currencyCode = EUR', () {
      final String formatted = formatPrice(
        buildMoney(minorUnits: 49999, currencyCode: 'EUR'),
      );

      expect(formatted, isA<String>());
      expect(formatted, '499.99 €');
    });

    test('formatPrice() converts USD to EUR by default', () {
      final String formatted = formatPrice(
        buildMoney(minorUnits: 49999, currencyCode: 'USD'),
      );
      final String equivalentEuro = formatPrice(
        buildMoney(minorUnits: 45999, currencyCode: 'EUR'),
      );

      expect(formatted, isA<String>());
      expect(formatted, equivalentEuro);
    });

    test('formatPrice() converts zero-decimal currencies to EUR', () {
      final String formatted = formatPrice(
        buildMoney(minorUnits: 1000, currencyCode: 'JPY'),
      );
      final String equivalentEuro = formatPrice(
        buildMoney(minorUnits: 620, currencyCode: 'EUR'),
      );

      expect(formatted, equivalentEuro);
    });

    test('formatPrice() keeps an unsupported currency visible', () {
      final String formatted = formatPrice(
        buildMoney(minorUnits: 49999, currencyCode: 'XYZ'),
      );

      expect(formatted, '499.99 XYZ');
    });

    test('formatPrice() uses a known scale for an unconvertible currency', () {
      const CurrencyConverter converter = CurrencyConverter(
        ratesToEuro: {'EUR': 1.0},
        minorUnitsPerUnit: {'EUR': 100, 'JPY': 1},
      );

      final String formatted = formatPrice(
        buildMoney(minorUnits: 1000, currencyCode: 'JPY'),
        converter: converter,
      );

      expect(formatted, '1000 JPY');
    });
  });
}
