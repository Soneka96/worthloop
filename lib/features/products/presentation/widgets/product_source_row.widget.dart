// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// One saved merchant source for a product, with edit and delete actions.
class ProductSourceRow extends StatelessWidget {
  /// Source represented by this row.
  final ProductSource source;

  /// Whether this source is currently being deleted.
  final bool isDeleting;

  /// Opens the edit-source dialog for [source].
  final VoidCallback onEdit;

  /// Requests deletion of [source].
  final VoidCallback onDelete;

  const ProductSourceRow({
    required this.source,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      key: Key('product-source-${source.id}'),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(context.resolvedCornerRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(source.merchantDomain, style: textTheme.titleMedium),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    source.url,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: context.spacing.sm),
            IconButton(
              key: Key('product-source-${source.id}-edit-button'),
              onPressed: isDeleting ? null : onEdit,
              tooltip: t.productDetails.editSourceTooltip,
              icon: const Icon(Icons.edit_outlined),
            ),
            isDeleting
                ? Padding(
                    padding: EdgeInsets.all(context.spacing.md),
                    child: const SizedBox.square(
                      dimension: IconSizes.md,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IconButton(
                    key: Key('product-source-${source.id}-delete-button'),
                    onPressed: onDelete,
                    tooltip: t.productDetails.deleteSourceTooltip,
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                  ),
          ],
        ),
      ),
    );
  }
}
