// Project imports:
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';

/// Builds a [Money] with overridable values.
Money buildMoney({int minorUnits = 49999, String currencyCode = 'EUR'}) =>
    Money(minorUnits: minorUnits, currencyCode: currencyCode);
