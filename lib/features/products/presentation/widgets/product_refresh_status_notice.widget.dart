import 'package:flutter/material.dart';

import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Explains why the latest product refresh did not update its offers.
class ProductRefreshStatusNotice extends StatelessWidget {
  /// The classified refresh failure to display.
  final PriceFetchStatus? status;

  const ProductRefreshStatusNotice({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    if (status == null || status == PriceFetchStatus.none) {
      return const SizedBox.shrink();
    }
    final String message = switch (status) {
      PriceFetchStatus.blocked => t.productDetails.refreshBlocked,
      PriceFetchStatus.unsupported => t.productDetails.refreshUnsupported,
      PriceFetchStatus.networkError => t.productDetails.refreshNetworkError,
      PriceFetchStatus.invalidData => t.productDetails.refreshInvalidData,
      PriceFetchStatus.success || PriceFetchStatus.none || null => '',
    };
    return Card(
      key: const Key('product-refresh-status-notice'),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.sm),
        child: Text(message),
      ),
    );
  }
}
