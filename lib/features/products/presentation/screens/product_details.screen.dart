// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_not_found.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources.section.dart';
import 'package:worth_loop/features/products/presentation/widgets/rename_product_dialog.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';
import 'package:worth_loop/shared/features/pull_to_refresh.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays every current merchant offer for one tracked product.
class ProductDetailsScreen extends StatelessWidget {
  /// Identifier of the product to display.
  final String productId;

  const ProductDetailsScreen({required this.productId, super.key});

  Future<void> _confirmDeleteProduct(
    BuildContext context,
    ProductDetailsViewModel viewmodel,
    Product product,
  ) async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: t.productDetails.deleteProductTitle,
      message: t.productDetails.deleteProductMessage(name: product.name),
      confirmLabel: t.productDetails.deleteProductConfirmLabel,
    );
    if (confirmed) {
      viewmodel.onDeleteProduct();
    }
  }

  void _openAddSourceDialog(BuildContext context, Product product) =>
      showDialog<void>(
        context: context,
        builder: (context) => SourceFormDialog(productId: product.id),
      );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDetailsViewModel>(
      distinct: true,
      converter: (store) =>
          sl<ProductDetailsViewModel>(param1: store, param2: productId),
      builder: (context, viewmodel) {
        final Product? product = viewmodel.product;
        final String? blockedMessage = switch (viewmodel.refreshBlockReason) {
          ProductRefreshBlockReason.thisProduct =>
            t.productDetails.refreshBlockedThisProduct,
          ProductRefreshBlockReason.anotherProduct =>
            t.productDetails.refreshBlockedOtherProduct,
          ProductRefreshBlockReason.allProducts =>
            t.productDetails.refreshBlockedAllProducts,
          ProductRefreshBlockReason.none => null,
        };
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              key: const Key('product-details-back-button'),
              onPressed: viewmodel.onGoBack,
              tooltip: t.productDetails.backTooltip,
              icon: const Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: product == null
                ? Text(t.productDetails.title)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(product.name),
                      Text(
                        '${t.productDetails.sourcesTitle} \u00B7 ${product.sources.length}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
            actions: product == null
                ? null
                : [
                    IconButton(
                      key: const Key('product-details-rename-button'),
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (context) => RenameProductDialog(
                          productId: productId,
                          currentName: product.name,
                        ),
                      ),
                      tooltip: t.productDetails.renameProductTooltip,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    viewmodel.isDeletingProduct
                        ? Padding(
                            padding: EdgeInsets.all(context.spacing.md),
                            child: const SizedBox.square(
                              dimension: IconSizes.md,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : IconButton(
                            key: const Key('product-details-delete-button'),
                            onPressed: () => _confirmDeleteProduct(
                              context,
                              viewmodel,
                              product,
                            ),
                            tooltip: t.productDetails.deleteProductTooltip,
                            icon: const Icon(Icons.delete_outline),
                          ),
                  ],
          ),
          floatingActionButton: product == null
              ? null
              : FloatingActionButton.small(
                  key: const Key('product-details-add-source-fab'),
                  onPressed: () => _openAddSourceDialog(context, product),
                  tooltip: t.productDetails.addSourceButton,
                  child: const Icon(Icons.add),
                ),
          body: product == null
              ? const ProductNotFoundWidget()
              : PullToRefreshWidget(
                  blockedMessage: blockedMessage,
                  onRefresh: () async => viewmodel.onRefresh(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      ProductSourcesSection(
                        product: product,
                        isRefreshing: viewmodel.isProductRefreshing,
                        isRefreshBlocked: viewmodel.isRefreshing,
                        sourceRefreshStatuses: viewmodel.sourceRefreshStatuses,
                        deletingSourceIds: viewmodel.deletingSourceIds,
                        onRefreshSource: viewmodel.onRefreshSource,
                        onDeleteSource: viewmodel.onDeleteSource,
                        onOpenOffer: viewmodel.onOpenOffer,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
