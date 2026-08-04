// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/home_widget_price.dto.dart';
import 'package:worth_loop/shared/utils/local_home_widget_data_service.dart';

void main() {
  group('LocalHomeWidgetDataService behaves correctly', () {
    late LocalHomeWidgetDataService service;

    setUp(() {
      service = LocalHomeWidgetDataService();
    });

    test('latestFor() returns null when productId is missing', () {
      expect(service.latestFor('missing'), isNull);
    });

    test('expose() makes data available through latestFor()', () {
      final HomeWidgetPriceDto data = _buildData();

      service.expose(data);

      expect(service.latestFor('product-1'), data);
    });

    test('expose() replaces data when productId already exists', () {
      service.expose(_buildData());
      final HomeWidgetPriceDto updated = _buildData(minorUnits: 47999);

      service.expose(updated);

      expect(service.latestFor('product-1'), updated);
    });

    test('expose() preserves data for other product identifiers', () {
      final HomeWidgetPriceDto first = _buildData();
      final HomeWidgetPriceDto second = _buildData(productId: 'product-2');

      service.expose(first);
      service.expose(second);

      expect(service.latestFor('product-1'), first);
      expect(service.latestFor('product-2'), second);
    });
  });
}

HomeWidgetPriceDto _buildData({
  String productId = 'product-1',
  int minorUnits = 49999,
}) => HomeWidgetPriceDto(
  productId: productId,
  productName: 'Example Product',
  minorUnits: minorUnits,
  currencyCode: 'EUR',
  storeName: 'Example Store',
  updatedAt: DateTime(2026, 1, 1, 22, 30),
);
