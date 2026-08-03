// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/usecases/clear_log_entries.usecase.dart';

/// Parameters for [ClearLogEntriesUseCase].
@immutable
class ClearLogEntriesParams extends Equatable {
  /// Deletes every entry logged at or before this moment. Captured by the
  /// caller at the moment of the request — never computed here or further
  /// down the chain — so an entry logged during the clear operation itself
  /// (e.g. an error thrown by the delete) is timestamped after it and survives.
  final DateTime cutoff;

  const ClearLogEntriesParams({required this.cutoff});

  @override
  List<Object?> get props => [cutoff];
}
