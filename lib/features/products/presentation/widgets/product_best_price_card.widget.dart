// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/utils/price_formatter.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays the current best available offer for a product.
class ProductBestPriceCard extends StatelessWidget {
  /// The lowest available offer, or `null` when none is available.
  final StorePrice? bestPrice;

  const ProductBestPriceCard({required this.bestPrice, super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final StorePrice? price = bestPrice;

    return DecoratedBox(
      key: const Key('product-details-best-price'),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.productDetails.bestPrice, style: textTheme.labelSmall),
            SizedBox(height: context.spacing.xs),
            if (price == null)
              Text(t.home.noAvailablePrice, style: textTheme.headlineSmall)
            else ...[
              Text(
                formatPrice(price.currentPrice),
                style: textTheme.headlineSmall,
              ),
              Text(price.storeName, style: textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
