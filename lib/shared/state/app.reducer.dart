// Project imports:
import 'package:worth_loop/features/products/presentation/state/products.reducer.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Root reducer. Each feature reducer is combined here as features are built.
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    products: productsReducer(state.products, action),
    refreshSettings: refreshSettingsReducer(state.refreshSettings, action),
  );
}
