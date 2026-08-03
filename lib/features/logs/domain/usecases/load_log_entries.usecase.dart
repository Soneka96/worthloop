// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/entities/log_entry.entity.dart';
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/no_params.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Loads the retained log entries, newest first. Delegates to [ILogsRepository].
class LoadLogEntriesUseCase
    extends UseCase<Either<Failure, List<LogEntry>>, NoParams> {
  LoadLogEntriesUseCase(this._repository);

  /// Repository this use case delegates to.
  final ILogsRepository _repository;

  @override
  Future<Either<Failure, List<LogEntry>>> call(NoParams params) {
    return _repository.loadRecentLogEntries();
  }
}
