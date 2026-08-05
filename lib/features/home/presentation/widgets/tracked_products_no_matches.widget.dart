// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Empty state shown when a search query matches no tracked products.
class TrackedProductsNoMatchesWidget extends StatelessWidget {
  /// The search query that produced zero matches.
  final String query;

  const TrackedProductsNoMatchesWidget({required this.query, super.key});

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
              Icons.search_off,
              size: IconSizes.md,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: context.spacing.md),
            Text(
              t.home.noSearchResultsTitle,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            SizedBox(height: context.spacing.xs),
            Text(
              t.home.noSearchResultsDescription(query: query),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
