// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
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

    test(
      'formatPrice() returns the currency code when currencyCode != EUR',
      () {
        final String formatted = formatPrice(
          buildMoney(minorUnits: 49999, currencyCode: 'USD'),
        );

        expect(formatted, isA<String>());
        expect(formatted, '499.99 USD');
      },
    );
  });
}
