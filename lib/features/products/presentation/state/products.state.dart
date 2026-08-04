// Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';

/// Redux state for tracked products.
@immutable
class ProductsState extends Equatable {
  /// Every tracked product.
  final List<Product> products;

  /// Whether products are being loaded.
  final bool isLoading;

  /// Whether every product is being refreshed.
  final bool isRefreshingAll;

  /// Product identifiers currently being refreshed.
  final Set<String> refreshingProductIds;

  /// The most recent operation failure, or `null`.
  final String? error;

  /// Whether a product is being created.
  final bool isCreatingProduct;

  /// The most recent product-creation failure, or `null`.
  final String? creationError;

  /// Identifier of the most recently created product, or `null`.
  final String? createdProductId;

  const ProductsState({
    required this.products,
    required this.isLoading,
    required this.isRefreshingAll,
    required this.refreshingProductIds,
    required this.error,
    required this.isCreatingProduct,
    required this.creationError,
    required this.createdProductId,
  });

  /// Returns the state used before products are loaded.
  factory ProductsState.initial() => const ProductsState(
    products: [],
    isLoading: false,
    isRefreshingAll: false,
    refreshingProductIds: {},
    error: null,
    isCreatingProduct: false,
    creationError: null,
    createdProductId: null,
  );

  /// Returns a copy with the supplied fields replaced.
  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isRefreshingAll,
    Set<String>? refreshingProductIds,
    Option<String>? error,
    bool? isCreatingProduct,
    Option<String>? creationError,
    Option<String>? createdProductId,
  }) => ProductsState(
    products: products ?? this.products,
    isLoading: isLoading ?? this.isLoading,
    isRefreshingAll: isRefreshingAll ?? this.isRefreshingAll,
    refreshingProductIds: refreshingProductIds ?? this.refreshingProductIds,
    error: error == null ? this.error : error.toNullable(),
    isCreatingProduct: isCreatingProduct ?? this.isCreatingProduct,
    creationError: creationError == null
        ? this.creationError
        : creationError.toNullable(),
    createdProductId: createdProductId == null
        ? this.createdProductId
        : createdProductId.toNullable(),
  );

  @override
  List<Object?> get props => [
    products,
    isLoading,
    isRefreshingAll,
    refreshingProductIds,
    error,
    isCreatingProduct,
    creationError,
    createdProductId,
  ];
}
