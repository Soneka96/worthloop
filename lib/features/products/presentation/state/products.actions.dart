// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
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

/// Requests creating a tracked product.
@immutable
class CreateProductAction extends Equatable {
  /// Product display name entered by the user.
  final String name;

  const CreateProductAction({required this.name});

  @override
  List<Object?> get props => [name];
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

/// Starts tracking the refresh of a product's sources.
@immutable
class SourceRefreshStartedAction extends Equatable {
  /// Identifiers of the sources being refreshed in display order.
  final List<String> sourceIds;

  const SourceRefreshStartedAction(this.sourceIds);

  @override
  List<Object?> get props => [sourceIds];
}

/// Updates the refresh state of one source.
@immutable
class SourceRefreshStatusChangedAction extends Equatable {
  /// Identifier of the source whose state changed.
  final String sourceId;

  /// New refresh state for the source.
  final SourceRefreshStatus status;

  const SourceRefreshStatusChangedAction({
    required this.sourceId,
    required this.status,
  });

  @override
  List<Object?> get props => [sourceId, status];
}

/// Clears the active source refresh progress.
@immutable
class SourceRefreshFinishedAction extends Equatable {
  const SourceRefreshFinishedAction();

  @override
  List<Object?> get props => [];
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

/// Carries the product with a newly added source applied.
@immutable
class SourceAddedAction extends Equatable {
  /// The product with the new source's offer applied.
  final Product product;

  const SourceAddedAction(this.product);

  @override
  List<Object?> get props => [product];
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

/// Carries the product with an edited source applied.
@immutable
class SourceEditedAction extends Equatable {
  /// The product with the edited source's offer applied.
  final Product product;

  const SourceEditedAction(this.product);

  @override
  List<Object?> get props => [product];
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

/// Carries the product with a deleted source removed.
@immutable
class SourceDeletedAction extends Equatable {
  /// Identifier of the deleted source.
  final String sourceId;

  /// The product without the deleted source.
  final Product product;

  const SourceDeletedAction({required this.sourceId, required this.product});

  @override
  List<Object?> get props => [sourceId, product];
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

/// Requests opening a merchant offer's product page in the device's default
/// browser.
@immutable
class OpenOfferUrlAction extends Equatable {
  /// The merchant offer's product-page URL.
  final String url;

  const OpenOfferUrlAction(this.url);

  @override
  List<Object?> get props => [url];
}

/// Requests renaming a product.
@immutable
class RenameProductAction extends Equatable {
  /// Identifier of the product to rename.
  final String productId;

  /// New display name entered for the product.
  final String name;

  const RenameProductAction({required this.productId, required this.name});

  @override
  List<Object?> get props => [productId, name];
}

/// Carries a renamed product.
@immutable
class ProductRenamedAction extends Equatable {
  /// The renamed product.
  final Product product;

  const ProductRenamedAction(this.product);

  @override
  List<Object?> get props => [product];
}

/// Carries a product-rename failure.
@immutable
class ProductRenameFailedAction extends Equatable {
  /// The failure message.
  final String message;

  const ProductRenameFailedAction(this.message);

  @override
  List<Object?> get props => [message];
}

/// Requests deleting a product.
@immutable
class DeleteProductAction extends Equatable {
  /// Identifier of the product to delete.
  final String productId;

  const DeleteProductAction(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Carries a deleted product.
@immutable
class ProductDeletedAction extends Equatable {
  /// Identifier of the deleted product.
  final String productId;

  const ProductDeletedAction(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Carries a product-delete failure.
@immutable
class ProductDeleteFailedAction extends Equatable {
  /// Identifier of the product that failed to delete.
  final String productId;

  /// The failure message.
  final String message;

  const ProductDeleteFailedAction({
    required this.productId,
    required this.message,
  });

  @override
  List<Object?> get props => [productId, message];
}
