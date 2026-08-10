// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/repositories/products.repository.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/compare_prices.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/delete_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/edit_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/watch_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/rename_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/product_price_fetch_orchestrator_service.dart';
import 'package:worth_loop/shared/utils/product_url_cleaner_service.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/utils/android_price_alert_notification_service.dart';
import 'package:worth_loop/shared/utils/product_price_alert_notification_coordinator.dart';
import 'package:worth_loop/shared/utils/product_source_refresh_engine.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';

/// Registers tracked-product dependencies.
void initProductsDependencies() {
  sl.registerLazySingleton<ProductsLocalDatasource>(
    () => ProductsLocalDatasource(
      sl<AppDatabase>(),
      sl<LoggerService>(),
      sl<ProductUrlCleanerService>(),
    ),
  );
  sl.registerLazySingleton<PriceResponseDetector>(PriceResponseDetector.new);
  sl.registerLazySingleton<IProductsRemoteDatasource>(
    () => ProductsRemoteDatasource(
      sl<ProductPriceFetchOrchestratorService>(),
      sl<LoggerService>(),
    ),
  );
  sl.registerLazySingleton<ProductSourceRefreshEngine>(
    () => ProductSourceRefreshEngine(
      sl<ProductsLocalDatasource>(),
      sl<IProductsRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<IProductsRepository>(
    () => ProductsRepository(
      sl<ProductsLocalDatasource>(),
      sl<IProductsRemoteDatasource>(),
      sl<ProductSourceRefreshEngine>(),
    ),
  );
  sl.registerLazySingleton<LoadProductsUseCase>(
    () => LoadProductsUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<WatchProductsUseCase>(
    () => WatchProductsUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<AddSourceUseCase>(
    () => AddSourceUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<EditSourceUseCase>(
    () => EditSourceUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<DeleteSourceUseCase>(
    () => DeleteSourceUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<RefreshProductUseCase>(
    () => RefreshProductUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<RefreshSourceUseCase>(
    () => RefreshSourceUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<RefreshAllProductsUseCase>(
    () => RefreshAllProductsUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<ProductPriceAlertNotificationCoordinator>(
    () => ProductPriceAlertNotificationCoordinator(
      sl<LoadRefreshSettingsUseCase>(),
      sl<AppPreferencesStore>(),
      sl<AndroidPriceAlertNotificationService>(),
    ),
  );
  sl.registerLazySingleton<RenameProductUseCase>(
    () => RenameProductUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<ComparePricesUseCase>(ComparePricesUseCase.new);
  sl.registerFactoryParam<ProductDetailsViewModel, Store<AppState>, String>(
    (store, productId) => ProductDetailsViewModel.fromStore(store, productId),
  );
}
