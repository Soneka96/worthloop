// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';

/// Displays a product's tracked source count.
class ProductOffersHeader extends StatelessWidget {
  /// Number of merchant sources currently tracked.
  final int offerCount;

  const ProductOffersHeader({required this.offerCount, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      '${t.productDetails.sourcesTitle} · $offerCount',
      style: textTheme.labelSmall,
    );
  }
}
