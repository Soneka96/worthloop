// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/currency_converter.value-object.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

void main() {
  group('CurrencyConverter behaves correctly', () {
    test('uses EUR as the default currency', () {
      expect(CurrencyConverter.defaultCurrencyCode, isA<String>());
      expect(CurrencyConverter.defaultCurrencyCode, 'EUR');
    });

    test('returns the configured minor-unit scale case-insensitively', () {
      const CurrencyConverter converter = CurrencyConverter();

      expect(converter.minorUnitScaleFor(' jpy '), 1);
    });

    test('returns null for an unknown minor-unit scale', () {
      const CurrencyConverter converter = CurrencyConverter();

      expect(converter.minorUnitScaleFor('XYZ'), isNull);
    });

    test('converts USD to EUR using the built-in rate', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 10000, currencyCode: 'USD'),
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 9200);
      expect(result?.currencyCode, isA<String>());
      expect(result?.currencyCode, 'EUR');
    });

    test('preserves an amount when source and target currencies match', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 1234, currencyCode: ' eur '),
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 1234);
      expect(result?.currencyCode, isA<String>());
      expect(result?.currencyCode, 'EUR');
    });

    test('converts EUR to USD using the requested target currency', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 10000, currencyCode: 'EUR'),
        targetCurrency: 'USD',
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 10870);
      expect(result?.currencyCode, isA<String>());
      expect(result?.currencyCode, 'USD');
    });

    test('converts currencies with a one-unit minor scale', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 1000, currencyCode: 'JPY'),
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 620);
      expect(result?.currencyCode, isA<String>());
      expect(result?.currencyCode, 'EUR');
    });

    test('converts to a currency with a one-unit minor scale', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 100, currencyCode: 'EUR'),
        targetCurrency: 'JPY',
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 161);
      expect(result?.currencyCode, isA<String>());
      expect(result?.currencyCode, 'JPY');
    });

    test('rounds the converted amount to the target minor unit', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 999, currencyCode: 'GBP'),
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 1169);
    });

    test('rounds an exact half minor unit away from zero', () {
      const CurrencyConverter converter = CurrencyConverter(
        ratesToEuro: {'EUR': 1.0, 'USD': 0.5},
        minorUnitsPerUnit: {'EUR': 100, 'USD': 100},
      );

      final Money? result = converter.convert(
        const Money(minorUnits: 1, currencyCode: 'USD'),
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 1);
    });

    test('uses a supplied rate table', () {
      const CurrencyConverter converter = CurrencyConverter(
        ratesToEuro: {'EUR': 1.0, 'USD': 0.5},
        minorUnitsPerUnit: {'EUR': 100, 'USD': 100},
      );

      final Money? result = converter.convert(
        const Money(minorUnits: 1000, currencyCode: 'USD'),
      );

      expect(result, isA<Money>());
      expect(result?.minorUnits, isA<int>());
      expect(result?.minorUnits, 500);
      expect(result?.currencyCode, isA<String>());
      expect(result?.currencyCode, 'EUR');
    });

    test('returns null for an unsupported source currency', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 1000, currencyCode: 'XYZ'),
      );

      expect(result, isNull);
    });

    test('returns null for an unsupported target currency', () {
      const CurrencyConverter converter = CurrencyConverter();

      final Money? result = converter.convert(
        const Money(minorUnits: 1000, currencyCode: 'EUR'),
        targetCurrency: 'XYZ',
      );

      expect(result, isNull);
    });

    test('returns null when a source rate has no source scale', () {
      const CurrencyConverter converter = CurrencyConverter(
        ratesToEuro: {'EUR': 1.0, 'USD': 0.5},
        minorUnitsPerUnit: {'EUR': 100},
      );

      final Money? result = converter.convert(
        const Money(minorUnits: 1000, currencyCode: 'USD'),
      );

      expect(result, isNull);
    });

    test('returns null when a target rate has no target scale', () {
      const CurrencyConverter converter = CurrencyConverter(
        ratesToEuro: {'EUR': 1.0, 'USD': 0.5},
        minorUnitsPerUnit: {'EUR': 100},
      );

      final Money? result = converter.convert(
        const Money(minorUnits: 1000, currencyCode: 'EUR'),
        targetCurrency: 'USD',
      );

      expect(result, isNull);
    });
  });
}
