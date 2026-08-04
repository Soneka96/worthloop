// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Identifies illustrative local prices that are not live merchant offers.
class IllustrativePriceNotice extends StatelessWidget {
  const IllustrativePriceNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      key: const Key('illustrative-price-notice'),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: IconSizes.sm,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                t.home.sampleDataNotice,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
