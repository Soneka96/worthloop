// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/clear_log_entries.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Deletes every log entry logged at or before [ClearLogEntriesParams.cutoff].
/// Delegates to [ILogsRepository].
class ClearLogEntriesUseCase
    extends UseCase<Either<Failure, Unit>, ClearLogEntriesParams> {
  ClearLogEntriesUseCase(this._repository);

  /// Repository this use case delegates to.
  final ILogsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(ClearLogEntriesParams params) {
    return _repository.clearLogEntries(params.cutoff);
  }
}
