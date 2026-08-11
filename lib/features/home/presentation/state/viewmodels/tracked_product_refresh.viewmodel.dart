// Package imports:
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.selectors.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Store-derived data needed by one tracked-product row.
class TrackedProductRefreshViewModel extends Equatable {
  final Product product;
  final Map<String, SourceRefreshStatus> sourceRefreshStatuses;

  const TrackedProductRefreshViewModel({
    required this.product,
    required this.sourceRefreshStatuses,
  });

  factory TrackedProductRefreshViewModel.fromStore(
    Store<AppState> store,
    Product product,
  ) => TrackedProductRefreshViewModel(
    product: product,
    sourceRefreshStatuses:
        ProductsSelectors.sourceRefreshStatusesForProductSelector(
          store.state,
          product.id,
        ),
  );

  @override
  List<Object?> get props => [product, sourceRefreshStatuses];
}
