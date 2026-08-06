// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/currency_converter.value-object.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Formats [money] for the price tracking interface.
String formatPrice(
  Money money, {
  CurrencyConverter converter = const CurrencyConverter(),
}) {
  final Money displayMoney = converter.convert(money) ?? money;
  // Unknown currencies have no rate or scale metadata, so preserve the
  // existing two-decimal fallback until currency metadata is available.
  final int configuredScale =
      converter.minorUnitScaleFor(displayMoney.currencyCode) ?? 100;
  final int minorUnitsPerUnit = configuredScale > 0 ? configuredScale : 100;
  final int decimalPlaces = _decimalPlacesFor(minorUnitsPerUnit);
  final String amount = (displayMoney.minorUnits / minorUnitsPerUnit)
      .toStringAsFixed(decimalPlaces);
  final String unit = displayMoney.currencyCode == 'EUR'
      ? '€'
      : displayMoney.currencyCode;
  return '$amount $unit';
}

int _decimalPlacesFor(int minorUnitsPerUnit) {
  int remainingScale = minorUnitsPerUnit;
  int decimalPlaces = 0;
  while (remainingScale > 1 && remainingScale % 10 == 0) {
    remainingScale ~/= 10;
    decimalPlaces++;
  }
  return remainingScale == 1 ? decimalPlaces : 2;
}
