// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/utils/price_fetch_result.value-object.dart';
import 'package:worth_loop/shared/utils/product_offer.value-object.dart';

/// Builds a [PriceFetchResult] with overridable values.
PriceFetchResult buildPriceFetchResult({
  PriceFetchStatus status = PriceFetchStatus.success,
  ProductOffer? offer,
}) => PriceFetchResult(status: status, offer: offer);
