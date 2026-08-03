// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.state.dart';

/// Reducer responsible for handling changes to [GeneralSettingsState] based
/// on dispatched actions.
///
/// [LoadGeneralSettingsAction] and [PickDefaultSaveLocationAction] are
/// middleware-only triggers with no state of their own — neither has a
/// [TypedReducer] here, so `combineReducers` leaves the state unchanged for
/// them.
Reducer<GeneralSettingsState> generalSettingsReducer =
    combineReducers<GeneralSettingsState>([
      /// Handles the persisted General settings being read from disk.
      /// Replaces every [GeneralSettingsState] field.
      TypedReducer<GeneralSettingsState, GeneralSettingsLoadedAction>(
        generalSettingsLoadedReducer,
      ).call,

      /// Handles a change to the pending data-root move. Updates
      /// [GeneralSettingsState.pendingDataRoot] directly rather than via
      /// `copyWith`, since `null` here means "clear it," not "leave the
      /// previous value."
      TypedReducer<GeneralSettingsState, PendingDataRootUpdatedAction>(
        pendingDataRootUpdatedReducer,
      ).call,
    ]);

/// Handles the persisted General settings being read from disk.
/// Updates every [GeneralSettingsState] field.
GeneralSettingsState generalSettingsLoadedReducer(
  GeneralSettingsState state,
  GeneralSettingsLoadedAction action,
) => state.copyWith(
  defaultSaveLocation: action.defaultSaveLocation,
  pendingDataRoot: action.pendingDataRoot,
);

/// Handles a change to the pending data-root move.
/// Updates [GeneralSettingsState.pendingDataRoot].
GeneralSettingsState pendingDataRootUpdatedReducer(
  GeneralSettingsState state,
  PendingDataRootUpdatedAction action,
) => GeneralSettingsState(
  defaultSaveLocation: state.defaultSaveLocation,
  pendingDataRoot: action.pendingDataRoot,
);
