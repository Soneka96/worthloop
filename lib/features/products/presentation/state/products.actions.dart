// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';

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

  // TODO: url is unused by ProductsMiddleware pending a dedicated add-source
  // flow — CreateProductUseCase no longer accepts a source at creation time.
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

  /// Classified reason for the failed refresh, when available.
  final PriceFetchStatus? status;

  const ProductRefreshFailedAction({
    required this.productId,
    required this.message,
    this.status,
  });

  @override
  List<Object?> get props => [productId, message, status];
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

  /// Classified reason for the failed refresh, when available.
  final PriceFetchStatus? status;

  const RefreshAllProductsFailedAction(this.message, {this.status});

  @override
  List<Object?> get props => [message, status];
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

/// Requests loading every saved source for one product.
@immutable
class LoadProductSourcesAction extends Equatable {
  /// Identifier of the product whose sources are loaded.
  final String productId;

  const LoadProductSourcesAction(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Carries the sources loaded for one product.
@immutable
class ProductSourcesLoadedAction extends Equatable {
  /// Identifier of the product these sources belong to.
  final String productId;

  /// The loaded sources.
  final List<ProductSource> sources;

  const ProductSourcesLoadedAction({
    required this.productId,
    required this.sources,
  });

  @override
  List<Object?> get props => [productId, sources];
}

/// Carries a sources-loading failure for one product.
@immutable
class ProductSourcesLoadFailedAction extends Equatable {
  /// Identifier of the product whose sources failed to load.
  final String productId;

  /// The failure message.
  final String message;

  const ProductSourcesLoadFailedAction({
    required this.productId,
    required this.message,
  });

  @override
  List<Object?> get props => [productId, message];
}

/// Requests adding a website source to a product.
@immutable
class AddSourceAction extends Equatable {
  /// Identifier of the product to attach this source to.
  final String productId;

  /// HTTPS website link entered for the source.
  final String url;

  const AddSourceAction({required this.productId, required this.url});

  @override
  List<Object?> get props => [productId, url];
}

/// Carries a newly added source.
@immutable
class SourceAddedAction extends Equatable {
  /// The newly added source.
  final ProductSource source;

  const SourceAddedAction(this.source);

  @override
  List<Object?> get props => [source];
}

/// Carries a source-add failure.
@immutable
class SourceAddFailedAction extends Equatable {
  /// The failure message.
  final String message;

  const SourceAddFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests editing a saved source's URL.
@immutable
class EditSourceAction extends Equatable {
  /// Identifier of the source to update.
  final String sourceId;

  /// New HTTPS website link for the source.
  final String url;

  const EditSourceAction({required this.sourceId, required this.url});

  @override
  List<Object?> get props => [sourceId, url];
}

/// Carries an edited source.
@immutable
class SourceEditedAction extends Equatable {
  /// The updated source.
  final ProductSource source;

  const SourceEditedAction(this.source);

  @override
  List<Object?> get props => [source];
}

/// Carries a source-edit failure.
@immutable
class SourceEditFailedAction extends Equatable {
  /// The failure message.
  final String message;

  const SourceEditFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests deleting a saved source.
@immutable
class DeleteSourceAction extends Equatable {
  /// Identifier of the product this source belongs to.
  final String productId;

  /// Identifier of the source to delete.
  final String sourceId;

  const DeleteSourceAction({required this.productId, required this.sourceId});

  @override
  List<Object?> get props => [productId, sourceId];
}

/// Carries a deleted source.
@immutable
class SourceDeletedAction extends Equatable {
  /// Identifier of the product this source belonged to.
  final String productId;

  /// Identifier of the deleted source.
  final String sourceId;

  const SourceDeletedAction({required this.productId, required this.sourceId});

  @override
  List<Object?> get props => [productId, sourceId];
}

/// Carries a source-delete failure.
@immutable
class SourceDeleteFailedAction extends Equatable {
  /// Identifier of the source that failed to delete.
  final String sourceId;

  /// The failure message.
  final String message;

  const SourceDeleteFailedAction({
    required this.sourceId,
    required this.message,
  });

  @override
  List<Object?> get props => [sourceId, message];
}
