// Project imports:
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';

/// Builds a [ProductOffer] with overridable values.
ProductOffer buildProductOffer({
  int minorUnits = 4999,
  String currencyCode = 'EUR',
  bool isAvailable = true,
}) => ProductOffer(
  minorUnits: minorUnits,
  currencyCode: currencyCode,
  isAvailable: isAvailable,
);
