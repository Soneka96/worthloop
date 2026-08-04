// Package imports:
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/shared/constants/refresh_interval_constants.dart';

/// Redux state for refresh scheduling preferences.
@immutable
class RefreshSettingsState extends Equatable {
  /// Preferred refresh interval in minutes.
  final int intervalMinutes;

  /// Whether persisted settings are loading.
  final bool isLoading;

  /// Whether a new interval is being saved.
  final bool isSaving;

  /// Most recent persistence failure, or `null`.
  final String? error;

  const RefreshSettingsState({
    required this.intervalMinutes,
    required this.isLoading,
    required this.isSaving,
    required this.error,
  });

  /// Returns the state used before settings are loaded.
  factory RefreshSettingsState.initial() => const RefreshSettingsState(
    intervalMinutes: RefreshIntervalConstants.hourly,
    isLoading: false,
    isSaving: false,
    error: null,
  );

  /// Returns a copy with the supplied fields replaced.
  RefreshSettingsState copyWith({
    int? intervalMinutes,
    bool? isLoading,
    bool? isSaving,
    Option<String>? error,
  }) => RefreshSettingsState(
    intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    error: error == null ? this.error : error.toNullable(),
  );

  @override
  List<Object?> get props => [intervalMinutes, isLoading, isSaving, error];
}
