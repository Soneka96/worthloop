// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Registers the Home feature's dependencies. Called at the end of the root
/// [initDependencies].
void initHomeDependencies() {
  sl.registerFactoryParam<HomeScreenViewModel, Store<AppState>, void>(
    (store, _) => HomeScreenViewModel.fromStore(store),
  );
}
