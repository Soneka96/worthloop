// Dart imports:
import 'dart:async';

// Package imports:
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
import 'package:worth_loop/features/products/domain/usecases/watch_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/params/add_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/create_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';
import 'package:worth_loop/features/products/domain/usecases/params/rename_product.params.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/navigation/app_routes.dart';
import 'package:worth_loop/shared/navigation/navigator_service.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/url_launcher_service.dart';
import 'package:worth_loop/shared/utils/android_background_refresh_service.dart';

/// Handles tracked-product actions.
class ProductsMiddleware extends MiddlewareClass<AppState> {
  StreamSubscription<List<Product>>? _productsSubscription;
  Timer? _refreshPollTimer;

  // The background engine's DB writes don't reach this engine's reactive
  // watch() stream (separate isolates, separate connections), so this polls
  // the same query as a fallback while a refresh is active.
  static const Duration _refreshPollInterval = Duration(seconds: 1);

  // Caps poll ticks so a refresh that never drains can't poll forever.
  static const int _maxRefreshPollTicks = 300;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    switch (action) {
      case LoadProductsAction _:
        _ensureProductsSubscription(store);
        _loadProducts(store, action);
      case ReconcileBackgroundRefreshAction _:
        _reconcileBackgroundRefresh(store);
      case CreateProductAction _:
        _createProduct(store, action);
      case RefreshProductAction _:
        _refreshProduct(store, action);
      case RefreshSourceAction _:
        _refreshSource(store, action);
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

  void _ensureProductsSubscription(Store<AppState> store) {
    if (_productsSubscription != null) {
      return;
    }
    _productsSubscription = sl<WatchProductsUseCase>()(NoParams()).listen(
      (List<Product> products) {
        store.dispatch(ProductsUpdatedFromDatabaseAction(products));
      },
      onError: (Object error, StackTrace stackTrace) {
        sl<LoggerService>().e(error.toString());
      },
    );
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

  /// Reloads persisted background results and clears refresh progress.
  Future<void> _reconcileBackgroundRefresh(Store<AppState> store) async {
    final bool? refreshSucceeded = await sl<AppPreferencesStore>()
        .consumeBackgroundRefreshCompletion();
    if (refreshSucceeded == null) {
      return;
    }
    await (await sl<LoadProductsUseCase>()(NoParams())).fold(
      (failure) {
        sl<LoggerService>().e(failure.message, showPopup: true);
        store.dispatch(ProductsLoadFailedAction(failure.message));
      },
      (List<Product> products) {
        store.dispatch(ProductsLoadedAction(products));
      },
    );
    if (!refreshSucceeded) {
      store.dispatch(RefreshAllProductsFailedAction(t.common.refreshFailed));
    }
    store.dispatch(const SourceRefreshFinishedAction());
  }

  /// Handles [RefreshProductAction].
  ///
  /// Enqueues the product's sources on the background service and returns —
  /// fetch results are not awaited here, they land in the database as each
  /// source completes.
  Future<void> _refreshProduct(
    Store<AppState> store,
    RefreshProductAction action,
  ) async {
    final List<String> sourceIds = _sourceIdsForProduct(
      store,
      action.productId,
    );
    if (sourceIds.isEmpty) {
      return;
    }
    await _enqueueOrShowFailure(sourceIds, store: store);
  }

  /// Handles [RefreshSourceAction].
  ///
  /// Enqueues the single source, bypassing its cooldown since this is a
  /// deliberate, user-initiated retry.
  Future<void> _refreshSource(
    Store<AppState> store,
    RefreshSourceAction action,
  ) async {
    await _enqueueOrShowFailure(
      [action.sourceId],
      store: store,
      bypassCooldown: true,
    );
  }

  /// Handles [RefreshAllProductsAction].
  ///
  /// Enqueues every tracked source on the background service and returns —
  /// fetch results are not awaited here, they land in the database as each
  /// source completes.
  Future<void> _refreshAllProducts(
    Store<AppState> store,
    RefreshAllProductsAction action,
  ) async {
    final List<String> sourceIds = _sourceIdsForAllProducts(store);
    if (sourceIds.isEmpty) {
      return;
    }
    await _enqueueOrShowFailure(sourceIds, store: store);
  }

  Future<void> _enqueueOrShowFailure(
    List<String> sourceIds, {
    required Store<AppState> store,
    bool bypassCooldown = false,
  }) async {
    final bool requested = await sl<AndroidBackgroundRefreshService>()
        .enqueueSources(sourceIds, bypassCooldown: bypassCooldown);
    if (!requested) {
      sl<LoggerService>().e(t.common.refreshFailed, showPopup: true);
      return;
    }
    _startRefreshPolling(store);
  }

  void _startRefreshPolling(Store<AppState> store) {
    if (_refreshPollTimer != null) {
      return;
    }
    int ticksRemaining = _maxRefreshPollTicks;
    _refreshPollTimer = Timer.periodic(_refreshPollInterval, (
      Timer timer,
    ) async {
      ticksRemaining--;
      final bool stillActive = await _pollRefreshProgress(store);
      if (!stillActive || ticksRemaining <= 0) {
        timer.cancel();
        _refreshPollTimer = null;
      }
    });
  }

  // Returns whether any source is still queued/fetching, so
  // _startRefreshPolling knows whether to keep ticking.
  Future<bool> _pollRefreshProgress(Store<AppState> store) async {
    return (await sl<LoadProductsUseCase>()(NoParams())).fold(
      (failure) {
        sl<LoggerService>().w(failure.message);
        return true;
      },
      (List<Product> products) {
        store.dispatch(ProductsUpdatedFromDatabaseAction(products));
        return _hasActiveSource(products);
      },
    );
  }

  bool _hasActiveSource(List<Product> products) => products.any(
    (Product product) => product.sources.any(
      (ProductSource source) =>
          source.liveStatus == SourceRefreshStatus.queued ||
          source.liveStatus == SourceRefreshStatus.fetching,
    ),
  );

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
