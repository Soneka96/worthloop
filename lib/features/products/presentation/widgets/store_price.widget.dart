// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/utils/price_formatter.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One merchant offer in a product's price ledger.
class StorePriceWidget extends StatelessWidget {
  /// Offer represented by this row.
  final StorePrice storePrice;

  const StorePriceWidget({required this.storePrice, super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      key: Key('store-price-${storePrice.storeName}'),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(storePrice.storeName, style: textTheme.titleMedium),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    storePrice.isAvailable
                        ? t.productDetails.available
                        : t.productDetails.unavailable,
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    t.productDetails.checkedAt(
                      time: MaterialLocalizations.of(context).formatTimeOfDay(
                        TimeOfDay.fromDateTime(storePrice.lastCheckedAt),
                      ),
                    ),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: context.spacing.md),
            Text(
              formatPrice(storePrice.currentPrice),
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
