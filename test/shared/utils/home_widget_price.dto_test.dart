// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/home_widget_price.dto.dart';

void main() {
  group('HomeWidgetPriceDto equality', () {
    test('includes every widget price field', () {
      final DateTime updatedAt = DateTime(2026, 1, 1, 22, 30);
      final HomeWidgetPriceDto first = HomeWidgetPriceDto(
        productId: 'product-1',
        productName: 'Example Product',
        minorUnits: 49999,
        currencyCode: 'EUR',
        storeName: 'Example Store',
        updatedAt: updatedAt,
      );
      final HomeWidgetPriceDto second = HomeWidgetPriceDto(
        productId: 'product-1',
        productName: 'Example Product',
        minorUnits: 49999,
        currencyCode: 'EUR',
        storeName: 'Example Store',
        updatedAt: updatedAt,
      );

      expect(first, second);
      expect(first.props, [
        'product-1',
        'Example Product',
        49999,
        'EUR',
        'Example Store',
        updatedAt,
      ]);
    });
  });
}
