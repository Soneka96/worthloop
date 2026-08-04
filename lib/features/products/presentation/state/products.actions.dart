// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';

/// Requests loading every tracked product.
@immutable
class LoadProductsAction extends Equatable {
  const LoadProductsAction();

  @override
  List<Object?> get props => [];
}

/// Carries products loaded by middleware.
@immutable
class ProductsLoadedAction extends Equatable {
  /// The latest tracked products.
  final List<Product> products;

  const ProductsLoadedAction(this.products);

  @override
  List<Object?> get props => [products];
}

/// Carries a product-loading failure.
@immutable
class ProductsLoadFailedAction extends Equatable {
  /// The failure message.
  final String message;

  const ProductsLoadFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests refreshing one tracked product.
@immutable
class RefreshProductAction extends Equatable {
  /// Identifier of the product to refresh.
  final String productId;

  const RefreshProductAction(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Carries one refreshed product.
@immutable
class ProductRefreshedAction extends Equatable {
  /// The refreshed product.
  final Product product;

  const ProductRefreshedAction(this.product);

  @override
  List<Object?> get props => [product];
}

/// Carries a one-product refresh failure.
@immutable
class ProductRefreshFailedAction extends Equatable {
  /// Identifier of the product whose refresh failed.
  final String productId;

  /// The failure message.
  final String message;

  const ProductRefreshFailedAction({
    required this.productId,
    required this.message,
  });

  @override
  List<Object?> get props => [productId, message];
}

/// Requests refreshing every tracked product.
@immutable
class RefreshAllProductsAction extends Equatable {
  const RefreshAllProductsAction();

  @override
  List<Object?> get props => [];
}

/// Carries a refresh-all failure.
@immutable
class RefreshAllProductsFailedAction extends Equatable {
  /// The failure message.
  final String message;

  const RefreshAllProductsFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}
