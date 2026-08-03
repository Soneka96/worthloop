// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
