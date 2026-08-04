// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/home.actions.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/products/domain/entities/product.entity.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/state/products.state.dart';
import 'package:worth_loop/shared/state/app.state.dart';
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

  group(
    'HomeScreenViewModel constructor initializes all parameters correctly',
    () {
      test('Method fromStore() constructs HomeScreenViewModel correctly', () {
        final Product product = buildProduct();
        final AppState state = AppState.initial().copyWith(
          products: ProductsState.initial().copyWith(
            products: [product],
            isLoading: true,
            isRefreshingAll: true,
          ),
        );

        final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
          buildStore(state),
        );

        expect(viewmodel.products, [product]);
        expect(viewmodel.isLoading, isA<bool>());
        expect(viewmodel.isLoading, isTrue);
        expect(viewmodel.isRefreshingAll, isA<bool>());
        expect(viewmodel.isRefreshingAll, isTrue);
        expect(viewmodel.onRefreshAll, isA<Function()>());
        expect(viewmodel.onOpenSettings, isA<Function()>());
      });

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

      test(
        'Method onOpenSettings dispatches GoToSettingsAction when called',
        () {
          final HomeScreenViewModel viewmodel = HomeScreenViewModel.fromStore(
            buildStore(AppState.initial()),
          );

          viewmodel.onOpenSettings();

          expect(dispatchedActions, [const GoToSettingsAction()]);
        },
      );
    },
  );
}
