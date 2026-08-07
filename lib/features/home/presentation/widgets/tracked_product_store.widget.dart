// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/tracked_product_refresh.viewmodel.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_product.widget.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Connects one tracked-product row to only its own refresh statuses.
class TrackedProductStoreWidget extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const TrackedProductStoreWidget({
    required this.product,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, TrackedProductRefreshViewModel>(
        distinct: true,
        converter: (store) =>
            TrackedProductRefreshViewModel.fromStore(store, product),
        builder: (context, viewModel) => TrackedProductWidget(
          product: viewModel.product,
          sourceRefreshStatuses: viewModel.sourceRefreshStatuses,
          onTap: onTap,
        ),
      );
}
