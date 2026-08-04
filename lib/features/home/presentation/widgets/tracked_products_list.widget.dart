import 'package:flutter/material.dart';

import 'package:worth_loop/features/home/presentation/widgets/tracked_product.widget.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Lazily displays the tracked-product records.
class TrackedProductsListWidget extends StatelessWidget {
  /// Products to display.
  final List<Product> products;

  /// Called when a product is selected.
  final ValueChanged<String> onProductTap;

  const TrackedProductsListWidget({
    required this.products,
    required this.onProductTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      final Product product = products[index];
      return Padding(
        padding: EdgeInsets.only(bottom: context.spacing.sm),
        child: TrackedProductWidget(
          product: product,
          onTap: () => onProductTap(product.id),
        ),
      );
    },
  );
}
