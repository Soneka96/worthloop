import 'package:flutter/material.dart';

import 'package:worth_loop/features/products/domain/entities/store_price.entity.dart';
import 'package:worth_loop/features/products/presentation/widgets/store_price.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays available and unavailable offers in price order.
class ProductOffersWidget extends StatelessWidget {
  /// Available offers ordered from lowest to highest price.
  final List<StorePrice> availablePrices;

  /// Unavailable offers ordered from lowest to highest price.
  final List<StorePrice> unavailablePrices;

  const ProductOffersWidget({
    required this.availablePrices,
    required this.unavailablePrices,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int itemCount = availablePrices.isEmpty && unavailablePrices.isEmpty
        ? 1
        : (availablePrices.isEmpty ? 0 : availablePrices.length + 1) +
              (unavailablePrices.isEmpty ? 0 : unavailablePrices.length + 2);

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (availablePrices.isEmpty && unavailablePrices.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(bottom: context.spacing.sm),
            child: Text(t.productDetails.noOffers, style: textTheme.bodyMedium),
          );
        }
        if (availablePrices.isNotEmpty) {
          if (index == 0) {
            return Padding(
              key: const Key('product-details-available-section'),
              padding: EdgeInsets.only(bottom: context.spacing.sm),
              child: Text(
                t.productDetails.availableOffers,
                style: textTheme.labelSmall,
              ),
            );
          }
          if (index <= availablePrices.length) {
            return Padding(
              padding: EdgeInsets.only(bottom: context.spacing.sm),
              child: StorePriceWidget(storePrice: availablePrices[index - 1]),
            );
          }
        }

        final int unavailableIndex = availablePrices.isEmpty
            ? index
            : index - availablePrices.length - 1;
        if (unavailableIndex == 0) {
          return Padding(
            key: const Key('product-details-unavailable-section'),
            padding: EdgeInsets.only(bottom: context.spacing.sm),
            child: Text(
              t.productDetails.unavailableOffers,
              style: textTheme.labelSmall,
            ),
          );
        }
        if (unavailableIndex == 1) {
          return Padding(
            padding: EdgeInsets.only(bottom: context.spacing.sm),
            child: Text(
              t.productDetails.unavailableDescription,
              style: textTheme.bodySmall,
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(bottom: context.spacing.sm),
          child: StorePriceWidget(
            storePrice: unavailablePrices[unavailableIndex - 2],
          ),
        );
      },
    );
  }
}
