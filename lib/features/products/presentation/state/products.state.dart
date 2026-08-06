// Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
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

  /// Whether a source is being added.
  final bool isAddingSource;

  /// The most recent source-add failure, or `null`.
  final String? addSourceError;

  /// Identifier of the source currently being edited, or `null`.
  final String? editingSourceId;

  /// The most recent source-edit failure, or `null`.
  final String? editSourceError;

  /// Source identifiers currently being deleted.
  final Set<String> deletingSourceIds;

  /// The most recent source-delete failure, or `null`.
  final String? deleteSourceError;

  /// Whether a product is being renamed.
  final bool isRenamingProduct;

  /// The most recent product-rename failure, or `null`.
  final String? renameProductError;

  /// Product identifiers currently being deleted.
  final Set<String> deletingProductIds;

  /// The most recent product-delete failure, or `null`.
  final String? deleteProductError;

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
    required this.isAddingSource,
    required this.addSourceError,
    required this.editingSourceId,
    required this.editSourceError,
    required this.deletingSourceIds,
    required this.deleteSourceError,
    required this.isRenamingProduct,
    required this.renameProductError,
    required this.deletingProductIds,
    required this.deleteProductError,
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
    isAddingSource: false,
    addSourceError: null,
    editingSourceId: null,
    editSourceError: null,
    deletingSourceIds: {},
    deleteSourceError: null,
    isRenamingProduct: false,
    renameProductError: null,
    deletingProductIds: {},
    deleteProductError: null,
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
    bool? isAddingSource,
    Option<String>? addSourceError,
    Option<String>? editingSourceId,
    Option<String>? editSourceError,
    Set<String>? deletingSourceIds,
    Option<String>? deleteSourceError,
    bool? isRenamingProduct,
    Option<String>? renameProductError,
    Set<String>? deletingProductIds,
    Option<String>? deleteProductError,
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
    isAddingSource: isAddingSource ?? this.isAddingSource,
    addSourceError: addSourceError == null
        ? this.addSourceError
        : addSourceError.toNullable(),
    editingSourceId: editingSourceId == null
        ? this.editingSourceId
        : editingSourceId.toNullable(),
    editSourceError: editSourceError == null
        ? this.editSourceError
        : editSourceError.toNullable(),
    deletingSourceIds: deletingSourceIds ?? this.deletingSourceIds,
    deleteSourceError: deleteSourceError == null
        ? this.deleteSourceError
        : deleteSourceError.toNullable(),
    isRenamingProduct: isRenamingProduct ?? this.isRenamingProduct,
    renameProductError: renameProductError == null
        ? this.renameProductError
        : renameProductError.toNullable(),
    deletingProductIds: deletingProductIds ?? this.deletingProductIds,
    deleteProductError: deleteProductError == null
        ? this.deleteProductError
        : deleteProductError.toNullable(),
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
    isAddingSource,
    addSourceError,
    editingSourceId,
    editSourceError,
    deletingSourceIds,
    deleteSourceError,
    isRenamingProduct,
    renameProductError,
    deletingProductIds,
    deleteProductError,
  ];
}
