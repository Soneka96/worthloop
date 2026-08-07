// Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/refresh_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/url_launcher_service.dart';

/// Handles tracked-product actions.
class ProductsMiddleware extends MiddlewareClass<AppState> {
  bool _refreshInProgress = false;

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
      case AddSourceAction _:
        _addSource(store, action);
      case EditSourceAction _:
        _editSource(store, action);
      case DeleteSourceAction _:
        _deleteSource(store, action);
      case OpenOfferUrlAction _:
        _openOfferUrl(store, action);
      case RenameProductAction _:
        _renameProduct(store, action);
      case DeleteProductAction _:
        _deleteProduct(store, action);
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
    if (_refreshInProgress) {
      return;
    }
    _refreshInProgress = true;
    final List<String> sourceIds = _sourceIdsForProduct(
      store,
      action.productId,
    );
    int completedCount = 0;
    int failedCount = 0;
    store.dispatch(SourceRefreshStartedAction(sourceIds));
    try {
      await (await sl<RefreshProductUseCase>()(
        RefreshProductParams(
          productId: action.productId,
          onSourceStatusChanged: (String sourceId, SourceRefreshStatus status) {
            if (_isTerminalSourceRefreshStatus(status)) {
              completedCount++;
            }
            if (status == SourceRefreshStatus.error) {
              failedCount++;
            }
            store.dispatch(
              SourceRefreshStatusChangedAction(
                sourceId: sourceId,
                status: status,
              ),
            );
          },
        ),
      )).fold(
        (failure) async {
          sl<LoggerService>().e(failure.message, showPopup: true);
          if (sourceIds.isNotEmpty) {
            final Either<Failure, List<Product>> productsResult =
                await sl<LoadProductsUseCase>()(NoParams());
            productsResult.fold((_) {}, (List<Product> products) {
              store.dispatch(ProductsLoadedAction(products));
            });
          }
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
      _showRefreshCompletion(
        sourceCount: sourceIds.length,
        completedCount: completedCount,
        failedCount: failedCount,
      );
    } finally {
      store.dispatch(const SourceRefreshFinishedAction());
      _refreshInProgress = false;
    }
  }

  /// Handles [RefreshAllProductsAction].
  Future<void> _refreshAllProducts(
    Store<AppState> store,
    RefreshAllProductsAction action,
  ) async {
    if (_refreshInProgress) {
      return;
    }
    _refreshInProgress = true;
    final List<String> sourceIds = _sourceIdsForAllProducts(store);
    int completedCount = 0;
    int failedCount = 0;
    store.dispatch(SourceRefreshStartedAction(sourceIds));
    try {
      await (await sl<RefreshAllProductsUseCase>()(
        NoParams(),
        onSourceStatusChanged: (String sourceId, SourceRefreshStatus status) {
          if (_isTerminalSourceRefreshStatus(status)) {
            completedCount++;
          }
          if (status == SourceRefreshStatus.error) {
            failedCount++;
          }
          store.dispatch(
            SourceRefreshStatusChangedAction(
              sourceId: sourceId,
              status: status,
            ),
          );
        },
      )).fold(
        (failure) async {
          sl<LoggerService>().e(failure.message, showPopup: true);
          if (sourceIds.isNotEmpty) {
            final Either<Failure, List<Product>> productsResult =
                await sl<LoadProductsUseCase>()(NoParams());
            productsResult.fold((_) {}, (List<Product> products) {
              store.dispatch(ProductsLoadedAction(products));
            });
          }
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
      _showRefreshCompletion(
        sourceCount: sourceIds.length,
        completedCount: completedCount,
        failedCount: failedCount,
      );
    } finally {
      store.dispatch(const SourceRefreshFinishedAction());
      _refreshInProgress = false;
    }
  }

  List<String> _sourceIdsForProduct(Store<AppState> store, String productId) {
    for (final Product product in store.state.products.products) {
      if (product.id == productId) {
        return product.sources
            .map((ProductSource source) => source.id)
            .toList();
      }
    }
    return [];
  }

  List<String> _sourceIdsForAllProducts(Store<AppState> store) => store
      .state
      .products
      .products
      .expand((Product product) => product.sources)
      .map((ProductSource source) => source.id)
      .toList();

  void _showRefreshCompletion({
    required int sourceCount,
    required int completedCount,
    required int failedCount,
  }) {
    if (sourceCount == 0 || completedCount != sourceCount) {
      return;
    }
    final String message = failedCount == 0
        ? t.productDetails.refreshComplete(total: sourceCount)
        : t.productDetails.refreshPartial(
            completed: completedCount,
            total: sourceCount,
            failed: failedCount,
          );
    sl<LoggerService>().i(message, showPopup: true);
  }

  bool _isTerminalSourceRefreshStatus(SourceRefreshStatus status) =>
      status == SourceRefreshStatus.success ||
      status == SourceRefreshStatus.error ||
      status == SourceRefreshStatus.unavailable;

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

  /// Handles [AddSourceAction].
  Future<void> _addSource(Store<AppState> store, AddSourceAction action) async {
    (await sl<AddSourceUseCase>()(
      AddSourceParams(productId: action.productId, url: action.url),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(SourceAddFailedAction(failure.message));
      },
      (Product product) {
        store.dispatch(SourceAddedAction(product));
      },
    );
  }

  /// Handles [EditSourceAction].
  Future<void> _editSource(
    Store<AppState> store,
    EditSourceAction action,
  ) async {
    (await sl<EditSourceUseCase>()(
      EditSourceParams(sourceId: action.sourceId, url: action.url),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(SourceEditFailedAction(failure.message));
      },
      (Product product) {
        store.dispatch(SourceEditedAction(product));
      },
    );
  }

  /// Handles [DeleteSourceAction].
  Future<void> _deleteSource(
    Store<AppState> store,
    DeleteSourceAction action,
  ) async {
    (await sl<DeleteSourceUseCase>()(
      DeleteSourceParams(sourceId: action.sourceId),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(
          SourceDeleteFailedAction(
            sourceId: action.sourceId,
            message: failure.message,
          ),
        );
      },
      (Product product) {
        store.dispatch(
          SourceDeletedAction(sourceId: action.sourceId, product: product),
        );
      },
    );
  }

  /// Handles [OpenOfferUrlAction].
  Future<void> _openOfferUrl(
    Store<AppState> store,
    OpenOfferUrlAction action,
  ) async {
    final bool opened = await sl<UrlLauncherService>().open(action.url);
    if (!opened) {
      sl<LoggerService>().e(t.productDetails.openOfferFailed, showPopup: true);
    }
  }

  /// Handles [RenameProductAction].
  Future<void> _renameProduct(
    Store<AppState> store,
    RenameProductAction action,
  ) async {
    (await sl<RenameProductUseCase>()(
      RenameProductParams(productId: action.productId, name: action.name),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(ProductRenameFailedAction(failure.message));
      },
      (Product product) {
        store.dispatch(ProductRenamedAction(product));
      },
    );
  }

  /// Handles [DeleteProductAction].
  Future<void> _deleteProduct(
    Store<AppState> store,
    DeleteProductAction action,
  ) async {
    (await sl<DeleteProductUseCase>()(
      DeleteProductParams(productId: action.productId),
    )).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(
          ProductDeleteFailedAction(
            productId: action.productId,
            message: failure.message,
          ),
        );
      },
      (_) {
        store.dispatch(ProductDeletedAction(action.productId));
        sl<NavigatorService>().pop();
      },
    );
  }
}
