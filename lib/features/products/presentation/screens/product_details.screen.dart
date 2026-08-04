// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/utils/price_formatter.dart';
import 'package:worth_loop/features/products/presentation/widgets/store_price.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_shape_theme_extension.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays every current merchant offer for one tracked product.
class ProductDetailsScreen extends StatelessWidget {
  /// Identifier of the product to display.
  final String productId;

  const ProductDetailsScreen({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDetailsViewModel>(
      distinct: true,
      converter: (store) =>
          sl<ProductDetailsViewModel>(param1: store, param2: productId),
      builder: (context, viewmodel) {
        final Product? product = viewmodel.product;
        final StorePrice? bestPrice = product?.bestAvailablePrice;
        final List<StorePrice> prices = product?.pricesForDisplay ?? [];
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        final TextTheme textTheme = Theme.of(context).textTheme;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              key: const Key('product-details-back-button'),
              onPressed: viewmodel.onGoBack,
              tooltip: t.productDetails.backTooltip,
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(product?.name ?? t.productDetails.title),
          ),
          body: product == null
              ? Center(
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
                )
              : Padding(
                  padding: EdgeInsets.all(context.spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DecoratedBox(
                        key: const Key('product-details-best-price'),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            context.resolvedCornerRadius,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(context.spacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.productDetails.bestPrice,
                                style: textTheme.labelSmall,
                              ),
                              SizedBox(height: context.spacing.xs),
                              Text(
                                bestPrice == null
                                    ? t.home.noAvailablePrice
                                    : formatPrice(bestPrice.currentPrice),
                                style: textTheme.headlineSmall,
                              ),
                              if (bestPrice != null)
                                Text(
                                  bestPrice.storeName,
                                  style: textTheme.bodyMedium,
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: context.spacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              t.productDetails.offers(
                                count: product.storePrices.length,
                              ),
                              style: textTheme.labelSmall,
                            ),
                          ),
                          FilledButton.icon(
                            key: const Key('product-details-refresh-button'),
                            onPressed: viewmodel.isRefreshing
                                ? null
                                : viewmodel.onRefresh,
                            icon: viewmodel.isRefreshing
                                ? const SizedBox.square(
                                    dimension: IconSizes.md,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Icon(Icons.refresh),
                            label: Text(
                              viewmodel.isRefreshing
                                  ? t.productDetails.refreshing
                                  : t.productDetails.refresh,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.spacing.sm),
                      Expanded(
                        child: ListView.builder(
                          itemCount: prices.length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: context.spacing.sm,
                            ),
                            child: StorePriceWidget(storePrice: prices[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
