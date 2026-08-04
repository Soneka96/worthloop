// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Compact best-offer summary for one tracked product.
class TrackedProductWidget extends StatelessWidget {
  /// Product represented by this row.
  final Product product;

  const TrackedProductWidget({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final StorePrice? bestPrice = product.bestAvailablePrice;

    return DecoratedBox(
      key: Key('tracked-product-${product.id}'),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: textTheme.titleMedium),
            SizedBox(height: context.spacing.sm),
            Text(t.home.bestPrice, style: textTheme.labelSmall),
            SizedBox(height: context.spacing.xs),
            Text(
              bestPrice == null
                  ? t.home.noAvailablePrice
                  : _formatPrice(bestPrice),
              key: Key('tracked-product-price-${product.id}'),
              style: textTheme.headlineSmall,
            ),
            SizedBox(height: context.spacing.sm),
            Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.xs,
              children: [
                Text(
                  bestPrice?.storeName ?? t.home.noStore,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  t.home.storeOffers(count: product.storePrices.length),
                  style: textTheme.bodySmall,
                ),
                Text(
                  t.home.updatedAt(
                    time: MaterialLocalizations.of(context).formatTimeOfDay(
                      TimeOfDay.fromDateTime(product.lastUpdatedAt),
                    ),
                  ),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(StorePrice price) {
    final String amount = (price.currentPrice.minorUnits / 100).toStringAsFixed(
      2,
    );
    final String unit = price.currentPrice.currencyCode == 'EUR'
        ? '€'
        : price.currentPrice.currencyCode;
    return '$amount $unit';
  }
}
