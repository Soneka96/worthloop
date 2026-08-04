// Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/refresh_settings.state.dart';

/// Reduces actions into [RefreshSettingsState].
Reducer<RefreshSettingsState>
refreshSettingsReducer = combineReducers<RefreshSettingsState>([
  /// Handles [LoadRefreshSettingsAction].
  /// Updates [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, LoadRefreshSettingsAction>(
    loadRefreshSettingsReducer,
  ).call,

  /// Handles [RefreshSettingsLoadedAction].
  /// Updates [RefreshSettingsState.intervalMinutes], [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshSettingsLoadedAction>(
    refreshSettingsLoadedReducer,
  ).call,

  /// Handles [RefreshSettingsLoadFailedAction].
  /// Updates [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshSettingsLoadFailedAction>(
    refreshSettingsLoadFailedReducer,
  ).call,

  /// Handles [SaveRefreshIntervalAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, SaveRefreshIntervalAction>(
    saveRefreshIntervalReducer,
  ).call,

  /// Handles [RefreshIntervalSavedAction].
  /// Updates [RefreshSettingsState.intervalMinutes], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshIntervalSavedAction>(
    refreshIntervalSavedReducer,
  ).call,

  /// Handles [RefreshIntervalSaveFailedAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshIntervalSaveFailedAction>(
    refreshIntervalSaveFailedReducer,
  ).call,
]);

/// Handles [LoadRefreshSettingsAction].
/// Updates [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
RefreshSettingsState loadRefreshSettingsReducer(
  RefreshSettingsState state,
  LoadRefreshSettingsAction action,
) => state.copyWith(isLoading: true, error: const None());

/// Handles [RefreshSettingsLoadedAction].
/// Updates [RefreshSettingsState.intervalMinutes], [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
RefreshSettingsState refreshSettingsLoadedReducer(
  RefreshSettingsState state,
  RefreshSettingsLoadedAction action,
) => state.copyWith(
  intervalMinutes: action.settings.intervalMinutes,
  isLoading: false,
  error: const None(),
);

/// Handles [RefreshSettingsLoadFailedAction].
/// Updates [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
RefreshSettingsState refreshSettingsLoadFailedReducer(
  RefreshSettingsState state,
  RefreshSettingsLoadFailedAction action,
) => state.copyWith(isLoading: false, error: Some(action.message));

/// Handles [SaveRefreshIntervalAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState saveRefreshIntervalReducer(
  RefreshSettingsState state,
  SaveRefreshIntervalAction action,
) => state.copyWith(isSaving: true, error: const None());

/// Handles [RefreshIntervalSavedAction].
/// Updates [RefreshSettingsState.intervalMinutes], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState refreshIntervalSavedReducer(
  RefreshSettingsState state,
  RefreshIntervalSavedAction action,
) => state.copyWith(
  intervalMinutes: action.intervalMinutes,
  isSaving: false,
  error: const None(),
);

/// Handles [RefreshIntervalSaveFailedAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState refreshIntervalSaveFailedReducer(
  RefreshSettingsState state,
  RefreshIntervalSaveFailedAction action,
) => state.copyWith(isSaving: false, error: Some(action.message));
