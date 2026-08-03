// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Requests loading the persisted General settings, on first mount.
@immutable
class LoadGeneralSettingsAction extends Equatable {
  const LoadGeneralSettingsAction();

  @override
  List<Object?> get props => [];
}

/// Dispatched by middleware once the persisted General settings have been
/// read from disk. Fields are `null` wherever nothing has been persisted yet.
@immutable
class GeneralSettingsLoadedAction extends Equatable {
  /// The default folder for new projects.
  final String? defaultSaveLocation;

  /// The folder queued to become the new data root on next launch, or
  /// `null` if no move is pending.
  final String? pendingDataRoot;

  const GeneralSettingsLoadedAction({
    required this.defaultSaveLocation,
    required this.pendingDataRoot,
  });

  @override
  List<Object?> get props => [
    defaultSaveLocation,
    pendingDataRoot,
  ];
}

/// Requests moving the app's data root to a newly browsed folder.
@immutable
class PickDefaultSaveLocationAction extends Equatable {
  /// The newly browsed folder.
  final String path;

  const PickDefaultSaveLocationAction(this.path);

  @override
  List<Object?> get props => [path];
}

/// Updates the folder queued to become the new data root on next launch,
/// or clears it once a pending move resolves (moved, cancelled, or already
/// at that location).
@immutable
class PendingDataRootUpdatedAction extends Equatable {
  /// The folder queued to become the new data root, or `null` if no move
  /// is pending.
  final String? pendingDataRoot;

  const PendingDataRootUpdatedAction(this.pendingDataRoot);

  @override
  List<Object?> get props => [pendingDataRoot];
}

/// Requests restarting the app immediately to apply a pending data-root move.
@immutable
class RestartNowAction extends Equatable {
  const RestartNowAction();

  @override
  List<Object?> get props => [];
}

/// Requests an update check.
@immutable
class CheckForUpdatesAction extends Equatable {
  const CheckForUpdatesAction();

  @override
  List<Object?> get props => [];
}

/// Requests opening the privacy policy.
@immutable
class OpenPrivacyPolicyAction extends Equatable {
  const OpenPrivacyPolicyAction();

  @override
  List<Object?> get props => [];
}
