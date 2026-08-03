// Package imports:
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/usecases/export_log_entries.usecase.dart';

/// Parameters for [ExportLogEntriesUseCase].
@immutable
class ExportLogEntriesParams extends Equatable {
  /// The entries to write to the exported file.
  final List<LogEntry> entries;

  const ExportLogEntriesParams({required this.entries});

  @override
  List<Object?> get props => [entries];
}
