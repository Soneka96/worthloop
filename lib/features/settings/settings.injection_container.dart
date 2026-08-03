// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';

/// Registers the settings feature's dependencies. Called at the end of the
/// root [initDependencies].
void initSettingsDependencies() {
  sl.registerFactoryParam<
    GeneralSettingsScreenViewModel,
    Store<AppState>,
    void
  >((store, _) => GeneralSettingsScreenViewModel.fromStore(store));
}
