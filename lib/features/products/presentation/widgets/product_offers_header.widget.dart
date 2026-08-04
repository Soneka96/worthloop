// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';

/// Displays a product's offer count and refresh control.
class ProductOffersHeader extends StatelessWidget {
  /// Number of merchant offers currently displayed.
  final int offerCount;

  /// Whether the product refresh is in progress.
  final bool isRefreshing;

  /// Refreshes the product's offers.
  final VoidCallback onRefresh;

  const ProductOffersHeader({
    required this.offerCount,
    required this.isRefreshing,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            t.productDetails.offers(count: offerCount),
            style: textTheme.labelSmall,
          ),
        ),
        FilledButton.icon(
          key: const Key('product-details-refresh-button'),
          onPressed: isRefreshing ? null : onRefresh,
          icon: isRefreshing
              ? const SizedBox.square(
                  dimension: IconSizes.md,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.refresh),
          label: Text(
            isRefreshing
                ? t.productDetails.refreshing
                : t.productDetails.refresh,
          ),
        ),
      ],
    );
  }
}
