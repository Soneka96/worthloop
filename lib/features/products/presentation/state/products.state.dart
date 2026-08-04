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

  const ProductsState({
    required this.products,
    required this.isLoading,
    required this.isRefreshingAll,
    required this.refreshingProductIds,
    required this.error,
  });

  /// Returns the state used before products are loaded.
  factory ProductsState.initial() => const ProductsState(
    products: [],
    isLoading: false,
    isRefreshingAll: false,
    refreshingProductIds: {},
    error: null,
  );

  /// Returns a copy with the supplied fields replaced.
  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isRefreshingAll,
    Set<String>? refreshingProductIds,
    Option<String>? error,
  }) => ProductsState(
    products: products ?? this.products,
    isLoading: isLoading ?? this.isLoading,
    isRefreshingAll: isRefreshingAll ?? this.isRefreshingAll,
    refreshingProductIds: refreshingProductIds ?? this.refreshingProductIds,
    error: error == null ? this.error : error.toNullable(),
  );

  @override
  List<Object?> get props => [
    products,
    isLoading,
    isRefreshingAll,
    refreshingProductIds,
    error,
  ];
}
