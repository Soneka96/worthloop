// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// The "best price" stamp shown on a product's lowest-priced offer.
class BestPriceStamp extends StatelessWidget {
  const BestPriceStamp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.xs,
          vertical: context.spacing.xs / 2,
        ),
        child: Text(
          t.productDetails.bestPrice,
          style: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
