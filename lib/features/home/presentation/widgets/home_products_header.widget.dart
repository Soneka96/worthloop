// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays the tracked-product count and compact refresh status.
class HomeProductsHeader extends StatelessWidget {
  /// Number of tracked products.
  final int productCount;

  /// Whether any product or source refresh is currently active.
  final bool isRefreshing;

  /// Number of sources that have reached a terminal state.
  final int refreshCompletedCount;

  /// Number of sources included in the active refresh.
  final int refreshTotalCount;

  /// Whether the background refresh's own notification already shows a
  /// progress bar — when true, this widget's "X of Y" text stays hidden so
  /// the user isn't shown the same progress twice.
  final bool showRefreshProgress;

  /// Most recent update time across tracked products.
  final DateTime? latestUpdatedAt;

  const HomeProductsHeader({
    required this.productCount,
    required this.isRefreshing,
    required this.refreshCompletedCount,
    required this.refreshTotalCount,
    required this.showRefreshProgress,
    required this.latestUpdatedAt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? updatedTime = latestUpdatedAt == null
        ? null
        : TimeOfDay.fromDateTime(latestUpdatedAt!).format(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
      child: Text(
        isRefreshing && !showRefreshProgress
            ? t.home.refreshProgress(
                completed: refreshCompletedCount,
                total: refreshTotalCount,
              )
            : updatedTime == null
            ? t.home.trackedProducts(count: productCount)
            : '${t.home.trackedProducts(count: productCount)} · ${t.home.updatedAt(time: updatedTime)}',
        style: textTheme.labelSmall,
      ),
    );
  }
}
