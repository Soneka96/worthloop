// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays the tracked-product count and refresh-all control.
class HomeProductsHeader extends StatelessWidget {
  /// Number of tracked products.
  final int productCount;

  /// Whether every product is being refreshed.
  final bool isRefreshingAll;

  /// Whether the initial product load is active.
  final bool isLoading;

  /// Refreshes every tracked product.
  final VoidCallback onRefreshAll;

  const HomeProductsHeader({
    required this.productCount,
    required this.isRefreshingAll,
    required this.isLoading,
    required this.onRefreshAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool canRefresh = !isRefreshingAll && !isLoading && productCount > 0;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: context.spacing.md,
      runSpacing: context.spacing.sm,
      children: [
        Text(
          t.home.trackedProducts(count: productCount),
          style: textTheme.labelSmall,
        ),
        FilledButton.icon(
          key: const Key('home-refresh-all-button'),
          onPressed: canRefresh ? onRefreshAll : null,
          icon: isRefreshingAll
              ? const SizedBox.square(
                  dimension: IconSizes.md,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.refresh),
          label: Text(isRefreshingAll ? t.home.refreshing : t.home.refreshAll),
        ),
      ],
    );
  }
}
