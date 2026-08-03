// Package imports:
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/logs/domain/repositories/Ilogs.repository.dart';
import 'package:worth_loop/features/logs/domain/usecases/params/export_log_entries.params.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/usecase/usecase.dart';

/// Opens the platform save dialog and writes the given entries as plain
/// text if the user picks a location. Delegates to [ILogsRepository].
class ExportLogEntriesUseCase
    extends UseCase<Either<Failure, String?>, ExportLogEntriesParams> {
  ExportLogEntriesUseCase(this._repository);

  /// Repository this use case delegates to.
  final ILogsRepository _repository;

  @override
  Future<Either<Failure, String?>> call(ExportLogEntriesParams params) {
    return _repository.exportLogEntries(params.entries);
  }
}
