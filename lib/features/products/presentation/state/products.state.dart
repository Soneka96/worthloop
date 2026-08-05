// Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/shared/constants/enums.dart';

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

  /// Classified reason for the latest refresh-all failure, or `null`.
  final PriceFetchStatus? refreshStatus;

  /// Classified reason for each product's latest refresh failure, keyed by
  /// product identifier.
  final Map<String, PriceFetchStatus> productRefreshStatuses;

  /// Whether a product is being created.
  final bool isCreatingProduct;

  /// The most recent product-creation failure, or `null`.
  final String? creationError;

  /// Identifier of the most recently created product, or `null`.
  final String? createdProductId;

  /// Saved website sources for each product, keyed by product identifier.
  final Map<String, List<ProductSource>> sourcesByProduct;

  /// Product identifiers whose sources are currently loading.
  final Set<String> loadingSourcesProductIds;

  const ProductsState({
    required this.products,
    required this.isLoading,
    required this.isRefreshingAll,
    required this.refreshingProductIds,
    required this.error,
    this.refreshStatus,
    required this.productRefreshStatuses,
    required this.isCreatingProduct,
    required this.creationError,
    required this.createdProductId,
    required this.sourcesByProduct,
    required this.loadingSourcesProductIds,
  });

  /// Returns the state used before products are loaded.
  factory ProductsState.initial() => const ProductsState(
    products: [],
    isLoading: false,
    isRefreshingAll: false,
    refreshingProductIds: {},
    error: null,
    productRefreshStatuses: {},
    isCreatingProduct: false,
    creationError: null,
    createdProductId: null,
    sourcesByProduct: {},
    loadingSourcesProductIds: {},
  );

  /// Returns a copy with the supplied fields replaced.
  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isRefreshingAll,
    Set<String>? refreshingProductIds,
    Option<String>? error,
    Option<PriceFetchStatus>? refreshStatus,
    Map<String, PriceFetchStatus>? productRefreshStatuses,
    bool? isCreatingProduct,
    Option<String>? creationError,
    Option<String>? createdProductId,
    Map<String, List<ProductSource>>? sourcesByProduct,
    Set<String>? loadingSourcesProductIds,
  }) => ProductsState(
    products: products ?? this.products,
    isLoading: isLoading ?? this.isLoading,
    isRefreshingAll: isRefreshingAll ?? this.isRefreshingAll,
    refreshingProductIds: refreshingProductIds ?? this.refreshingProductIds,
    error: error == null ? this.error : error.toNullable(),
    refreshStatus: refreshStatus == null
        ? this.refreshStatus
        : refreshStatus.toNullable(),
    productRefreshStatuses:
        productRefreshStatuses ?? this.productRefreshStatuses,
    isCreatingProduct: isCreatingProduct ?? this.isCreatingProduct,
    creationError: creationError == null
        ? this.creationError
        : creationError.toNullable(),
    createdProductId: createdProductId == null
        ? this.createdProductId
        : createdProductId.toNullable(),
    sourcesByProduct: sourcesByProduct ?? this.sourcesByProduct,
    loadingSourcesProductIds:
        loadingSourcesProductIds ?? this.loadingSourcesProductIds,
  );

  @override
  List<Object?> get props => [
    products,
    isLoading,
    isRefreshingAll,
    refreshingProductIds,
    error,
    refreshStatus,
    productRefreshStatuses,
    isCreatingProduct,
    creationError,
    createdProductId,
    sourcesByProduct,
    loadingSourcesProductIds,
  ];
}
