import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Validates that product offers use one currency.
class CurrencyHelperService {
  /// Default currency used until a user preference is available.
  static const String defaultCurrencyCode = 'USD';

  const CurrencyHelperService();

  /// Validates that [prices] use one currency.
  void validate(Iterable<Money> prices) {
    final Set<String> currencyCodes = prices
        .map((Money money) => money.currencyCode)
        .toSet();
    if (currencyCodes.length > 1) {
      throw StateError('Prices must use one currency');
    }
  }
}
