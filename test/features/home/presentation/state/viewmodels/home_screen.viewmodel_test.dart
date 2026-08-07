// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import '../../../../products/fixtures/product.fixture.dart';

void main() {
  late List<dynamic> dispatchedActions;

  Store<AppState> buildStore(AppState initialState) {
    return Store<AppState>((AppState appState, dynamic action) {
      dispatchedActions.add(action);
      return appState;
    }, initialState: initialState);
  }

  setUp(() {
    dispatchedActions = [];
  });

  group('HomeScreenViewModel constructor initializes all parameters correctly', () {
    test('Method fromStore() constructs HomeScreenViewModel correctly', () {
      final Product product = buildProduct();
      final AppState state = AppState.initial().copyWith(
        products: ProductsState.initial().copyWith(
          products: [product],
          isLoading: true,
          isRefreshingAll: true,
          refreshCompletedCount: 18,
          refreshTotalCount: 42,
          isCreatingProduct: true,
          creationError: const Some('creation failed'),
          createdProductId: const Some('product-1'),
          sourceRefreshStatuses: {'source-1': SourceRefreshStatus.error},
        ),
        refreshSettings: RefreshSettingsState.initial().copyWith(
          intervalMinutes: 180,
        ),
      );

      final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
        buildStore(state),
      );

      expect(viewmodel.products, [product]);
      expect(viewmodel.latestUpdatedAt, product.lastUpdatedAt);
      expect(viewmodel.oldestUpdatedAt, product.lastUpdatedAt);
      expect(viewmodel.isLoading, isA<bool>());
      expect(viewmodel.isLoading, isTrue);
      expect(viewmodel.isRefreshingAll, isA<bool>());
      expect(viewmodel.isRefreshingAll, isTrue);
      expect(viewmodel.isRefreshing, isA<bool>());
      expect(viewmodel.isRefreshing, isTrue);
      expect(viewmodel.refreshCompletedCount, isA<int>());
      expect(viewmodel.refreshCompletedCount, 18);
      expect(viewmodel.refreshTotalCount, isA<int>());
      expect(viewmodel.refreshTotalCount, 42);
      expect(viewmodel.refreshIntervalMinutes, isA<int>());
      expect(viewmodel.refreshIntervalMinutes, 180);
      expect(viewmodel.isCreatingProduct, isTrue);
      expect(viewmodel.productCreationError, 'creation failed');
      expect(viewmodel.createdProductId, 'product-1');
      expect(viewmodel.sourceRefreshStatuses, {
        'source-1': SourceRefreshStatus.error,
      });
      expect(viewmodel.onRefreshAll, isA<Function()>());
      expect(viewmodel.onOpenSettings, isA<Function()>());
      expect(viewmodel.onOpenProduct, isA<void Function(String)>());
      expect(viewmodel.onCreateProduct, isA<void Function(String)>());
    });

    test(
      'Method fromStore() constructs different latest and oldest timestamps correctly',
      () {
        final Product older = buildProduct(
          id: 'older',
          lastUpdatedAt: DateTime(2026, 1, 1),
        );
        final Product newer = buildProduct(
          id: 'newer',
          lastUpdatedAt: DateTime(2026, 1, 2),
        );
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(products: [older, newer]),
        );

        final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
          buildStore(state),
        );

        expect(viewmodel.latestUpdatedAt, newer.lastUpdatedAt);
        expect(viewmodel.oldestUpdatedAt, older.lastUpdatedAt);
      },
    );

    test(
      'Method fromStore() returns isRefreshing when a source refresh is active',
      () {
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(refreshTotalCount: 1),
        );

        final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
          buildStore(state),
        );

        expect(viewmodel.isRefreshing, isA<bool>());
        expect(viewmodel.isRefreshing, isTrue);
      },
    );

    test(
      'Method onRefreshAll dispatches RefreshAllProductsAction when called',
      () {
        final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
          buildStore(AppState.initial()),
        );

        viewmodel.onRefreshAll();

        expect(dispatchedActions, [const RefreshAllProductsAction()]);
      },
    );

    test('Method onOpenSettings dispatches GoToSettingsAction when called', () {
      final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
        buildStore(AppState.initial()),
      );

      viewmodel.onOpenSettings();

      expect(dispatchedActions, [const GoToSettingsAction()]);
    });

    test(
      'Method onOpenProduct dispatches GoToProductDetailsAction when called',
      () {
        final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
          buildStore(AppState.initial()),
        );

        viewmodel.onOpenProduct('product-1');

        expect(dispatchedActions, [
          const GoToProductDetailsAction('product-1'),
        ]);
      },
    );

    test(
      'Method onCreateProduct dispatches CreateProductAction when called',
      () {
        final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
          buildStore(AppState.initial()),
        );

        viewmodel.onCreateProduct('Example Product');

        expect(dispatchedActions, [
          const CreateProductAction(name: 'Example Product'),
        ]);
      },
    );
  });
}
