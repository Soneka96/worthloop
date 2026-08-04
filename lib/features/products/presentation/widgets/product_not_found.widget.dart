// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays the empty state when a requested product cannot be found.
class ProductNotFoundWidget extends StatelessWidget {
  const ProductNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.productDetails.productNotFound,
              style: textTheme.titleMedium,
            ),
            SizedBox(height: context.spacing.xs),
            Text(
              t.productDetails.productNotFoundDescription,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
