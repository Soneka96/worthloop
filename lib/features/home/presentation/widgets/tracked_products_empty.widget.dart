// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Empty state shown before any products are tracked.
class TrackedProductsEmptyWidget extends StatelessWidget {
  const TrackedProductsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: IconSizes.md,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: context.spacing.md),
            Text(
              t.home.emptyTitle,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            SizedBox(height: context.spacing.xs),
            Text(
              t.home.emptyDescription,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
