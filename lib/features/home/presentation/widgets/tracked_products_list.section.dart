// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/home_search_field.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_product_store.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_empty.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_no_matches.widget.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Search field + filtered sliver list of tracked products, or the loading
/// / empty / no-matches state in place of it.
///
/// Owns its search query as local widget state — nothing outside Home reads
/// or reacts to it, so it never touches Redux.
class TrackedProductsListSection extends StatefulWidget {
  /// Every tracked product, unfiltered by the local search query.
  final List<Product> products;

  /// Whether [products] is still being loaded.
  final bool isLoading;

  /// Called with the tapped product's id.
  final ValueChanged<String> onProductTap;

  const TrackedProductsListSection({
    required this.products,
    required this.isLoading,
    required this.onProductTap,
    super.key,
  });

  @override
  State<TrackedProductsListSection> createState() =>
      _TrackedProductsListSectionState();
}

class _TrackedProductsListSectionState
    extends State<TrackedProductsListSection> {
  String _query = '';

  void _onQueryChanged(String value) => setState(() => _query = value);

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.products.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: TrackedProductsEmptyWidget(),
      );
    }

    final String query = _query.trim().toLowerCase();
    final List<Product> filtered = query.isEmpty
        ? widget.products
        : widget.products
              .where((product) => product.name.toLowerCase().contains(query))
              .toList();

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            left: context.spacing.md,
            right: context.spacing.md,
            bottom: context.spacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: HomeSearchField(onChanged: _onQueryChanged),
          ),
        ),
        if (filtered.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: TrackedProductsNoMatchesWidget(query: _query.trim()),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: context.spacing.sm),
                  child: TrackedProductStoreWidget(
                    product: filtered[index],
                    onTap: () => widget.onProductTap(filtered[index].id),
                  ),
                ),
                childCount: filtered.length,
              ),
            ),
          ),
      ],
    );
  }
}
