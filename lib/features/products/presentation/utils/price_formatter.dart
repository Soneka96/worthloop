// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Formats [money] for the price tracking interface.
String formatPrice(Money money) {
  final String amount = (money.minorUnits / 100).toStringAsFixed(2);
  final String unit = money.currencyCode == 'EUR' ? '€' : money.currencyCode;
  return '$amount $unit';
}
