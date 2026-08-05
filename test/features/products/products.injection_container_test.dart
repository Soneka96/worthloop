// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/products_local.datasource.dart';
import 'package:worth_loop/features/products/domain/repositories/Iproducts.repository.dart';
import 'package:worth_loop/features/products/domain/usecases/add_source.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/compare_prices.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/create_product.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/load_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_all_products.usecase.dart';
import 'package:worth_loop/features/products/domain/usecases/refresh_product.usecase.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/products.injection_container.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/utils/currency_helper_service.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockDio extends Mock implements Dio {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  setUp(() {
    sl.registerSingleton<AppDatabase>(MockAppDatabase());
    sl.registerSingleton<Dio>(MockDio());
    sl.registerSingleton<CurrencyHelperService>(const CurrencyHelperService());
    sl.registerSingleton<LoggerService>(MockLoggerService());
    initProductsDependencies();
  });

  tearDown(() async => sl.reset());

  group('products.injection_container — product feature registrations', () {
    test('datasource is registered', () {
      expect(sl.isRegistered<ProductsLocalDatasource>(), isA<bool>());
      expect(sl.isRegistered<ProductsLocalDatasource>(), isTrue);
      expect(sl<ProductsLocalDatasource>(), isA<ProductsLocalDatasource>());
    });

    test('repository is registered', () {
      expect(sl.isRegistered<IProductsRepository>(), isA<bool>());
      expect(sl.isRegistered<IProductsRepository>(), isTrue);
      expect(sl<IProductsRepository>(), isA<IProductsRepository>());
    });

    test('usecases are registered', () {
      expect(sl.isRegistered<LoadProductsUseCase>(), isA<bool>());
      expect(sl.isRegistered<LoadProductsUseCase>(), isTrue);
      expect(sl.isRegistered<CreateProductUseCase>(), isA<bool>());
      expect(sl.isRegistered<CreateProductUseCase>(), isTrue);
      expect(sl.isRegistered<AddSourceUseCase>(), isA<bool>());
      expect(sl.isRegistered<AddSourceUseCase>(), isTrue);
      expect(sl.isRegistered<RefreshProductUseCase>(), isA<bool>());
      expect(sl.isRegistered<RefreshProductUseCase>(), isTrue);
      expect(sl.isRegistered<RefreshAllProductsUseCase>(), isA<bool>());
      expect(sl.isRegistered<RefreshAllProductsUseCase>(), isTrue);
      expect(sl.isRegistered<ComparePricesUseCase>(), isA<bool>());
      expect(sl.isRegistered<ComparePricesUseCase>(), isTrue);
      expect(sl<LoadProductsUseCase>(), isA<LoadProductsUseCase>());
      expect(sl<CreateProductUseCase>(), isA<CreateProductUseCase>());
      expect(sl<AddSourceUseCase>(), isA<AddSourceUseCase>());
      expect(sl<RefreshProductUseCase>(), isA<RefreshProductUseCase>());
      expect(sl<RefreshAllProductsUseCase>(), isA<RefreshAllProductsUseCase>());
      expect(sl<ComparePricesUseCase>(), isA<ComparePricesUseCase>());
    });

    test('viewmodels are registered', () {
      final Store<AppState> store = Store<AppState>(
        (AppState state, dynamic action) => state,
        initialState: AppState.initial(),
      );

      expect(sl.isRegistered<ProductDetailsViewModel>(), isA<bool>());
      expect(sl.isRegistered<ProductDetailsViewModel>(), isTrue);
      expect(
        sl<ProductDetailsViewModel>(param1: store, param2: 'product-1'),
        isA<ProductDetailsViewModel>(),
      );
    });
  });
}
