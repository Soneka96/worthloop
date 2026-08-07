// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Displays a product's offer count.
class ProductOffersHeader extends StatelessWidget {
  /// Number of merchant offers currently displayed.
  final int offerCount;

  const ProductOffersHeader({required this.offerCount, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      t.productDetails.offers(count: offerCount),
      style: textTheme.labelSmall,
    );
  }
}
