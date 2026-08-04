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

/// Requests creating a tracked product from a website link.
@immutable
class CreateProductAction extends Equatable {
  /// Product display name entered by the user.
  final String name;

  /// Product website link entered by the user.
  final String url;

  const CreateProductAction({required this.name, required this.url});

  @override
  List<Object?> get props => [name, url];
}

/// Carries a newly created product.
@immutable
class ProductCreatedAction extends Equatable {
  /// The newly created product.
  final Product product;

  const ProductCreatedAction(this.product);

  @override
  List<Object?> get props => [product];
}

/// Carries a product-creation failure.
@immutable
class ProductCreationFailedAction extends Equatable {
  /// The failure message.
  final String message;

  const ProductCreationFailedAction(this.message);

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

/// Requests navigation to one product's details.
@immutable
class GoToProductDetailsAction extends Equatable {
  /// Identifier of the product to display.
  final String productId;

  const GoToProductDetailsAction(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Requests returning from product details.
@immutable
class GoBackFromProductDetailsAction extends Equatable {
  const GoBackFromProductDetailsAction();

  @override
  List<Object?> get props => [];
}
