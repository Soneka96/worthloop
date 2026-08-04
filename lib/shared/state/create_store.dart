// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/home.middleware.dart';
import 'package:worth_loop/features/products/presentation/state/products.middleware.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.middleware.dart';
import 'package:worth_loop/main.dart';
import 'package:worth_loop/shared/state/app.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Builds the app's Redux [Store].
///
/// Each feature middleware is added to the list here as that feature is
/// built. Used by [App] — see `lib/main.dart`.
class CreateStore {
  /// Builds and returns the app's Redux [Store], wired with every feature's
  /// reducer and middleware.
  Store<AppState> call() {
    return Store<AppState>(
      appReducer,
      initialState: AppState.initial(),
      distinct: true,
      middleware: [
        GeneralSettingsMiddleware().call,
        HomeMiddleware().call,
        ProductsMiddleware().call,
      ],
    );
  }
}
