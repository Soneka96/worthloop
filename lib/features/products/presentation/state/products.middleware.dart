// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_product_sources.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/load_product_sources.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Handles tracked-product actions.
class ProductsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case LoadProductsAction _:
        _loadProducts(store, action);
      case CreateProductAction _:
        _createProduct(store, action);
      case RefreshProductAction _:
        _refreshProduct(store, action);
      case RefreshAllProductsAction _:
        _refreshAllProducts(store, action);
      case GoToProductDetailsAction _:
        _goToProductDetails(store, action);
      case GoBackFromProductDetailsAction _:
        _goBackFromProductDetails(store, action);
      case LoadProductSourcesAction _:
        _loadProductSources(store, action);
    }
  }

  /// Handles [CreateProductAction].
  Future<void> _createProduct(
    Store<AppState> store,
    CreateProductAction action,
  ) async {
    (await sl<CreateProductUseCase>()(
      CreateProductParams(name: action.name),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(ProductCreationFailedAction(failure.message));
      },
      (Product product) {
        store.dispatch(ProductCreatedAction(product));
      },
    );
  }

  /// Handles [LoadProductsAction].
  Future<void> _loadProducts(
    Store<AppState> store,
    LoadProductsAction action,
  ) async {
    (await sl<LoadProductsUseCase>()(NoParams())).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(ProductsLoadFailedAction(failure.message));
      },
      (List<Product> products) {
        store.dispatch(ProductsLoadedAction(products));
      },
    );
  }

  /// Handles [RefreshProductAction].
  Future<void> _refreshProduct(
    Store<AppState> store,
    RefreshProductAction action,
  ) async {
    (await sl<RefreshProductUseCase>()(
      RefreshProductParams(productId: action.productId),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(
          ProductRefreshFailedAction(
            productId: action.productId,
            message: failure.message,
            status: failure is PriceFetchFailure ? failure.status : null,
          ),
        );
      },
      (Product product) {
        store.dispatch(ProductRefreshedAction(product));
      },
    );
  }

  /// Handles [RefreshAllProductsAction].
  Future<void> _refreshAllProducts(
    Store<AppState> store,
    RefreshAllProductsAction action,
  ) async {
    (await sl<RefreshAllProductsUseCase>()(NoParams())).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(
          RefreshAllProductsFailedAction(
            failure.message,
            status: failure is PriceFetchFailure ? failure.status : null,
          ),
        );
      },
      (List<Product> products) {
        store.dispatch(ProductsLoadedAction(products));
      },
    );
  }

  /// Handles [GoToProductDetailsAction].
  Future<void> _goToProductDetails(
    Store<AppState> store,
    GoToProductDetailsAction action,
  ) {
    sl<NavigatorService>().push(AppRoutes.productDetailsPath(action.productId));
    return Future<void>.value();
  }

  /// Handles [GoBackFromProductDetailsAction].
  Future<void> _goBackFromProductDetails(
    Store<AppState> store,
    GoBackFromProductDetailsAction action,
  ) {
    sl<NavigatorService>().pop();
    return Future<void>.value();
  }

  /// Handles [LoadProductSourcesAction].
  Future<void> _loadProductSources(
    Store<AppState> store,
    LoadProductSourcesAction action,
  ) async {
    (await sl<LoadProductSourcesUseCase>()(
      LoadProductSourcesParams(productId: action.productId),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(
          ProductSourcesLoadFailedAction(
            productId: action.productId,
            message: failure.message,
          ),
        );
      },
      (List<ProductSource> sources) {
        store.dispatch(
          ProductSourcesLoadedAction(
            productId: action.productId,
            sources: sources,
          ),
        );
      },
    );
  }
}
