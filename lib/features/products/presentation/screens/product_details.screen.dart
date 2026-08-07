// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_offers_header.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_not_found.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources.section.dart';
import 'package:worth_loop/features/products/presentation/widgets/rename_product_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/features/confirm_dialog.widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDetailsViewModel>(
      distinct: true,
      converter: (store) =>
          sl<ProductDetailsViewModel>(param1: store, param2: productId),
      builder: (context, viewmodel) {
        final Product? product = viewmodel.product;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              key: const Key('product-details-back-button'),
              onPressed: viewmodel.onGoBack,
              tooltip: t.productDetails.backTooltip,
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(product?.name ?? t.productDetails.title),
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
          body: product == null
              ? const ProductNotFoundWidget()
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(context.spacing.md),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ProductOffersHeader(
                            offerCount: product.sources.length,
                            isRefreshing: viewmodel.isRefreshing,
                            onRefresh: viewmodel.onRefresh,
                          ),
                          SizedBox(height: context.spacing.sm),
                          if (viewmodel.isRefreshing &&
                              viewmodel.refreshTotalCount > 0)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: context.spacing.sm,
                              ),
                              child: Text(
                                t.productDetails.refreshProgress(
                                  completed: viewmodel.refreshCompletedCount,
                                  total: viewmodel.refreshTotalCount,
                                ),
                              ),
                            ),
                        ]),
                      ),
                    ),
                    ProductSourcesSection(
                      product: product,
                      isRefreshing: viewmodel.isRefreshing,
                      sourceRefreshStatuses: viewmodel.sourceRefreshStatuses,
                      deletingSourceIds: viewmodel.deletingSourceIds,
                      onDeleteSource: viewmodel.onDeleteSource,
                      onOpenOffer: viewmodel.onOpenOffer,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
