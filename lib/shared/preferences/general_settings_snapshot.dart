// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';

/// Every persisted General settings field, read from [AppPreferencesStore]
/// in one file read. Each field is `null` if it hasn't been saved yet.
class GeneralSettingsSnapshot extends Equatable {
  /// The default folder new projects are saved to.
  final String? defaultSaveLocation;

  /// The folder queued to become the new data root on next launch, or
  /// `null` if no move is pending.
  final String? pendingDataRoot;

  const GeneralSettingsSnapshot({
    required this.defaultSaveLocation,
    required this.pendingDataRoot,
  });

  @override
  List<Object?> get props => [
    defaultSaveLocation,
    pendingDataRoot,
  ];
}
