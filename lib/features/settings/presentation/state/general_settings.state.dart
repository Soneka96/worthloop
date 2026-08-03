// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Redux state for the General settings category.
@immutable
class GeneralSettingsState extends Equatable {
  /// The default folder for new projects, or `null` if none has been set.
  final String? defaultSaveLocation;

  /// The folder queued to become the new data root on next launch, or
  /// `null` if no move is pending.
  final String? pendingDataRoot;

  const GeneralSettingsState({
    required this.defaultSaveLocation,
    required this.pendingDataRoot,
  });

  /// Returns the default state, used until [GeneralSettingsState]'s
  /// persisted values are read and applied.
  factory GeneralSettingsState.initial() => const GeneralSettingsState(
    defaultSaveLocation: null,
    pendingDataRoot: null,
  );

  /// Returns a copy with the given fields replaced.
  GeneralSettingsState copyWith({
    String? defaultSaveLocation,
    String? pendingDataRoot,
  }) {
    return GeneralSettingsState(
      defaultSaveLocation: defaultSaveLocation ?? this.defaultSaveLocation,
      pendingDataRoot: pendingDataRoot ?? this.pendingDataRoot,
    );
  }

  @override
  List<Object?> get props => [
    defaultSaveLocation,
    pendingDataRoot,
  ];
}
