// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_source_row.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Lists a product's saved merchant sources, with add/edit/delete actions.
class ProductSourcesSection extends StatelessWidget {
  /// Identifier of the product these sources belong to.
  final String productId;

  /// Saved sources for this product.
  final List<ProductSource> sources;

  /// Whether [sources] is still being loaded.
  final bool isLoadingSources;

  /// Source identifiers currently being deleted.
  final Set<String> deletingSourceIds;

  /// Requests deletion of the source with this id.
  final void Function(String sourceId) onDeleteSource;

  const ProductSourcesSection({
    required this.productId,
    required this.sources,
    required this.isLoadingSources,
    required this.deletingSourceIds,
    required this.onDeleteSource,
    super.key,
  });

  void _openAddDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => SourceFormDialog(productId: productId),
  );

  void _openEditDialog(BuildContext context, ProductSource source) =>
      showDialog<void>(
        context: context,
        builder: (context) =>
            SourceFormDialog(productId: productId, source: source),
      );

  Future<void> _confirmDelete(
    BuildContext context,
    ProductSource source,
  ) async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: t.productDetails.deleteSourceTitle,
      message: t.productDetails.deleteSourceMessage(
        merchant: source.merchantDomain,
      ),
      confirmLabel: t.productDetails.deleteSourceConfirmLabel,
    );
    if (confirmed) {
      onDeleteSource(source.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SliverPadding(
      padding: EdgeInsets.only(
        left: context.spacing.md,
        right: context.spacing.md,
        top: context.spacing.lg,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: context.spacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      t.productDetails.sourcesTitle,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  FilledButton.icon(
                    key: const Key('product-details-add-source-button'),
                    onPressed: () => _openAddDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(t.productDetails.addSourceButton),
                  ),
                ],
              ),
            ),
          ),
          if (isLoadingSources)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
          else if (sources.isEmpty)
            const SliverToBoxAdapter(child: ProductSourcesEmptyWidget())
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final ProductSource source = sources[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: context.spacing.sm),
                  child: ProductSourceRow(
                    source: source,
                    isDeleting: deletingSourceIds.contains(source.id),
                    onEdit: () => _openEditDialog(context, source),
                    onDelete: () => _confirmDelete(context, source),
                  ),
                );
              }, childCount: sources.length),
            ),
        ],
      ),
    );
  }
}
