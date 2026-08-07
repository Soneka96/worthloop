// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/products/presentation/utils/price_formatter.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Compact best-offer summary for one tracked product.
class TrackedProductWidget extends StatelessWidget {
  /// Product represented by this row.
  final Product product;

  /// Opens the product's complete offer list.
  final void Function() onTap;

  /// Current refresh state for every product source.
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses;

  const TrackedProductWidget({
    required this.product,
    required this.onTap,
    this.sourceRefreshStatuses = const {},
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ProductSource? bestPrice = product.bestAvailablePrice;
    final Money? currentPrice = bestPrice?.currentPrice;
    final List<ProductSource> failedSources = product.sources
        .where(
          (ProductSource source) =>
              sourceRefreshStatuses[source.id] == SourceRefreshStatus.error,
        )
        .toList(growable: false);
    final int checkingSourceCount = product.sources
        .where(
          (ProductSource source) => switch (sourceRefreshStatuses[source.id]) {
            SourceRefreshStatus.queued || SourceRefreshStatus.fetching => true,
            _ => false,
          },
        )
        .length;

    return InkWell(
      key: Key('tracked-product-${product.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      child: DecoratedBox(
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
                currentPrice == null
                    ? t.home.noAvailablePrice
                    : formatPrice(currentPrice),
                key: Key('tracked-product-price-${product.id}'),
                style: textTheme.headlineSmall,
              ),
              SizedBox(height: context.spacing.sm),
              Wrap(
                spacing: context.spacing.sm,
                runSpacing: context.spacing.xs,
                children: [
                  Text(
                    bestPrice?.merchantDomain ?? t.home.noStore,
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    t.home.storeOffers(count: product.sources.length),
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
              if (failedSources.isNotEmpty || checkingSourceCount > 0) ...[
                SizedBox(height: context.spacing.sm),
                _buildRefreshStatus(
                  context,
                  failedSources,
                  checkingSourceCount,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshStatus(
    BuildContext context,
    List<ProductSource> failedSources,
    int checkingSourceCount,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool hasFailures = failedSources.isNotEmpty;
    final String message = hasFailures
        ? failedSources.length == 1
              ? t.home.sourceRefreshFailed(
                  merchant: failedSources.first.merchantDomain,
                )
              : t.home.sourceRefreshFailedCount(count: failedSources.length)
        : t.home.sourceRefreshChecking(count: checkingSourceCount);
    return Row(
      key: Key('tracked-product-${product.id}-refresh-status'),
      children: [
        Icon(
          hasFailures ? Icons.error_outline : Icons.sync,
          size: IconSizes.sm,
          color: hasFailures ? colorScheme.error : colorScheme.primary,
        ),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(message, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
