// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/data/repositories/products.repository.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/compare_prices.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';

/// Registers tracked-product dependencies.
void initProductsDependencies() {
  sl.registerLazySingleton<ProductsLocalDatasource>(
    () => ProductsLocalDatasource(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<IProductsRepository>(
    () => ProductsRepository(sl<ProductsLocalDatasource>()),
  );
  sl.registerLazySingleton<LoadProductsUseCase>(
    () => LoadProductsUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<RefreshProductUseCase>(
    () => RefreshProductUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<RefreshAllProductsUseCase>(
    () => RefreshAllProductsUseCase(sl<IProductsRepository>()),
  );
  sl.registerLazySingleton<ComparePricesUseCase>(ComparePricesUseCase.new);
}
