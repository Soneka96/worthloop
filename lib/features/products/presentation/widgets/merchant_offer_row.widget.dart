// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/features/products/presentation/utils/price_formatter.dart';
import 'package:worth_loop/features/products/presentation/widgets/best_price_stamp.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One merchant offer for a product — its source and latest fetched price
/// together — swipeable to edit or delete, tappable to open in the browser.
class MerchantOfferRow extends StatelessWidget {
  /// Source and offer represented by this row.
  final ProductSource source;

  /// Whether this is the lowest available price among the product's offers.
  final bool isBestPrice;

  /// Whether this source is currently being deleted.
  final bool isDeleting;

  /// Opens [source.url] in the device's default browser.
  final VoidCallback onTap;

  /// Opens the edit-source dialog for [source].
  final VoidCallback onEdit;

  /// Requests deletion of [source].
  final VoidCallback onDelete;

  const MerchantOfferRow({
    required this.source,
    required this.isBestPrice,
    required this.isDeleting,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius borderRadius = BorderRadius.circular(
      context.resolvedCornerRadius,
    );
    final Money? currentPrice = source.currentPrice;
    final DateTime? lastCheckedAt = source.lastCheckedAt;

    return Slidable(
      key: Key('merchant-offer-${source.id}'),
      enabled: !isDeleting,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            key: Key('merchant-offer-${source.id}-edit-action'),
            onPressed: (_) => onEdit(),
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: colorScheme.onSecondaryContainer,
            icon: Icons.edit_outlined,
            label: t.productDetails.editSourceTooltip,
          ),
          SlidableAction(
            key: Key('merchant-offer-${source.id}-delete-action'),
            onPressed: (_) => onDelete(),
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
            icon: Icons.delete_outline,
            label: t.productDetails.deleteSourceTooltip,
          ),
        ],
      ),
      child: Semantics(
        hint: t.productDetails.openOfferHint,
        customSemanticsActions: {
          CustomSemanticsAction(label: t.productDetails.editSourceTooltip):
              onEdit,
          CustomSemanticsAction(label: t.productDetails.deleteSourceTooltip):
              onDelete,
        },
        child: Material(
          color: colorScheme.surfaceContainerLow,
          borderRadius: borderRadius,
          child: InkWell(
            key: Key('merchant-offer-${source.id}-tap-target'),
            onTap: isDeleting ? null : onTap,
            borderRadius: borderRadius,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: borderRadius,
              ),
              padding: EdgeInsets.all(context.spacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                source.merchantDomain,
                                style: textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isBestPrice) ...[
                              SizedBox(width: context.spacing.xs),
                              const BestPriceStamp(),
                            ],
                          ],
                        ),
                        SizedBox(height: context.spacing.xs),
                        Text(
                          source.isAvailable == false
                              ? t.productDetails.unavailable
                              : t.productDetails.available,
                          style: textTheme.bodySmall,
                        ),
                        if (lastCheckedAt != null)
                          Text(
                            t.productDetails.checkedAt(
                              time: MaterialLocalizations.of(context)
                                  .formatTimeOfDay(
                                    TimeOfDay.fromDateTime(lastCheckedAt),
                                  ),
                            ),
                            style: textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.spacing.md),
                  if (isDeleting)
                    const SizedBox.square(
                      dimension: IconSizes.md,
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    if (currentPrice != null)
                      Text(
                        formatPrice(currentPrice),
                        style: textTheme.titleMedium,
                      ),
                    SizedBox(width: context.spacing.sm),
                    Icon(
                      Icons.circle,
                      size: MerchantOfferRowSizes.swipeHintDotSize,
                      color: colorScheme.tertiary.withValues(alpha: 0.5),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
