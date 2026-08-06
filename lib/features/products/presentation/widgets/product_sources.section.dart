// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/widgets/merchant_offer_row.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Lists a product's saved merchant sources, with add/edit/delete actions.
class ProductSourcesSection extends StatefulWidget {
  /// Product whose saved merchant sources are displayed.
  final Product product;

  /// Source identifiers currently being deleted.
  final Set<String> deletingSourceIds;

  /// Requests deletion of the source with this id.
  final void Function(String sourceId) onDeleteSource;

  /// Opens the tapped offer in the device's default browser.
  final ValueChanged<String> onOpenOffer;

  const ProductSourcesSection({
    required this.product,
    required this.deletingSourceIds,
    required this.onDeleteSource,
    required this.onOpenOffer,
    super.key,
  });

  @override
  State<ProductSourcesSection> createState() => _ProductSourcesSectionState();
}

class _ProductSourcesSectionState extends State<ProductSourcesSection> {
  ProductOfferFilter _filter = ProductOfferFilter.all;

  List<ProductSource> get _filteredSources {
    final List<ProductSource> orderedSources = widget.product.pricesForDisplay;
    return switch (_filter) {
      ProductOfferFilter.none || ProductOfferFilter.all => orderedSources,
      ProductOfferFilter.available =>
        orderedSources
            .where((ProductSource source) => source.isAvailable == true)
            .toList(growable: false),
      ProductOfferFilter.unavailable =>
        orderedSources
            .where((ProductSource source) => source.isAvailable != true)
            .toList(growable: false),
    };
  }

  void _openAddDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => SourceFormDialog(productId: widget.product.id),
  );

  void _openEditDialog(BuildContext context, ProductSource source) =>
      showDialog<void>(
        context: context,
        builder: (context) =>
            SourceFormDialog(productId: widget.product.id, source: source),
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
      widget.onDeleteSource(source.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ProductSource? bestAvailablePrice = widget.product.bestAvailablePrice;

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
          if (widget.product.sources.isEmpty)
            const SliverToBoxAdapter(child: ProductSourcesEmptyWidget())
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: context.spacing.sm),
                child: Wrap(
                  spacing: context.spacing.xs,
                  children: [
                    FilterChip(
                      key: const Key('product-details-source-filter-all'),
                      label: Text(t.productDetails.filterAll),
                      selected: _filter == ProductOfferFilter.all,
                      onSelected: (_) =>
                          setState(() => _filter = ProductOfferFilter.all),
                    ),
                    FilterChip(
                      key: const Key('product-details-source-filter-available'),
                      label: Text(t.productDetails.filterAvailable),
                      selected: _filter == ProductOfferFilter.available,
                      onSelected: (_) => setState(
                        () => _filter = ProductOfferFilter.available,
                      ),
                    ),
                    FilterChip(
                      key: const Key(
                        'product-details-source-filter-unavailable',
                      ),
                      label: Text(t.productDetails.filterUnavailable),
                      selected: _filter == ProductOfferFilter.unavailable,
                      onSelected: (_) => setState(
                        () => _filter = ProductOfferFilter.unavailable,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_filteredSources.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
                  child: Text(t.productDetails.noOffers),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final ProductSource source = _filteredSources[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.spacing.sm),
                    child: MerchantOfferRow(
                      source: source,
                      isBestPrice: source == bestAvailablePrice,
                      isDeleting: widget.deletingSourceIds.contains(source.id),
                      onTap: () => widget.onOpenOffer(source.url),
                      onEdit: () => _openEditDialog(context, source),
                      onDelete: () => _confirmDelete(context, source),
                    ),
                  );
                }, childCount: _filteredSources.length),
              ),
          ],
        ],
      ),
    );
  }
}
