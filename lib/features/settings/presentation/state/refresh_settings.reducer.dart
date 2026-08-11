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
  /// Updates [RefreshSettingsState.intervalMinutes], [RefreshSettingsState.browserRefreshEnabled], [RefreshSettingsState.priceAlertsEnabled], [RefreshSettingsState.priceIncreaseAlertsEnabled], [RefreshSettingsState.refreshCompletedAlertsEnabled], [RefreshSettingsState.showRefreshProgress], [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshSettingsLoadedAction>(
    refreshSettingsLoadedReducer,
  ).call,

  /// Handles [SaveBrowserRefreshEnabledAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, SaveBrowserRefreshEnabledAction>(
    saveBrowserRefreshEnabledReducer,
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

  /// Handles [BrowserRefreshEnabledSavedAction].
  /// Updates [RefreshSettingsState.browserRefreshEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, BrowserRefreshEnabledSavedAction>(
    browserRefreshEnabledSavedReducer,
  ).call,

  /// Handles [BrowserRefreshSaveFailedAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, BrowserRefreshSaveFailedAction>(
    browserRefreshSaveFailedReducer,
  ).call,

  /// Handles [SavePriceAlertsEnabledAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, SavePriceAlertsEnabledAction>(
    savePriceAlertsEnabledReducer,
  ).call,

  /// Handles [PriceAlertsEnabledSavedAction].
  /// Updates [RefreshSettingsState.priceAlertsEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, PriceAlertsEnabledSavedAction>(
    priceAlertsEnabledSavedReducer,
  ).call,

  /// Handles [PriceAlertsSaveFailedAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, PriceAlertsSaveFailedAction>(
    priceAlertsSaveFailedReducer,
  ).call,

  /// Handles [SavePriceIncreaseAlertsEnabledAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, SavePriceIncreaseAlertsEnabledAction>(
    savePriceIncreaseAlertsEnabledReducer,
  ).call,

  /// Handles [PriceIncreaseAlertsEnabledSavedAction].
  /// Updates [RefreshSettingsState.priceIncreaseAlertsEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, PriceIncreaseAlertsEnabledSavedAction>(
    priceIncreaseAlertsEnabledSavedReducer,
  ).call,

  /// Handles [PriceIncreaseAlertsSaveFailedAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, PriceIncreaseAlertsSaveFailedAction>(
    priceIncreaseAlertsSaveFailedReducer,
  ).call,

  /// Handles [SaveRefreshCompletedAlertsEnabledAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, SaveRefreshCompletedAlertsEnabledAction>(
    saveRefreshCompletedAlertsEnabledReducer,
  ).call,

  /// Handles [RefreshCompletedAlertsEnabledSavedAction].
  /// Updates [RefreshSettingsState.refreshCompletedAlertsEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshCompletedAlertsEnabledSavedAction>(
    refreshCompletedAlertsEnabledSavedReducer,
  ).call,

  /// Handles [RefreshCompletedAlertsSaveFailedAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, RefreshCompletedAlertsSaveFailedAction>(
    refreshCompletedAlertsSaveFailedReducer,
  ).call,

  /// Handles [SaveShowRefreshProgressAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, SaveShowRefreshProgressAction>(
    saveShowRefreshProgressReducer,
  ).call,

  /// Handles [ShowRefreshProgressSavedAction].
  /// Updates [RefreshSettingsState.showRefreshProgress], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, ShowRefreshProgressSavedAction>(
    showRefreshProgressSavedReducer,
  ).call,

  /// Handles [ShowRefreshProgressSaveFailedAction].
  /// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
  TypedReducer<RefreshSettingsState, ShowRefreshProgressSaveFailedAction>(
    showRefreshProgressSaveFailedReducer,
  ).call,
]);

/// Handles [LoadRefreshSettingsAction].
/// Updates [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
RefreshSettingsState loadRefreshSettingsReducer(
  RefreshSettingsState state,
  LoadRefreshSettingsAction action,
) => state.copyWith(isLoading: true, error: const None());

/// Handles [RefreshSettingsLoadedAction].
/// Updates [RefreshSettingsState.intervalMinutes], [RefreshSettingsState.browserRefreshEnabled], [RefreshSettingsState.priceAlertsEnabled], [RefreshSettingsState.priceIncreaseAlertsEnabled], [RefreshSettingsState.refreshCompletedAlertsEnabled], [RefreshSettingsState.showRefreshProgress], [RefreshSettingsState.isLoading], [RefreshSettingsState.error].
RefreshSettingsState refreshSettingsLoadedReducer(
  RefreshSettingsState state,
  RefreshSettingsLoadedAction action,
) => state.copyWith(
  intervalMinutes: action.settings.intervalMinutes,
  browserRefreshEnabled: action.settings.browserRefreshEnabled,
  priceAlertsEnabled: action.settings.priceDropAlertsEnabled,
  priceIncreaseAlertsEnabled: action.settings.priceIncreaseAlertsEnabled,
  refreshCompletedAlertsEnabled: action.settings.refreshCompletedAlertsEnabled,
  showRefreshProgress: action.settings.showRefreshProgress,
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

/// Handles [SaveBrowserRefreshEnabledAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState saveBrowserRefreshEnabledReducer(
  RefreshSettingsState state,
  SaveBrowserRefreshEnabledAction action,
) => state.copyWith(isSaving: true, error: const None());

/// Handles [BrowserRefreshEnabledSavedAction].
/// Updates [RefreshSettingsState.browserRefreshEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState browserRefreshEnabledSavedReducer(
  RefreshSettingsState state,
  BrowserRefreshEnabledSavedAction action,
) => state.copyWith(
  browserRefreshEnabled: action.enabled,
  isSaving: false,
  error: const None(),
);

/// Handles [BrowserRefreshSaveFailedAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState browserRefreshSaveFailedReducer(
  RefreshSettingsState state,
  BrowserRefreshSaveFailedAction action,
) => state.copyWith(isSaving: false, error: Some(action.message));

/// Handles [SavePriceAlertsEnabledAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState savePriceAlertsEnabledReducer(
  RefreshSettingsState state,
  SavePriceAlertsEnabledAction action,
) => state.copyWith(isSaving: true, error: const None());

/// Handles [PriceAlertsEnabledSavedAction].
/// Updates [RefreshSettingsState.priceAlertsEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState priceAlertsEnabledSavedReducer(
  RefreshSettingsState state,
  PriceAlertsEnabledSavedAction action,
) => state.copyWith(
  priceAlertsEnabled: action.enabled,
  isSaving: false,
  error: const None(),
);

/// Handles [PriceAlertsSaveFailedAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState priceAlertsSaveFailedReducer(
  RefreshSettingsState state,
  PriceAlertsSaveFailedAction action,
) => state.copyWith(isSaving: false, error: Some(action.message));

/// Handles [SavePriceIncreaseAlertsEnabledAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState savePriceIncreaseAlertsEnabledReducer(
  RefreshSettingsState state,
  SavePriceIncreaseAlertsEnabledAction action,
) => state.copyWith(isSaving: true, error: const None());

/// Handles [PriceIncreaseAlertsEnabledSavedAction].
/// Updates [RefreshSettingsState.priceIncreaseAlertsEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState priceIncreaseAlertsEnabledSavedReducer(
  RefreshSettingsState state,
  PriceIncreaseAlertsEnabledSavedAction action,
) => state.copyWith(
  priceIncreaseAlertsEnabled: action.enabled,
  isSaving: false,
  error: const None(),
);

/// Handles [PriceIncreaseAlertsSaveFailedAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState priceIncreaseAlertsSaveFailedReducer(
  RefreshSettingsState state,
  PriceIncreaseAlertsSaveFailedAction action,
) => state.copyWith(isSaving: false, error: Some(action.message));

/// Handles [SaveRefreshCompletedAlertsEnabledAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState saveRefreshCompletedAlertsEnabledReducer(
  RefreshSettingsState state,
  SaveRefreshCompletedAlertsEnabledAction action,
) => state.copyWith(isSaving: true, error: const None());

/// Handles [RefreshCompletedAlertsEnabledSavedAction].
/// Updates [RefreshSettingsState.refreshCompletedAlertsEnabled], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState refreshCompletedAlertsEnabledSavedReducer(
  RefreshSettingsState state,
  RefreshCompletedAlertsEnabledSavedAction action,
) => state.copyWith(
  refreshCompletedAlertsEnabled: action.enabled,
  isSaving: false,
  error: const None(),
);

/// Handles [RefreshCompletedAlertsSaveFailedAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState refreshCompletedAlertsSaveFailedReducer(
  RefreshSettingsState state,
  RefreshCompletedAlertsSaveFailedAction action,
) => state.copyWith(isSaving: false, error: Some(action.message));

/// Handles [SaveShowRefreshProgressAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState saveShowRefreshProgressReducer(
  RefreshSettingsState state,
  SaveShowRefreshProgressAction action,
) => state.copyWith(isSaving: true, error: const None());

/// Handles [ShowRefreshProgressSavedAction].
/// Updates [RefreshSettingsState.showRefreshProgress], [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState showRefreshProgressSavedReducer(
  RefreshSettingsState state,
  ShowRefreshProgressSavedAction action,
) => state.copyWith(
  showRefreshProgress: action.enabled,
  isSaving: false,
  error: const None(),
);

/// Handles [ShowRefreshProgressSaveFailedAction].
/// Updates [RefreshSettingsState.isSaving], [RefreshSettingsState.error].
RefreshSettingsState showRefreshProgressSaveFailedReducer(
  RefreshSettingsState state,
  ShowRefreshProgressSaveFailedAction action,
) => state.copyWith(isSaving: false, error: Some(action.message));
