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
import 'package:worth_loop/shared/constants/enums.dart';
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

  /// Current refresh state for this source.
  final SourceRefreshStatus refreshStatus;

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
    this.refreshStatus = SourceRefreshStatus.idle,
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
          color: _surfaceColor(colorScheme),
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
                        Row(
                          children: [
                            _statusIndicator(colorScheme),
                            SizedBox(width: context.spacing.xs),
                            Flexible(
                              child: Text(
                                _availabilityLabel(),
                                key: Key(
                                  'merchant-offer-${source.id}-refresh-status',
                                ),
                                style: textTheme.bodySmall,
                              ),
                            ),
                          ],
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

  String _availabilityLabel() => switch (refreshStatus) {
    SourceRefreshStatus.queued => t.productDetails.queued,
    SourceRefreshStatus.fetching => t.productDetails.checking,
    SourceRefreshStatus.error => t.productDetails.cannotAccessNow,
    SourceRefreshStatus.unavailable => t.productDetails.unavailable,
    SourceRefreshStatus.success =>
      source.isAvailable == false
          ? t.productDetails.unavailable
          : t.productDetails.available,
    SourceRefreshStatus.none || SourceRefreshStatus.idle =>
      source.isAvailable == false
          ? t.productDetails.unavailable
          : t.productDetails.available,
  };

  Widget _statusIndicator(ColorScheme colorScheme) {
    if (refreshStatus == SourceRefreshStatus.fetching) {
      return SizedBox.square(
        dimension: IconSizes.sm,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _statusColor(colorScheme),
        ),
      );
    }
    return Icon(
      _statusIcon(),
      key: Key('merchant-offer-${source.id}-refresh-status-icon'),
      size: IconSizes.sm,
      color: _statusColor(colorScheme),
    );
  }

  IconData _statusIcon() => switch (refreshStatus) {
    SourceRefreshStatus.queued => Icons.hourglass_empty,
    SourceRefreshStatus.fetching => Icons.sync,
    SourceRefreshStatus.error => Icons.error_outline,
    SourceRefreshStatus.unavailable => Icons.remove_circle_outline,
    SourceRefreshStatus.success => Icons.check_circle_outline,
    SourceRefreshStatus.none || SourceRefreshStatus.idle =>
      source.isAvailable == true
          ? Icons.check_circle_outline
          : Icons.help_outline,
  };

  Color _statusColor(ColorScheme colorScheme) => switch (refreshStatus) {
    SourceRefreshStatus.queued ||
    SourceRefreshStatus.fetching => colorScheme.primary,
    SourceRefreshStatus.error => colorScheme.error,
    SourceRefreshStatus.unavailable => colorScheme.secondary,
    SourceRefreshStatus.success => colorScheme.tertiary,
    SourceRefreshStatus.none || SourceRefreshStatus.idle =>
      source.isAvailable == true ? colorScheme.tertiary : colorScheme.outline,
  };

  Color _surfaceColor(ColorScheme colorScheme) => switch (refreshStatus) {
    SourceRefreshStatus.queued ||
    SourceRefreshStatus.fetching => colorScheme.primaryContainer,
    SourceRefreshStatus.error => colorScheme.errorContainer,
    SourceRefreshStatus.unavailable => colorScheme.secondaryContainer,
    SourceRefreshStatus.success => colorScheme.tertiaryContainer,
    SourceRefreshStatus.none ||
    SourceRefreshStatus.idle => colorScheme.surfaceContainerLow,
  };
}
