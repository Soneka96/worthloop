// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Converts exact monetary amounts to a selected display currency.
@immutable
class CurrencyConverter extends Equatable {
  /// Default display currency until a user preference is available.
  static const String defaultCurrencyCode = 'EUR';

  /// Built-in rates expressed as euros per one unit of currency.
  // ponytail: embedded rates keep the MVP offline; replace with cached live
  // rates when conversion freshness becomes a product requirement.
  static const Map<String, double> defaultRatesToEuro = {
    'EUR': 1.0,
    'USD': 0.92,
    'GBP': 1.17,
    'CAD': 0.68,
    'AUD': 0.60,
    'CHF': 1.04,
    'CNY': 0.127,
    'INR': 0.011,
    'JPY': 0.0062,
    'KRW': 0.00068,
  };

  /// Built-in minor-unit scales for the supported currencies.
  static const Map<String, int> defaultMinorUnitsPerUnit = {
    'EUR': 100,
    'USD': 100,
    'GBP': 100,
    'CAD': 100,
    'AUD': 100,
    'CHF': 100,
    'CNY': 100,
    'INR': 100,
    'JPY': 1,
    'KRW': 1,
  };

  /// Rates expressed as euros per one unit of source currency.
  final Map<String, double> ratesToEuro;

  /// Number of minor units in one unit for each supported currency.
  final Map<String, int> minorUnitsPerUnit;

  /// Creates a converter backed by [ratesToEuro] and [minorUnitsPerUnit].
  const CurrencyConverter({
    this.ratesToEuro = defaultRatesToEuro,
    this.minorUnitsPerUnit = defaultMinorUnitsPerUnit,
  });

  /// Converts [money] to [targetCurrency], or returns `null` when either
  /// currency is not supported by this converter.
  Money? convert(Money money, {String targetCurrency = defaultCurrencyCode}) {
    final String sourceCode = money.currencyCode.trim().toUpperCase();
    final String targetCode = targetCurrency.trim().toUpperCase();
    final double? sourceRate = ratesToEuro[sourceCode];
    final double? targetRate = ratesToEuro[targetCode];
    final int? sourceScale = minorUnitsPerUnit[sourceCode];
    final int? targetScale = minorUnitsPerUnit[targetCode];
    if (sourceRate == null ||
        targetRate == null ||
        sourceScale == null ||
        targetScale == null) {
      return null;
    }
    final double sourceAmount = money.minorUnits / sourceScale;
    final double targetAmount = sourceAmount * sourceRate / targetRate;
    return Money(
      minorUnits: (targetAmount * targetScale).round(),
      currencyCode: targetCode,
    );
  }

  @override
  List<Object?> get props => [ratesToEuro, minorUnitsPerUnit];
}
